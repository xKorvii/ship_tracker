import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../components/order_detail_modal.dart';
import 'package:ship_tracker/theme/theme.dart';

class OrderCard extends StatelessWidget {
  final int orderId;
  final String codigo;
  final String direccion;
  final String estado;
  final Color estadoColor;
  final bool mostrarBotones;
  final String clientName;
  final String clientRut;
  final String deliveryWindow;
  final String notes;
  final double latitude;
  final double longitude;
  final bool allowUndo;

  const OrderCard({
    super.key,
    required this.orderId,
    required this.codigo,
    required this.direccion,
    required this.estado,
    required this.estadoColor,
    this.mostrarBotones = true,
    this.allowUndo = false,
    required this.clientName,
    required this.clientRut,
    required this.deliveryWindow,
    required this.notes,
    required this.latitude,     
    required this.longitude,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        showModalBottomSheet(
          context: context,
          backgroundColor: transparencia,
          isScrollControlled: true,
          builder: (_) => OrderDetailModal(
            mostrarBotones: mostrarBotones,
            allowUndo: allowUndo,
            orderId: orderId,
            codigo: codigo,
            direccion: direccion,
            clientName: clientName,
            clientRut: clientRut,
            deliveryWindow: deliveryWindow,
            notes: notes,
            latitude: latitude,
            longitude: longitude,
          ),
        );
      },
      child: Container(
        margin: const EdgeInsets.symmetric(vertical: 6),
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
          color: blanco,
          borderRadius: BorderRadius.circular(12),
          boxShadow: [
            BoxShadow(
              color: gris,
              blurRadius: 4,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    '#$codigo',
                    style: GoogleFonts.inter(
                      fontWeight: FontWeight.bold,
                      color: negro,
                      fontSize: 15,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Row(
                    children: [
                      Icon(Icons.location_on, color: negro, size: 16),
                      SizedBox(width: 4),
                      Expanded(
                        child: Text(
                          direccion,
                          style: GoogleFonts.inter(
                            fontSize: 13,
                            color: negro,
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 6),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                    decoration: BoxDecoration(
                      color: estadoColor.withOpacity(0.2),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Text(
                      estado,
                      style: GoogleFonts.inter(
                        fontSize: 12,
                        fontWeight: FontWeight.w600,
                        color: estadoColor,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Image.asset('images/box.png', width: 55),
          ],
        ),
      ),
    );
  }
}