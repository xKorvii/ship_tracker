import 'package:flutter/services.dart';

class RutFormatter extends TextInputFormatter {
  @override
  TextEditingValue formatEditUpdate(
    TextEditingValue oldValue,
    TextEditingValue newValue,
  ) {
    final String newText = newValue.text;
    
    // Si el usuario está borrando, se permite la acción sin formatear para no bloquearlo
    if (newText.length < oldValue.text.length) {
      return newValue;
    }

    // Limpiar el texto 
    String rut = newText.replaceAll(RegExp(r'[^0-9kK]'), '');
    
    // Limitar el largo máximo 
    if (rut.length > 9) {
      rut = rut.substring(0, 9);
    }

    String formattedRut = '';
    
    // Lógica de formato
    if (rut.length <= 1) {
      formattedRut = rut;
    } else {
      // El último caracter siempre lo tratamos como verificador si hay más de 1
      String body = rut.substring(0, rut.length - 1);
      String dv = rut.substring(rut.length - 1);
      
      // Agregamos puntos al cuerpo
      String bodyWithDots = '';
      int counter = 0;
      for (int i = body.length - 1; i >= 0; i--) {
        bodyWithDots = body[i] + bodyWithDots;
        counter++;
        if (counter == 3 && i != 0) {
          bodyWithDots = '.$bodyWithDots';
          counter = 0;
        }
      }
      
      formattedRut = '$bodyWithDots-$dv';
    }

    return TextEditingValue(
      text: formattedRut,
      selection: TextSelection.collapsed(offset: formattedRut.length),
    );
  }
}