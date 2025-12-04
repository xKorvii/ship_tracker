import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:ship_tracker/components/text_field.dart';
import 'package:ship_tracker/utils/validators.dart';
import 'package:ship_tracker/components/button.dart';
import 'package:ship_tracker/theme/theme.dart';
import 'package:ship_tracker/components/bottom_navbar.dart';
import 'package:ship_tracker/pages/home.dart';
import 'package:ship_tracker/utils/rut_formatter.dart';

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

  bool _isSaving = false;

  Future<bool> _goBackToHome() async {
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => const HomePage()),
    );
    return false;
  }

  @override
  void dispose() {
    _nameController.dispose();
    _lastNameController.dispose();
    _rutController.dispose();
    _phoneController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
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

    setState(() => _isSaving = true);
    await Future.delayed(const Duration(seconds: 2));
    if (!mounted) return;
    setState(() => _isSaving = false);

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('¡Perfil actualizado correctamente!'),
        backgroundColor: verde,
      ),
    );

    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => const HomePage()),
    );
  }

  @override
  Widget build(BuildContext context) {
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
                padding:
                    const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                child: SingleChildScrollView(
                  physics: const BouncingScrollPhysics(),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      const SizedBox(height: 16),
                      Center(
                        child: Stack(
                          alignment: Alignment.center,
                          children: [
                            CircleAvatar(
                              radius: 40,
                              backgroundColor: gris,
                              child: Icon(
                                Icons.person_outline,
                                size: 50,
                                color: negro,
                              ),
                            ),
                            Positioned(
                              bottom: 0,
                              right: 0,
                              child: GestureDetector(
                                onTap: () {

                                },
                                child: Container(
                                  padding: const EdgeInsets.all(6),
                                  decoration: BoxDecoration(
                                    color: verde,
                                    shape: BoxShape.circle,
                                    boxShadow: [
                                      BoxShadow(
                                        color: negro,
                                        blurRadius: 4,
                                        offset: const Offset(0, 2),
                                      ),
                                    ],
                                  ),
                                  child: Icon(
                                    Icons.edit,
                                    color: blanco,
                                    size: 18,
                                  ),
                                ),
                              ),
                            ),
                          ],
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
                        keyboardType: TextInputType.phone,
                      ),
                      const SizedBox(height: 12),
                      CustomTextField(
                        key: _emailKey,
                        labelText: 'Correo electrónico',
                        controller: _emailController,
                        validator: Validators.validateEmail,
                        keyboardType: TextInputType.emailAddress,
                      ),
                      const SizedBox(height: 12),
                      CustomTextField(
                        key: _passwordKey,
                        labelText: 'Contraseña',
                        obscureText: true,
                        controller: _passwordController,
                        validator: Validators.validatePassword,
                      ),
                      const SizedBox(height: 48),
                      CustomButton(
                        text: 'Guardar cambios',
                        backgroundColor: azulOscuro,
                        textColor: blanco,
                        onPressed: _isSaving ? null : _saveProfile,
                      ),
                    ],
                  ),
                ),
              ),
              if (_isSaving)
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