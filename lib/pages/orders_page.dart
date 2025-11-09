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

class OrdersPage extends StatefulWidget {
  const OrdersPage({super.key});

  @override
  State<OrdersPage> createState() => _OrdersPageState();
}

class _OrdersPageState extends State<OrdersPage> {
  Future<bool> _goBackToHome() async {
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => const HomePage()),
    );
    return false; 
  }

  @override
  Widget build(BuildContext context) {
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
            child: SingleChildScrollView(
              physics: const BouncingScrollPhysics(),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  const WelcomeHeader(),
                  const SizedBox(height: 16),
                  const Search(),
                  const SizedBox(height: 10),
                  const OrderFilter(),
                  const SizedBox(height: 16),
                  OrderCard(
                    codigo: 'ABCD-1234',
                    direccion: 'Av. San Miguel 3605, Talca',
                    estado: 'Completado',
                    estadoColor: verdeClaro,
                    mostrarBotones: false,
                  ),
                  OrderCard(
                    codigo: 'LKJH-9876',
                    direccion: 'Av. San Miguel 3605, Talca',
                    estado: 'Completado',
                    estadoColor: verdeClaro,
                    mostrarBotones: false,
                  ),
                  OrderCard(
                    codigo: 'XYZA-4521',
                    direccion: 'Av. San Miguel 3605, Talca',
                    estado: 'Cancelado',
                    estadoColor: rojo,
                    mostrarBotones: false,
                  ),
                ],
              ),
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