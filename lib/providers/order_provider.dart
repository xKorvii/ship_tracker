import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../models/order_model.dart';

class OrderProvider extends ChangeNotifier {
  final _supabase = Supabase.instance.client;
  
  List<OrderModel> _orders = [];
  bool _isLoading = false;

  List<OrderModel> get orders => _orders;
  bool get isLoading => _isLoading;

  // cargar pedidos desde Supabase
  Future<void> fetchOrders() async {
    final user = _supabase.auth.currentUser;
    if (user == null) return;

    _isLoading = true;
    notifyListeners(); // Avisar a la UI que muestre carga

    try {
      final response = await _supabase
          .from('orders')
          .select()
          .eq('user_id', user.id) // Solo pedidos de este usuario
          .order('created_at', ascending: false); // Más recientes primero

      final data = response as List<dynamic>;
      _orders = data.map((json) => OrderModel.fromMap(json)).toList();
      
    } catch (e) {
      print('Error cargando pedidos: $e');
    } finally {
      _isLoading = false;
      notifyListeners(); // Avisar a la UI que ya están los datos
    }
  }

  // Actualizar el estado (Completado/Cancelado)
  Future<void> updateOrderStatus(int orderId, String newStatus) async {
    try {
      await _supabase
          .from('orders')
          .update({'status': newStatus})
          .eq('id', orderId); // Busca por ID único del pedido

      // Actualizamos la lista local
      await fetchOrders();
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
      );

      await _supabase.from('orders').insert(newOrder.toMap());
      await fetchOrders();
      
    } catch (e) {
      print('Error creando pedido: $e');
      rethrow; // Re-lanzar error para manejarlo en la UI 
    }
  }
  void clearData() {
    _orders = [];
    _isLoading = false;
    notifyListeners();
  }
}