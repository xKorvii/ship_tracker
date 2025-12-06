class Validators {
  static String? validateName(String? value) {
    if (value == null || value.isEmpty) {
      return 'El nombre no puede estar vacío.';
    }
    return null;
  }

  static String? validateLastName(String? value) {
    if (value == null || value.isEmpty) {
      return 'El apellido no puede estar vacío.';
    }
    return null;
  }

  static String? validateRut(String? value) {
    if (value == null || value.isEmpty) {
      return 'El RUT no puede estar vacío.';
    }
    final RegExp rutRegExp = RegExp(r'^(\d{1,2}\.\d{3}\.\d{3}-[\dkK])$');
    if (!rutRegExp.hasMatch(value)) {
      return 'Formato de RUT inválido (ej: 12.345.678-9).';
    }
    return null;
  }

  static String? validatePhone(String? value) {
    if (value == null || value.isEmpty) {
      return 'El teléfono no puede estar vacío.';
    }
    if (!RegExp(r'^\d+$').hasMatch(value)) {
      return 'Solo se permiten números.';
    }
    if (value.length != 8) {
      return 'El número debe tener 8 dígitos.';
    }
    return null;
  }

  static String? validateEmail(String? value) {
    if (value == null || value.isEmpty) {
      return 'El correo no puede estar vacío.';
    }
    final RegExp emailRegExp = RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$');
    if (!emailRegExp.hasMatch(value)) {
      return 'Formato de correo inválido.';
    }
    return null;
  }

  static String? validatePassword(String? value) {
    if (value == null || value.isEmpty) {
      return 'La contraseña no puede estar vacía.';
    }
    if (value.length < 8) {
      return 'La contraseña debe tener al menos 8 caracteres.';
    }
    if (!value.contains(RegExp(r'[A-Z]'))) {
      return 'La contraseña debe contener al menos una mayúscula.';
    }
    if (!value.contains(RegExp(r'[a-z]'))) {
      return 'La contraseña debe contener al menos una minúscula.';
    }
    if (!value.contains(RegExp(r'''[!@#$%^&*(),.?":{}|<>[\]\\\/~`_+=;'-]'''))) {
      return 'La contraseña debe contener al menos un carácter especial.';
    }
    return null;
  }
}