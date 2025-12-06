import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class UserProvider extends ChangeNotifier {
  final _supabase = Supabase.instance.client;

  String? _firstName;
  String? _lastName;
  String? _rut;
  String? _phone;
  String? _email;
  bool _isLoading = false;

  String get firstName => _firstName ?? '';
  String get lastName => _lastName ?? '';
  String get fullName => '$_firstName $_lastName';
  String get rut => _rut ?? '';
  String get phone => _phone ?? '';
  String get email => _email ?? '';
  bool get isLoading => _isLoading;

  // Cargar perfil del usuario actual
  Future<void> loadProfile() async {
    final user = _supabase.auth.currentUser;
    if (user == null) return;

    _isLoading = true;
    notifyListeners();

    try {
      _email = user.email;
      
      final metadata = user.userMetadata; 
      
      _firstName = metadata?['first_name'] ?? '';
      _lastName = metadata?['last_name'] ?? '';
      _rut = metadata?['rut'] ?? '';
      _phone = metadata?['phone'] ?? ''; 

    } catch (e) {
      print('Error cargando perfil: $e');
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  // Verificar contraseña actual
  Future<bool> verifyPassword(String password) async {
    final email = _supabase.auth.currentUser?.email;
    if (email == null) return false;

    try {
      await _supabase.auth.signInWithPassword(
        email: email,
        password: password,
      );
      return true;
    } catch (e) {
      return false;
    }
  }

  // Actualizar perfil
  Future<void> updateProfile({
    required String firstName,
    required String lastName,
    required String rut,
    required String phone,
    String? password,
  }) async {
    try {
      _isLoading = true;
      notifyListeners();

      // Actualizar metadata del usuario en Supabase
      final userAttributes = UserAttributes(
        password: password,
        data: {
          'first_name': firstName,
          'last_name': lastName,
          'rut': rut,
          'phone': phone,
        },
      );

      await _supabase.auth.updateUser(userAttributes);

      // Actualizamos las variables locales
      _firstName = firstName;
      _lastName = lastName;
      _rut = rut;
      _phone = phone;

    } catch (e) {
      print('Error actualizando perfil: $e');
      rethrow;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }
}