import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:ship_tracker/theme/theme.dart';

class WelcomeHeader extends StatelessWidget {
  const WelcomeHeader({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(10),
      decoration: BoxDecoration(
        color: blanco,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Row(
        children: [
          CircleAvatar(
            radius: 22,
            backgroundColor:verdeClaro,
            backgroundImage: AssetImage('images/profilepic.jpg'),
          ),
          SizedBox(width: 10),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('Bienvenido!', style: TextStyle(color: grisOscuro)),
              Text(
                'Nombre Apellido',
                style: GoogleFonts.archivoBlack(
                  fontSize: 18,
                  color: negro,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}