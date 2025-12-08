import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:ship_tracker/components/text_field.dart';
import 'package:ship_tracker/utils/validators.dart';
import 'package:ship_tracker/components/button.dart';
import 'package:ship_tracker/theme/theme.dart';
import 'package:ship_tracker/components/bottom_navbar.dart';
import 'package:ship_tracker/pages/home.dart';
import 'package:ship_tracker/utils/rut_formatter.dart';
import 'package:provider/provider.dart';
import 'package:ship_tracker/providers/user_provider.dart';
import 'dart:io';
import 'package:image_picker/image_picker.dart';
import 'package:ship_tracker/components/user_avatar.dart';

class EditProfilePage extends StatefulWidget {
  const EditProfilePage({super.key});

  @override
  State<EditProfilePage> createState() => _EditProfilePageState();
}

class _EditProfilePageState extends State<EditProfilePage> {
  final _nameController = TextEditingController();
  final _lastNameController = TextEditingController();
  final _rutController = TextEditingController();
  final _phoneController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();

  final _nameKey = GlobalKey<CustomTextFieldState>();
  final _lastNameKey = GlobalKey<CustomTextFieldState>();
  final _rutKey = GlobalKey<CustomTextFieldState>();
  final _phoneKey = GlobalKey<CustomTextFieldState>();
  final _emailKey = GlobalKey<CustomTextFieldState>();
  final _passwordKey = GlobalKey<CustomTextFieldState>();
  final _currentPasswordController = TextEditingController();
  final _currentPasswordKey = GlobalKey<CustomTextFieldState>();

  Future<bool> _goBackToHome() async {
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => const HomePage()),
    );
    return false;
  }

  // Seleccionar imagen
  void _pickImage() {
    showModalBottomSheet(
      context: context,
      builder: (BuildContext context) {
        return SafeArea(
          child: Wrap(
            children: <Widget>[
              ListTile(
                leading: const Icon(Icons.photo_library),
                title: const Text('Galería'),
                onTap: () {
                  Navigator.of(context).pop();
                  _getImageFromSource(ImageSource.gallery);
                },
              ),
              ListTile(
                leading: const Icon(Icons.camera_alt),
                title: const Text('Cámara'),
                onTap: () {
                  Navigator.of(context).pop();
                  _getImageFromSource(ImageSource.camera);
                },
              ),
            ],
          ),
        );
      },
    );
  }

  // Procesa la imagen según la fuente elegida
  Future<void> _getImageFromSource(ImageSource source) async {
    try {
      final ImagePicker picker = ImagePicker();
      final XFile? image = await picker.pickImage(source: source, imageQuality: 80);

      if (image != null) {
        final File imageFile = File(image.path);
        _uploadSelectedImage(imageFile);
      }
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error al obtener imagen: $e'), backgroundColor: rojo),
      );
    }
  }

  // Subir imagen
  Future<void> _uploadSelectedImage(File imageFile) async {
    try {
      await Provider.of<UserProvider>(context, listen: false).uploadProfilePhoto(imageFile);
       
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: const Text('Foto actualizada'), backgroundColor: verde),
      );
    } catch (e) {
       if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error subiendo imagen: $e'), backgroundColor: rojo),
      );
    }
  }

  @override
  void initState() {
    super.initState();
    final userProvider = Provider.of<UserProvider>(context, listen: false);
    _nameController.text = userProvider.firstName;
    _lastNameController.text = userProvider.lastName;
    _rutController.text = userProvider.rut;
    _emailController.text = userProvider.email; 
    
    String rawPhone = userProvider.phone;
    if (rawPhone.startsWith('+569')) {
      _phoneController.text = rawPhone.substring(4);
    } else {
      _phoneController.text = rawPhone;
    }
  }

  @override
  void dispose() {
    _nameController.dispose();
    _lastNameController.dispose();
    _rutController.dispose();
    _phoneController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    _currentPasswordController.dispose(); 
    super.dispose();
  }

  Future<void> _saveProfile() async {
    final errors = [
      _nameKey.currentState?.validate(),
      _lastNameKey.currentState?.validate(),
      _rutKey.currentState?.validate(),
      _phoneKey.currentState?.validate(),
      _emailKey.currentState?.validate(),
      _passwordKey.currentState?.validate(), 
      _currentPasswordKey.currentState?.validate(),
    ];

    if (errors.any((e) => e != null)) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Por favor, corrige los campos con error.'),
          backgroundColor: rojo,
        ),
      );
      return;
    }

    // Validación campo contraseña
    if (_passwordKey.currentState?.validate() != null) {
      return; 
    }

    try {
      final isValid = await Provider.of<UserProvider>(context, listen: false)
        .verifyPassword(_currentPasswordController.text.trim());

      if (!isValid) {
        if (!mounted) return;
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('La contraseña actual es incorrecta.'), 
            backgroundColor: rojo
          ),
        );
        return;
      }

      String? newPassword;
      if (_passwordController.text.isNotEmpty) {
        newPassword = _passwordController.text.trim();
      }

      await Provider.of<UserProvider>(context, listen: false).updateProfile(
        firstName: _nameController.text.trim(),
        lastName: _lastNameController.text.trim(),
        rut: _rutController.text.trim(),
        phone: '+569${_phoneController.text.trim()}', // Formatear teléfono
        password: newPassword,
      );

      if (!mounted) return;

      // Limpiar campo contraseña
      _currentPasswordController.clear();
      _passwordController.clear();

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('¡Datos actualizados correctamente!'),
          backgroundColor: verde,
        ),
      );
      
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => const HomePage()),
      );

    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error al guardar: $e'), backgroundColor: rojo),
      );
    } 
  }

  @override
  Widget build(BuildContext context) {
    final userProvider = Provider.of<UserProvider>(context);
    final isLoading = userProvider.isLoading;

    return PopScope(
      canPop: false,
      onPopInvokedWithResult: (didPop, result) {
        if (!didPop) {
          _goBackToHome();
        }
      },
      child: GestureDetector(
        onTap: () => FocusScope.of(context).unfocus(),
        child: Scaffold(
          backgroundColor: blanco,
          appBar: AppBar(
            backgroundColor: verde,
            foregroundColor: blanco,
            elevation: 0,
            automaticallyImplyLeading: true,
            title: Text(
              'Editar perfil',
              style: GoogleFonts.archivoBlack(
                fontSize: 20,
                color: blanco,
              ),
            ),
            centerTitle: true,
            leading: IconButton(
              icon: const Icon(Icons.arrow_back_ios_new_rounded),
              onPressed: () {
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(builder: (context) => const HomePage()),
                );
              },
            ),
          ),
          body: Stack(
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                child: SingleChildScrollView(
                  physics: const BouncingScrollPhysics(),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      const SizedBox(height: 16),
                      Center(
                        child: UserAvatar(
                          radius: 50,
                          photoUrl: userProvider.photoUrl, 
                          onTap: isLoading ? null : _pickImage, 
                        ),
                      ),
                      const SizedBox(height: 24),
                      CustomTextField(
                        key: _nameKey,
                        labelText: 'Nombre',
                        controller: _nameController,
                        validator: Validators.validateName,
                      ),
                      const SizedBox(height: 12),
                      CustomTextField(
                        key: _lastNameKey,
                        labelText: 'Apellido',
                        controller: _lastNameController,
                        validator: Validators.validateLastName,
                      ),
                      const SizedBox(height: 12),
                      CustomTextField(
                        key: _rutKey,
                        labelText: 'RUT',
                        controller: _rutController,
                        keyboardType: TextInputType.text,
                        inputFormatters: [
                          RutFormatter(),
                        ],
                        validator: Validators.validateRut,
                      ),
                      const SizedBox(height: 12),
                      CustomTextField(
                        key: _phoneKey,
                        labelText: 'Teléfono',
                        controller: _phoneController,
                        validator: Validators.validatePhone,
                        keyboardType: TextInputType.number,
                        maxLength: 8,
                        prefix: Container(
                          margin: const EdgeInsets.only(right: 10, left: 10),
                          padding: const EdgeInsets.only(right: 10),
                          decoration: BoxDecoration(
                            border: Border(
                              right: BorderSide(color: grisOscuro, width: 1),
                            ),
                          ),
                          child: Text(
                            '🇨🇱 +56 9',
                            style: GoogleFonts.inter(
                              color: negro,
                              fontWeight: FontWeight.bold,
                              fontSize: 14,
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(height: 12),
                      CustomTextField(
                        key: _emailKey,
                        labelText: 'Correo electrónico',
                        controller: _emailController,
                        validator: Validators.validateEmail,
                        keyboardType: TextInputType.emailAddress,
                        readOnly: true,
                      ),
                      const SizedBox(height: 12),
                      CustomTextField(
                        key: _currentPasswordKey, 
                        labelText: 'Contraseña Actual (Obligatoria)', 
                        obscureText: true,
                        controller: _currentPasswordController,
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Requerido para guardar cambios.';
                          }
                          return null;
                        },
                      ),
                      const SizedBox(height: 12),
                      CustomTextField(
                        key: _passwordKey,
                        labelText: 'Nueva Contraseña',
                        obscureText: true,
                        controller: _passwordController,
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return null; 
                          }
                          if (value.length < 8) {
                            return 'Mínimo 8 caracteres';
                          }
                          return Validators.validatePassword(value); 
                        },
                      ),
                      const SizedBox(height: 48),
                      CustomButton(
                        text: 'Guardar cambios',
                        backgroundColor: azulOscuro,
                        textColor: blanco,
                        onPressed: isLoading ? null : _saveProfile,
                      ),
                    ],
                  ),
                ),
              ),
              if (isLoading)
                Container(
                  color: Colors.black.withAlpha(128),
                  child: const Center(
                    child: CircularProgressIndicator(),
                  ),
                ),
            ],
          ),
          bottomNavigationBar: const BottomNavBar(selectedIndex: 3),
        ),
      ),
    );
  }
}