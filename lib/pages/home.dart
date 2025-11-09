import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:ship_tracker/components/bottom_navbar.dart';
import 'package:ship_tracker/components/order_card.dart';
import 'package:ship_tracker/components/welcome_header.dart';
import 'package:ship_tracker/components/search_bar.dart';
import 'package:ship_tracker/pages/create_order_page.dart';
import 'package:ship_tracker/pages/login_page.dart';
import 'package:ship_tracker/theme/theme.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
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

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        final shouldLogout = await _confirmLogout();
        if (shouldLogout) {
        }
        return false; 
      },
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
              style: GoogleFonts.archivoBlack(
                fontSize: 20,
                color: blanco,
              ),
            ),
            centerTitle: true,
            actions: [
              IconButton(
                icon: const Icon(Icons.logout),
                onPressed: () async {
                  final confirm = await _confirmLogout();
                  if (confirm) {
                    Navigator.pushReplacement(context, MaterialPageRoute(builder: (_) => const LoginPage()));
                  }
                },
              ),
            ],
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
                  OrderCard(
                    codigo: 'ABCD-1234',
                    direccion: 'Av. San Miguel 3605, Talca',
                    estado: 'Pendiente',
                    estadoColor: amarillo,
                  ),
                  OrderCard(
                    codigo: 'LKJH-9876',
                    direccion: 'Av. San Miguel 3605, Talca',
                    estado: 'Pendiente',
                    estadoColor: amarillo,
                  ),
                  OrderCard(
                    codigo: 'XYZA-4521',
                    direccion: 'Av. San Miguel 3605, Talca',
                    estado: 'Pendiente',
                    estadoColor: amarillo,
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