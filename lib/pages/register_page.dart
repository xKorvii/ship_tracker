import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:ship_tracker/components/text_field.dart';
import 'package:ship_tracker/pages/login_page.dart';
import 'package:ship_tracker/utils/validators.dart';
import '../components/button.dart';
import 'package:ship_tracker/theme/theme.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:ship_tracker/utils/auth_errors.dart';

class RegisterPage extends StatefulWidget {
  const RegisterPage({super.key});

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
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

  bool _isLoading = false;

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

  Future<void> _register() async {
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

    setState(() {
      _isLoading = true;
    });

    try {
      // Llamada a Supabase Auth
      await Supabase.instance.client.auth.signUp(
        email: _emailController.text.trim(),
        password: _passwordController.text.trim(),
        data: {
          // Enviar datos extra como metadata del usuario
          'first_name': _nameController.text.trim(),
          'last_name': _lastNameController.text.trim(),
          'rut': _rutController.text.trim(),
          'phone': _phoneController.text.trim(),
        },
      );

      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('¡Registro exitoso! Por favor inicia sesión.'),
          backgroundColor: verde,
        ),
      );

      // Redirigir al Login
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => const LoginPage()),
      );

    } on AuthException catch (e) {
      // Traductor de errores
      final mensajeEsp = AuthErrorTranslator.translate(e.message);
      
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(mensajeEsp),
          backgroundColor: rojo,
        ),
      );
    } catch (e) {
      // Manejo de errores generales
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Ocurrió un error inesperado: $e'),
          backgroundColor: rojo,
        ),
      );
    } finally {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => FocusScope.of(context).unfocus(),
      child: Scaffold(
        backgroundColor: blanco,
        appBar: AppBar(
          backgroundColor: verde,
          foregroundColor: blanco,
          elevation: 0,
          title: Text(
            'Registro',
            style: GoogleFonts.archivoBlack(
              fontSize: 20,
              color: blanco,
            ),
          ),
          centerTitle: true,
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
                              onTap: () {},
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
                      validator: Validators.validateRut,
                      keyboardType: TextInputType.text,
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
                      text: 'Registrarse',
                      backgroundColor: azulOscuro,
                      textColor: blanco,
                      onPressed: _isLoading ? null : _register,
                    ),
                  ],
                ),
              ),
            ),

            if (_isLoading)
              Container(
                color: negro,
                child: const Center(
                  child: CircularProgressIndicator(),
                ),
              ),
          ],
        ),
      ),
    );
  }
}
