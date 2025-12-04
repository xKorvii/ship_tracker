import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:ship_tracker/pages/order_canceled.dart';
import 'package:ship_tracker/pages/order_completed.dart';
import '../components/button.dart';
import 'package:ship_tracker/theme/theme.dart';
import 'package:provider/provider.dart';
import 'package:ship_tracker/providers/order_provider.dart';

class OrderDetailModal extends StatelessWidget {
  final bool mostrarBotones;
  final int orderId;
  final String codigo;
  final String direccion;
  final String clientName;
  final String clientRut;
  final String deliveryWindow;
  final String notes;

  const OrderDetailModal({
    super.key,
    this.mostrarBotones = true,
    required this.orderId,
    required this.codigo,
    required this.direccion,
    required this.clientName,
    required this.clientRut,
    required this.deliveryWindow,
    required this.notes,
  });

  @override
  Widget build(BuildContext context) {
      return Container(
      height: 480,
      decoration: BoxDecoration(
        color: azulOscuro,
        borderRadius: const BorderRadius.vertical(top: Radius.circular(24)),
      ),
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const CircleAvatar(radius: 24, backgroundImage: AssetImage('images/profilepic.jpg')),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      clientName, // Variable directa
                      style: GoogleFonts.inter(color: blanco, fontWeight: FontWeight.bold, fontSize: 16),
                      overflow: TextOverflow.ellipsis,
                    ),
                    if (clientRut.isNotEmpty)
                      Text(
                        clientRut, // Variable directa
                        style: GoogleFonts.inter(color: Colors.white70, fontSize: 13),
                      ),
                  ],
                ),
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Text(
                    'Pedido',
                    style: GoogleFonts.inter(color: Colors.white54, fontSize: 10),
                  ),
                  Text(
                    '#$codigo',
                    style: GoogleFonts.inter(
                      color: blanco,
                      fontWeight: FontWeight.w600,
                      fontSize: 16,
                    ),
                  ),
                ],
              ),
            ],
          ),
          const Divider(color: Colors.white24, height: 30),
          Text(
            'Detalle del envío:',
            style: GoogleFonts.inter(
              color: blanco,
              fontWeight: FontWeight.bold,
              fontSize: 15,
            ),
          ),
          const SizedBox(height: 12),
          
          // Dirección
          _infoRow(Icons.location_on, direccion, verde),
          
          // Horario
          if (deliveryWindow.isNotEmpty) 
            Padding(
              padding: const EdgeInsets.only(top: 8),
              child: _infoRow(Icons.access_time, deliveryWindow, amarillo),
            ),

          // Notas
          if (notes.isNotEmpty)
            Padding(
              padding: const EdgeInsets.only(top: 8),
              child: _infoRow(Icons.sticky_note_2_outlined, notes, Colors.white70),
            ),

          const SizedBox(height: 16),
          
          // Mapa
          Expanded(
            child: ClipRRect(
              borderRadius: BorderRadius.circular(12),
              child: Image.asset(
                'images/map.jpg',
                fit: BoxFit.cover,
                width: double.infinity,
              ),
            ),
          ),
          
          const SizedBox(height: 20),

          // Botones
          if (mostrarBotones)
            Row(
              children: [
                Expanded(
                  child: CustomButton(
                    text: 'Confirmar',
                    backgroundColor: verdeClaro,
                    textColor: blanco,
                    height: 45, 
                    onPressed: () async {
                      // Llamar a Supabase
                      await Provider.of<OrderProvider>(context, listen: false)
                          .updateOrderStatus(orderId, 'Completado');
                      
                      if (!context.mounted) return;
                      
                      // Navegar a la pantalla de éxito
                      Navigator.pushReplacement( 
                        context,
                        MaterialPageRoute(builder: (context) => const OrderSuccessPage()),
                      );
                    },
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: CustomButton(
                    text: 'Cancelar',
                    backgroundColor: rojo,
                    textColor: blanco,
                    height: 45,
                    onPressed: () async {
                      // Llamar a Supabase
                      await Provider.of<OrderProvider>(context, listen: false)
                          .updateOrderStatus(orderId, 'Cancelado');

                      if (!context.mounted) return;

                      // Navegar a la pantalla de cancelado
                      Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(builder: (context) => const CancelOrderSuccessPage()),
                      );
                    },
                  ),
                ),
              ],
            ),
        ],
      ),
    );
  }

  // Widget auxiliar para las filas de información
  Widget _infoRow(IconData icon, String text, Color iconColor) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Icon(icon, color: iconColor, size: 18),
        const SizedBox(width: 8),
        Expanded(
          child: Text(
            text,
            style: GoogleFonts.inter(color: blanco, fontSize: 13),
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
          ),
        ),
      ],
    );
  }
}