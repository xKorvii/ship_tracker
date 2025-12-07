import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:ship_tracker/pages/home.dart';
import 'package:ship_tracker/pages/register_page.dart';
import '../components/text_field.dart'; 
import '../components/button.dart';
import 'package:ship_tracker/theme/theme.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:ship_tracker/utils/auth_errors.dart';
import 'package:provider/provider.dart';
import 'package:ship_tracker/providers/user_provider.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final _emailKey = GlobalKey<CustomTextFieldState>();
  final _passwordKey = GlobalKey<CustomTextFieldState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();

  void _showErrorDialog(String message) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Error de inicio de sesión'),
          content: Text(message),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('Aceptar'),
            ),
          ],
        );//
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: gris,
      body: Center(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Image.asset('images/logo.png', height: 120),
                const SizedBox(height: 16),
                Text(
                  'Ship-Tracker',
                  style: GoogleFonts.archivoBlack(
                    fontSize: 25,
                    color: verde,
                  ),
                ),
                const SizedBox(height: 48), 

                CustomTextField(
                  key: _emailKey,
                  labelText: 'Correo electrónico',
                  keyboardType: TextInputType.emailAddress,
                  controller: _emailController,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Por favor, ingrese su correo electrónico';
                    }
                    if (!RegExp(r'^[^@]+@[^@]+\.[^@]+').hasMatch(value)) {
                      return 'Por favor, ingrese un correo electrónico válido';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 16),
                CustomTextField(
                  key: _passwordKey,
                  labelText: 'Contraseña',
                  obscureText: true,
                  controller: _passwordController,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Por favor, ingrese su contraseña';
                    }
                    if (value.length < 8) {
                      return 'La contraseña debe tener al menos 8 caracteres';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 24),

                CustomButton(
                  text: 'Iniciar Sesión',
                  onPressed: () async { 
                    final emailError = _emailKey.currentState?.validate();
                    final passwordError = _passwordKey.currentState?.validate();

                    if (emailError != null || passwordError != null) {
                      return;
                    }                 
                    final email = _emailController.text.trim();
                    final password = _passwordController.text.trim();

                    try {
                        // Intento de inicio de sesión real
                        await Supabase.instance.client.auth.signInWithPassword(
                          email: email,
                          password: password,
                        );

                        if (mounted) {
                          await Provider.of<UserProvider>(context, listen: false).loadProfile();
                          Navigator.pushReplacement(
                            context,
                            MaterialPageRoute(builder: (context) => const HomePage()),
                          );
                        }
                      } on AuthException catch (e) {
                        // Traductor de errores
                        final mensajeEsp= AuthErrorTranslator.translate(e.message);
                        _showErrorDialog(mensajeEsp);
                      } catch (e) {
                        _showErrorDialog('Ocurrió un error inesperado. Intenta nuevamente.');
                      }
                  },
                ),

              SizedBox(height: 16),

              CustomButton(
                text: 'Registrarse',
                backgroundColor: blanco,
                textColor: verde,
                onPressed: () {
                  Navigator.push(context, 
                  MaterialPageRoute(builder: (context) => const RegisterPage()),
                  );
                },
              ),

              SizedBox(height: 16),

              Text(
                '¿No tienes una cuenta? ¡Regístrate aquí!',
                style: TextStyle(
                  fontSize: 15,
                  color: grisOscuro,
                ),
              ),
            ],
          ),
        ),
      ),
      ),
    );
  }
}
