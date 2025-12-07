import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:ship_tracker/theme/theme.dart';
import 'package:ship_tracker/providers/user_provider.dart';
import 'package:ship_tracker/components/user_avatar.dart';

class WelcomeHeader extends StatelessWidget {
  const WelcomeHeader({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<UserProvider>(
      builder: (context, userProvider, child) {
        return Container(
          padding: EdgeInsets.all(10),
          decoration: BoxDecoration(
            color: blanco,
            borderRadius: BorderRadius.circular(20),
          ),
          child: Row(
            children: [
              UserAvatar( 
              radius: 22,
              photoUrl: userProvider.photoUrl, 
              ),
              SizedBox(width: 10),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Bienvenido!', style: TextStyle(color: grisOscuro)),
                  Text(
                      userProvider.isLoading 
                          ? 'Cargando...' 
                          : userProvider.fullName.isEmpty 
                              ? 'Usuario' 
                              : userProvider.fullName, // Nombre del usuario
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
      },
    );
  }
}