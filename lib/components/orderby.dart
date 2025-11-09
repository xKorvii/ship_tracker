import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:ship_tracker/theme/theme.dart';

class OrderFilter extends StatelessWidget {
  final VoidCallback? onTap; 
  const OrderFilter({super.key, this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
        decoration: BoxDecoration(
          color: gris, 
          borderRadius: BorderRadius.circular(12),
        ),
        child: Row(
          children: [
            Icon(
              Icons.sort, 
              color: verde,
              size: 22,
            ),
            const SizedBox(width: 10),
            Text(
              'Ordenar por',
              style: GoogleFonts.inter(
                color: grisOscuro,
                fontSize: 14,
              ),
            ),
            const Spacer(),
            Icon(
              Icons.keyboard_arrow_down_rounded,
              color: gris,
              size: 20,
            ),
          ],
        ),
      ),
    );
  }
}