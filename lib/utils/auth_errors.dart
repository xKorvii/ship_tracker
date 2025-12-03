class AuthErrorTranslator {
  static String translate(String originalMessage) {
    final message = originalMessage.toLowerCase();

    if (message.contains('invalid login credentials')) {
      return 'Correo o contraseña incorrectos.';
    } else if (message.contains('user already registered')) {
      return 'Este correo ya está registrado.';
    } else if (message.contains('password should be at least')) {
      return 'La contraseña es muy corta (mínimo 6 caracteres).';
    } else if (message.contains('invalid email')) {
      return 'El formato del correo no es válido.';
    } else if (message.contains('network request failed')) {
      return 'Error de conexión. Revisa tu internet.';
    }  
    // Mensaje por defecto 
    return 'Ocurrió un error: $originalMessage';
  }
}