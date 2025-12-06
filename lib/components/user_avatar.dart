import 'dart:io';
import 'package:flutter/material.dart';
import 'package:ship_tracker/theme/theme.dart';

class UserAvatar extends StatelessWidget {
  final String? photoUrl;
  final File? localImage;
  final double radius;
  final VoidCallback? onTap;

  const UserAvatar({
    super.key,
    this.photoUrl,
    this.localImage,
    this.radius = 40,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    ImageProvider? backgroundImage;

    // Decidir qué imagen mostrar
    if (localImage != null) {
      backgroundImage = FileImage(localImage!);
    } else if (photoUrl != null && photoUrl!.isNotEmpty) {
      backgroundImage = NetworkImage(photoUrl!);
    }

    return GestureDetector(
      onTap: onTap,
      child: Stack(
        children: [
          CircleAvatar(
            radius: radius,
            backgroundColor: gris,
            backgroundImage: backgroundImage,
            child: backgroundImage == null
                ? Icon(Icons.person_outline, size: radius * 1.2, color: negro)
                : null,
          ),
          if (onTap != null)
            Positioned(
              bottom: 0,
              right: 0,
              child: Container(
                padding: const EdgeInsets.all(6),
                decoration: BoxDecoration(
                  color: verde,
                  shape: BoxShape.circle,
                  border: Border.all(color: blanco, width: 2),
                ),
                child: Icon(Icons.camera_alt, color: blanco, size: 16),
              ),
            ),
        ],
      ),
    );
  }
}