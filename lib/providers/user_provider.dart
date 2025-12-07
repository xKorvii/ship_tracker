import 'dart:io';
import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class UserProvider extends ChangeNotifier {
  final _supabase = Supabase.instance.client;

  String? _firstName;
  String? _lastName;
  String? _rut;
  String? _phone;
  String? _email;
  String? _photoUrl;
  bool _isLoading = false;

  String get firstName => _firstName ?? '';
  String get lastName => _lastName ?? '';
  String get fullName => '$firstName $lastName'.trim();
  String get rut => _rut ?? '';
  String get phone => _phone ?? '';
  String get email => _email ?? '';
  String? get photoUrl => _photoUrl;
  bool get isLoading => _isLoading;

  // cargar perfil del usuario actual
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
      _photoUrl = metadata?['photo_url'];

    } catch (e) {
      print('Error cargando perfil: $e');
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  // Funcion para subir foto y actualizar perfil
  Future<void> uploadProfilePhoto(File imageFile) async {
    final user= _supabase.auth.currentUser;
    if (user==null) return;

    try {
      _isLoading = true;
      notifyListeners();

      // Ruta del archivo en Supabase Storage
      final fileExtension = imageFile.path.split('.').last;
      final filePath = '${user.id}/avatar.$fileExtension';

      // Subir el archivo a avatars
      await _supabase.storage.from('avatars').upload(
            filePath,
            imageFile,
            fileOptions: const FileOptions(upsert: true),
          );

      // obtener url de supabase
      final urlBase = _supabase.storage.from('avatars').getPublicUrl(filePath);
      final imageUrl = '$urlBase?v=${DateTime.now().millisecondsSinceEpoch}';;
      await _supabase.auth.updateUser(
        UserAttributes(
          data: {
            'photo_url': imageUrl,
          },
        ),
      );

      _photoUrl = imageUrl;
      print('Foto subida exitosamente: $imageUrl');

    } catch (e) {
      print('Error subiendo foto: $e');
      rethrow; 
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
  void clearData() {
    _firstName = null;
    _lastName = null;
    _rut = null;
    _phone = null;
    _email = null;
    _photoUrl = null;
    notifyListeners();
  }
}