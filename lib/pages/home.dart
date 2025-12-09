import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:ship_tracker/components/bottom_navbar.dart';
import 'package:ship_tracker/components/order_card.dart';
import 'package:ship_tracker/components/welcome_header.dart';
import 'package:ship_tracker/components/search_bar.dart';
import 'package:ship_tracker/pages/create_order_page.dart';
import 'package:ship_tracker/pages/login_page.dart';
import 'package:ship_tracker/theme/theme.dart';
import 'package:provider/provider.dart';
import 'package:ship_tracker/providers/order_provider.dart';
import 'package:ship_tracker/providers/user_provider.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:ship_tracker/models/order_model.dart';


class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  String _searchQuery = '';
  @override
  void initState() {
    super.initState();
    // Carga inicial
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _loadData();
    });
  }

  // Función para cargar datos
  Future<void> _loadData() async {
    final orderProvider = Provider.of<OrderProvider>(context, listen: false);
    await Future.wait([
      orderProvider.fetchOrders(),
      orderProvider.fetchAndComputeStats(),
    ]);
  }

  Future<bool> _confirmLogout() async {
    final result = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Cerrar sesión'),
        content: const Text('¿Deseas cerrar sesión y salir de la aplicación?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('Cancelar'),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context, true),
            child: const Text('Cerrar sesión'),
          ),
        ],
      ),
    );
    return result ?? false;
  }

  // Función para filtrar pedidos pendientes
  List<OrderModel> _getFilteredPendingOrders(List<OrderModel> allOrders) {
    var list = allOrders.where((o) => o.status == 'Pendiente').toList();

    // filtramos adicionalmente por ID o Nombre
    if (_searchQuery.isNotEmpty) {
      final query = _searchQuery.toLowerCase();
      list = list.where((order) {
        final code = order.code.toLowerCase();
        final name = order.clientName.toLowerCase();
        return code.contains(query) || name.contains(query);
      }).toList();
    }
    
    return list;
  }

  @override
  Widget build(BuildContext context) {
    final orderProvider = Provider.of<OrderProvider>(context);
    final pedidosPendientes = _getFilteredPendingOrders(orderProvider.orders);

    return WillPopScope(
      onWillPop: () async => false,
      child: GestureDetector(
        onTap: () => FocusScope.of(context).unfocus(),
        child: Scaffold(
          appBar: AppBar(
            backgroundColor: verde,
            foregroundColor: blanco,
            automaticallyImplyLeading: false,
            elevation: 0,
            title: Text(
              'Inicio',
              style: GoogleFonts.archivoBlack(fontSize: 20, color: blanco),
            ),
            centerTitle: true,
            actions: [
              IconButton(
                icon: const Icon(Icons.logout),
                onPressed: () async {
                  final confirm = await _confirmLogout();
                  if (confirm) {
                    await Supabase.instance.client.auth.signOut();
                    if (!context.mounted) return;
                    Provider.of<OrderProvider>(context, listen: false).clearData();
                    Provider.of<UserProvider>(context, listen: false).clearData();
                    Navigator.pushReplacement(
                        context, MaterialPageRoute(builder: (_) => const LoginPage()));
                  }
                },
              ),
            ],
          ),

          backgroundColor: blanco,
          
          body: RefreshIndicator(
            onRefresh: _loadData,
            color: verde,
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: CustomScrollView(
                physics: const AlwaysScrollableScrollPhysics(),
                slivers: [
                  SliverToBoxAdapter(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        const SizedBox(height: 10),
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
                      ],
                    ),
                  ),

                  if (orderProvider.isLoading)
                    const SliverFillRemaining(
                      hasScrollBody: false,
                      child: Center(child: CircularProgressIndicator()),
                    )
                  else if (pedidosPendientes.isEmpty)
                    SliverFillRemaining(
                      hasScrollBody: false,
                      child: Center(
                        child: Text(
                          _searchQuery.isEmpty 
                            ? "No tienes pedidos pendientes" 
                            : "No se encontraron pedidos",
                          style: TextStyle(color: grisOscuro),
                        ),
                      ),
                    )
                  else
                    SliverList(
                      delegate: SliverChildBuilderDelegate(
                        (context, index) {
                          final order = pedidosPendientes[index];
                          return OrderCard(
                            orderId: order.id!,
                            codigo: order.code,
                            direccion: order.address,
                            estado: order.status,
                            estadoColor: amarillo,
                            clientName: order.clientName,
                            clientRut: order.clientRut,
                            deliveryWindow: order.deliveryWindow,
                            notes: order.notes,
                            latitude: order.latitude,
                            longitude: order.longitude,
                          );
                        },
                        childCount: pedidosPendientes.length,
                      ),
                    ),

                  const SliverToBoxAdapter(
                    child: SizedBox(height: 100),
                  ),
                ],
              ),
            ),
          ),

          bottomNavigationBar: const BottomNavBar(selectedIndex: 0),
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
                      color: negro, blurRadius: 6, offset: const Offset(0, 3)),
                ],
              ),
              child: Icon(Icons.add, color: blanco, size: 32),
            ),
          ),
          floatingActionButtonLocation:
            FloatingActionButtonLocation.centerDocked,
        ),
      ),
    );
  }
}