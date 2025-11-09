import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:ship_tracker/pages/order_canceled.dart';
import 'package:ship_tracker/pages/order_completed.dart';
import '../components/button.dart';
import 'package:ship_tracker/theme/theme.dart';

class OrderDetailModal extends StatelessWidget {
  final bool mostrarBotones;

  const OrderDetailModal({super.key, this.mostrarBotones = true});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 330,
      decoration: BoxDecoration(
        color: azulOscuro,
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const CircleAvatar(radius: 20, backgroundImage: AssetImage('images/profilepic.jpg')),
              const SizedBox(width: 10),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('María Becerra',
                      style: GoogleFonts.inter(color: blanco, fontWeight: FontWeight.bold)),
                  Text('12.901.345-K', style: GoogleFonts.inter(color: blanco)),
                ],
              ),
              const Spacer(),
              Text('#ABCD-1234',
                  style: GoogleFonts.inter(color: blanco, fontWeight: FontWeight.w600)),
            ],
          ),
          const SizedBox(height: 18),
          Text('Detalle del envío:',
              style: GoogleFonts.inter(color: blanco, fontWeight: FontWeight.bold)),
          const SizedBox(height: 10),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              _infoItem(Icons.access_time, '08:00'),
              _infoItem(Icons.schedule, '12:00'),
              _infoItem(Icons.location_on, '27 Sur 954'),
            ],
          ),
          const SizedBox(height: 16),
          ClipRRect(
            borderRadius: BorderRadius.circular(12),
            child: Image.asset('images/map.jpg', fit: BoxFit.cover, height: 100, width: double.infinity),
          ),
          const SizedBox(height: 16),
          if (mostrarBotones)
            Row(
              children: [
                Expanded(
                  child: CustomButton(
                    text: 'Confirmar',
                    backgroundColor: verdeClaro,
                    textColor: blanco,
                    onPressed: () {
                      Navigator.push(
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
                    onPressed: () {
                      Navigator.push(
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

  Widget _infoItem(IconData icon, String label) {
    return Row(
      children: [
        Icon(icon, color: blanco, size: 18),
        const SizedBox(width: 4),
        Text(label, style: GoogleFonts.inter(color: blanco)),
      ],
    );
  }


}