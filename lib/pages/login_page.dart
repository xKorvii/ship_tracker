import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:ship_tracker/pages/home.dart';
import 'package:ship_tracker/pages/register_page.dart';
import '../components/text_field.dart'; 
import '../components/button.dart';
import 'package:ship_tracker/theme/theme.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final _formKey = GlobalKey<FormState>();
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
          child: Form(
            key: _formKey,
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
                  onPressed: () {
                    if (_formKey.currentState!.validate()) {
                      final email = _emailController.text;
                      final password = _passwordController.text;
                      final validUsers = {
                        'nico@gmail.com': '12345678',
                        'martin@gmail.com': 'contra123',
                      };

                      if (validUsers.containsKey(email) && validUsers[email] == password) {
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => const HomePage()),
                        );
                      } else {
                        _showErrorDialog('Correo electrónico o contraseña incorrectos.');
                      }
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
