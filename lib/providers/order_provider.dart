import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../models/order_model.dart';

class OrderProvider extends ChangeNotifier {
  final _supabase = Supabase.instance.client;
  
  List<OrderModel> _orders = [];
  bool _isLoading = false;

  // Almacenar datos calculados para stats
  Map<String, dynamic> _statsData = {
    'totals': {'Completado': '0', 'Pendiente': '0', 'Cancelado': '0'},
    'weeklySummary': {'completados': List<int>.filled(7, 0), 'pendientes': List<int>.filled(7, 0), 'cancelados': List<int>.filled(7, 0)},
    'monthlyRates': <int>[],
    'hasData': false,
  };

  List<OrderModel> get orders => _orders;
  bool get isLoading => _isLoading;
  Map<String, dynamic> get statsData => _statsData; 

  Future<void> fetchOrders() async {
    final user = _supabase.auth.currentUser;
    if (user == null) return;

    _isLoading = true;
    notifyListeners();

    try {
      final response = await _supabase
          .from('orders')
          .select()
          .eq('user_id', user.id) 
          .order('created_at', ascending: false); // pedidos mas recientes primero

      final data = response as List<dynamic>;
      // Actualiza la lista principal de pedidos
      _orders = data.map((json) => OrderModel.fromMap(json)).toList();
      
    } catch (e) {
      print('Error cargando pedidos: $e');
    } finally {
      _isLoading = false;
      notifyListeners(); 
    }
  }

  // Actualiza el estado (Completado/Cancelado)
  Future<void> updateOrderStatus(int orderId, String newStatus) async {
    try {
      await _supabase
          .from('orders')
          .update({'status': newStatus})
          .eq('id', orderId);

      // Actualiza la lista local y refresca estadísticas
      await fetchOrders();
      await fetchAndComputeStats(); 

    } catch (e) {
      print('Error al actualizar estado: $e');
      rethrow;
    }
  }

  // Crear nuevo pedido
  Future<void> addOrder({
    required String code,
    required String address,
    required String clientName,
    required String clientRut,
    required String deliveryWindow,
    required String notes,
    required double latitude,
    required double longitude,
  }) async {
    final user = _supabase.auth.currentUser;
    if (user == null) return;

    try {
      final newOrder = OrderModel(
        userId: user.id,
        code: code,
        address: address,
        status: 'Pendiente',
        clientName: clientName,
        clientRut: clientRut,
        deliveryWindow: deliveryWindow,
        notes: notes,
        latitude: latitude,
        longitude: longitude,
      );

      await _supabase.from('orders').insert(newOrder.toMap());
      
      await fetchOrders();
      await fetchAndComputeStats();
      
    } catch (e) {
      print('Error creando pedido: $e');
      rethrow; 
    }
  }

  // logica para calcular todas las estadísticas
  Future<void> fetchAndComputeStats() async {
    final user = _supabase.auth.currentUser;
    if (user == null) return;

    _isLoading = true;
    notifyListeners();

    try {
      // Obtener los pedidos
      final response = await _supabase
          .from('orders')
          .select()
          .eq('user_id', user.id)
          .order('created_at', ascending: false);

      final allOrders = (response as List<dynamic>).map((json) => OrderModel.fromMap(json)).toList();

      _statsData['hasData'] = allOrders.isNotEmpty;
      
      if (allOrders.isEmpty) {
        _statsData = {
          'totals': {'Completado': '0', 'Pendiente': '0', 'Cancelado': '0'},
          'weeklySummary': {'completados': List<int>.filled(7, 0), 'pendientes': List<int>.filled(7, 0), 'cancelados': List<int>.filled(7, 0)},
          'monthlyRates': [],
          'hasData': false,
        };
        notifyListeners();
        return;
      }
      
      // calculo totales (tarjetas)
      int totalCompletados = allOrders.where((o) => o.status == 'Completado').length;
      int totalPendientes = allOrders.where((o) => o.status == 'Pendiente').length;
      int totalCancelados = allOrders.where((o) => o.status == 'Cancelado').length;
      
      _statsData['totals'] = {
        'Completado': totalCompletados.toString(),
        'Pendiente': totalPendientes.toString(),
        'Cancelado': totalCancelados.toString(),
      };

      // resumen semanal (barras)
      List<int> weeklyCompletados = List.filled(7, 0);
      List<int> weeklyPendientes = List.filled(7, 0);
      List<int> weeklyCancelados = List.filled(7, 0);

      final now = DateTime.now();
      
      for (var order in allOrders) {
        final orderDate = order.createdAt;
        if (orderDate != null && orderDate.isAfter(now.subtract(const Duration(days: 7)))) { 
          int dayIndex = orderDate.weekday - 1; 

          if (dayIndex >= 0 && dayIndex < 7) {
            switch (order.status) {
              case 'Completado':
                weeklyCompletados[dayIndex]++;
                break;
              case 'Pendiente':
                weeklyPendientes[dayIndex]++;
                break;
              case 'Cancelado':
                weeklyCancelados[dayIndex]++;
                break;
            }
          }
        }
      }
      
      _statsData['weeklySummary'] = {
        'completados': weeklyCompletados,
        'pendientes': weeklyPendientes,
        'cancelados': weeklyCancelados,
      };

      // tasas de exitos (mensual)
      Map<String, List<OrderModel>> ordersByMonth = {};
      for (var order in allOrders) {
        if (order.createdAt != null) {
          final key = '${order.createdAt!.year}-${order.createdAt!.month.toString().padLeft(2, '0')}';
          ordersByMonth.putIfAbsent(key, () => []).add(order);
        }
      }

      List<Map<String, dynamic>> monthlySuccessRates = [];
      ordersByMonth.forEach((key, orders) {
        final completed = orders.where((o) => o.status == 'Completado').length;
        final canceled = orders.where((o) => o.status == 'Cancelado').length;
        final totalFinished = completed + canceled;
        
        double successRate = totalFinished > 0 ? (completed / totalFinished) * 100 : 0.0;
        
        monthlySuccessRates.add({
          'monthKey': key,
          'rate': successRate.toInt(),
        });
      });

      // ordenar por mes 
      monthlySuccessRates.sort((a, b) => a['monthKey'].compareTo(b['monthKey']));
      
      final int startIndex = monthlySuccessRates.length > 5
          ? monthlySuccessRates.length - 5
          : 0;
          
      final List<Map<String, dynamic>> last5Rates = 
          monthlySuccessRates.sublist(startIndex);

      List<int> rates = last5Rates.map<int>((m) => m['rate'] as int).toList();

      // 5 puntos
      while (rates.length < 5) { 
          rates.insert(0, 0); 
      } 
      
      _statsData['monthlyRates'] = rates;

    } catch (e) {
      print('Error cargando y computando estadísticas: $e');
      _statsData['hasData'] = false;
      _statsData['totals'] = {'Completado': '0', 'Pendiente': '0', 'Cancelado': '0'};
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  void clearData() {
    _orders = [];
    _isLoading = false;
    _statsData = { // limpiar estadisticas al cerrar sesion
      'totals': {'Completado': '0', 'Pendiente': '0', 'Cancelado': '0'},
      'weeklySummary': {'completados': List<int>.filled(7, 0), 'pendientes': List<int>.filled(7, 0), 'cancelados': List<int>.filled(7, 0)},
      'monthlyRates': [],
      'hasData': false,
    };
    notifyListeners();
  }
}