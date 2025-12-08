import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:ship_tracker/theme/theme.dart';

class Search extends StatelessWidget {
  final ValueChanged<String>? onChanged;
  
  const Search({
    super.key,
    this.onChanged,
    });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 4),
      decoration: BoxDecoration(
        color: gris, 
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        children: [
          Icon(
            Icons.search,
            color: verde,
            size: 22,
          ),
          SizedBox(width: 10),

          Expanded(
            child: TextField(
              onChanged: onChanged,
              cursorColor: verde,
              style: GoogleFonts.inter(
                fontSize: 14,
                color: negro,
              ),
              decoration: InputDecoration(
                isDense: true, 
                border: InputBorder.none, 
                hintText: 'Buscar por ID o Cliente',
                hintStyle: GoogleFonts.inter(
                  color: grisOscuro,
                  fontSize: 14,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}