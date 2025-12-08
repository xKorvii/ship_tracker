import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:ship_tracker/components/bottom_navbar.dart';
import 'package:ship_tracker/components/order_card.dart';
import 'package:ship_tracker/components/orderby.dart';
import 'package:ship_tracker/components/welcome_header.dart';
import 'package:ship_tracker/components/search_bar.dart';
import 'package:ship_tracker/pages/create_order_page.dart';
import 'package:ship_tracker/pages/home.dart';
import 'package:ship_tracker/theme/theme.dart';
import 'package:provider/provider.dart';
//import 'package:ship_tracker/components/orderby.dart';
import 'package:ship_tracker/providers/order_provider.dart';
import 'package:ship_tracker/models/order_model.dart';

class OrdersPage extends StatefulWidget {
  const OrdersPage({super.key});

  @override
  State<OrdersPage> createState() => _OrdersPageState();
}

class _OrdersPageState extends State<OrdersPage> {
  String _searchQuery = '';
  bool _showNewestFirst = true;// mas recientes primero

  Future<bool> _goBackToHome() async {
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => const HomePage()),
    );
    return false; 
  }

  // Función para mostrar el menú de ordenamiento
  void _showSortOptions() {
    showModalBottomSheet(
      context: context,
      backgroundColor: blanco,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) {
        return SafeArea(
          child: Wrap(
            children: [
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: Text('Ordenar por fecha', style: GoogleFonts.archivoBlack(fontSize: 18)),
              ),
              ListTile(
                leading: Icon(Icons.arrow_downward, color: verde),
                title: const Text('Más recientes primero'),
                trailing: _showNewestFirst ? Icon(Icons.check, color: verde) : null,
                onTap: () {
                  setState(() => _showNewestFirst = true);
                  Navigator.pop(context);
                },
              ),
              ListTile(
                leading: Icon(Icons.arrow_upward, color: verde),
                title: const Text('Más antiguos primero'),
                trailing: !_showNewestFirst ? Icon(Icons.check, color: verde) : null,
                onTap: () {
                  setState(() => _showNewestFirst = false);
                  Navigator.pop(context);
                },
              ),
              const SizedBox(height: 20),
            ],
          ),
        );
      },
    );
  }

    List<OrderModel> _getFilteredOrders(List<OrderModel> allOrders) {
      // filtro solo el historial
      var list = allOrders.where((o) => o.status != 'Pendiente').toList();

      // aplicar busqueda
      if (_searchQuery.isNotEmpty) {
        final query = _searchQuery.toLowerCase();
        list = list.where((order) {
          final code = order.code.toLowerCase();
          final name = order.clientName.toLowerCase();
          return code.contains(query) || name.contains(query);
        }).toList();
      }

      // aplicar ordenamiento por fecha
      list.sort((a, b) {
        final dateA = a.createdAt ?? DateTime(0);
        final dateB = b.createdAt ?? DateTime(0);
        
        return _showNewestFirst 
            ? dateB.compareTo(dateA)
            : dateA.compareTo(dateB);
      });

      return list;
    }

  @override
  Widget build(BuildContext context) {
    final orderProvider = Provider.of<OrderProvider>(context);

    // usar la función para obtener la lista procesadas
    final historialFiltrado = _getFilteredOrders(orderProvider.orders);
        
    return PopScope(
      canPop: false,
      onPopInvokedWithResult: (didPop, result) {
        if (!didPop) {
          _goBackToHome();
        }
      }, 
      child: GestureDetector(
        onTap: () => FocusScope.of(context).unfocus(),
        child: Scaffold(
          appBar: AppBar(
            backgroundColor: verde,
            foregroundColor: blanco,
            elevation: 0,
            automaticallyImplyLeading: true, 
            title: Text(
              'Historial de órdenes',
              style: GoogleFonts.archivoBlack(
                fontSize: 20,
                color: blanco,
              ),
            ),
            centerTitle: true,
            leading: IconButton(
              icon: const Icon(Icons.arrow_back_ios_new_rounded),
              onPressed: () {
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(builder: (context) => const HomePage()),
                );
              },
            ),
          ),

          backgroundColor: blanco,

          body: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                const WelcomeHeader(),
                const SizedBox(height: 16),
                Search(
                  onChanged: (value) {
                    setState(() {
                      _searchQuery = value;
                    });
                  },
                ),
                const SizedBox(height: 10),
                OrderFilter(
                  onTap: _showSortOptions,
                ),
                const SizedBox(height: 16),
                
                Expanded(
                  child: historialFiltrado.isEmpty
                      ? Center(
                          child: Text(
                            _searchQuery.isEmpty 
                                ? "No hay historial de pedidos" 
                                : "No se encontraron resultados",
                            style: TextStyle(color: grisOscuro),
                          ),
                        )
                      : ListView.builder(
                          itemCount: historialFiltrado.length,
                          itemBuilder: (context, index) {
                            final order = historialFiltrado[index];
                            return OrderCard(
                              orderId: order.id!,
                              codigo: order.code,
                              direccion: order.address,
                              estado: order.status,
                              estadoColor: order.status == 'Completado' ? verdeClaro : rojo,
                              mostrarBotones: false,
                              clientName: order.clientName,
                              clientRut: order.clientRut,
                              deliveryWindow: order.deliveryWindow,
                              notes: order.notes,
                              latitude: order.latitude,
                              longitude: order.longitude,
                            );
                          },
                        ),
                ),
              ],
            ),
          ),

          bottomNavigationBar: const BottomNavBar(selectedIndex: 1),

          floatingActionButton: GestureDetector(
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const CreateOrderPage()),
              );
            },
            child: Container(
              height: 60,
              width: 60,
              decoration: BoxDecoration(
                color: verde,
                shape: BoxShape.circle,
                boxShadow: [
                  BoxShadow(
                    color: negro,
                    blurRadius: 6,
                    offset: const Offset(0, 3),
                  ),
                ],
              ),
              child: Icon(Icons.add, color: blanco, size: 32),
            ),
          ),
          floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
        ),
      ),
    );
  }
}