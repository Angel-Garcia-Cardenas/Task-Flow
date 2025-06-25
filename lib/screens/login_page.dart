import 'package:flutter/material.dart';
import '../widgets/button.dart';
import '../widgets/my_textfield.dart';
import './register_page.dart';
import './home_screen.dart';

class LoginPage extends StatelessWidget {
  LoginPage({super.key});


  // Notifier for email field validity
  final ValueNotifier<bool> _emailValidNotifier = ValueNotifier<bool>(true);
  // Notifier for password field validity
  final ValueNotifier<bool> _passwordValidNotifier = ValueNotifier<bool>(true);

  // text editing controllers
  final emailController = TextEditingController();
  final passwordController = TextEditingController();

  // sign user in method
  void signUserIn(BuildContext context) {

    // 1. Validar los ValueNotifier<bool>
    if (!_emailValidNotifier.value ||
        !_passwordValidNotifier.value) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Por favor, corrige los campos inválidos')),
      );
      return;
    }

    if (emailController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Por favor, ingresa tu correo electrónico')),
      );
      return;
    }
    if (passwordController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Por favor, ingresa tu contraseña')),
      );
      return;
    }

    Future.delayed(const Duration(milliseconds: 500), () {
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(builder: (context) => HomeScreen()),
      );
    });

    emailController.clear();
    passwordController.clear();

  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFEFF3F9),
      body: SafeArea(
        child: Center(
          child: ListView(
            shrinkWrap: true,
            children: [
              // logo
              const Icon(
                Icons.access_time_rounded,
                size: 100,
                color: Colors.blue,
              ),

              Align(
                alignment: Alignment.center,
                child: Text(
                  'Task Flow',
                  style: TextStyle(
                    color: Colors.black,
                    fontSize: 40,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              const SizedBox(height: 3),
              Align(
                alignment: Alignment.center,
                child: Text(
                  'Organiza tu día, alcanza tus metas.',
                  style: TextStyle(
                    color: Colors.grey[800],
                    fontSize: 16,
                  ),
                ),
              ),

              const SizedBox(height: 50),
              Align(
                alignment: Alignment.center,
                child: Text(
                  'Iniciar Sesión',
                  style: TextStyle(
                    color: Colors.black,
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              const SizedBox(height: 8),
              Align(
                alignment: Alignment.center,
                child: Text(
                  'Accede a tu cuenta para continuar.',
                  style: TextStyle(
                    color: Colors.grey[800],
                    fontSize: 14,
                  ),
                ),
              ),

              const SizedBox(height: 25),

              Padding(
                padding: const EdgeInsets.only(left: 30.0),
                child: Align(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    'Correo electrónico',
                    style: TextStyle(
                      color: Colors.black,
                      fontSize: 17,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 8),

              ValueListenableBuilder<bool>(
                valueListenable: _emailValidNotifier,
                builder: (context, isValid, child) {
                  return Focus(
                    onFocusChange: (hasFocus) {
                      if (!hasFocus) {
                        final email = emailController.text;
                        final valid = RegExp(r"^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$").hasMatch(email) && email.isNotEmpty;
                        _emailValidNotifier.value = valid;
                        (context as Element).markNeedsBuild();
                      }
                    },
                    child: StatefulBuilder(
                      builder: (context, setState) {
                        return Column(
                          children: [
                            MyTextField(
                              controller: emailController,
                              hintText: 'tuemail@email.com',
                              prefixIcon: Icon(Icons.mail_outline, color: Colors.blue),
                              obscureText: false,
                            ),
                            Padding(
                              padding: const EdgeInsets.symmetric(horizontal: 25.0, vertical: 4.0),
                              child: Builder(
                                builder: (context) {
                                  String email = emailController.text;
                                  String? errorText;

                                  if (!isValid && email.isNotEmpty) {
                                    errorText = 'Formato de correo inválido';
                                  }

                                  return errorText != null
                                      ? Text(
                                    errorText,
                                    style: const TextStyle(color: Colors.red, fontSize: 13),
                                  )
                                      : const SizedBox.shrink();
                                },
                              ),
                            ),
                          ],
                        );
                      },
                    ),
                  );
                },
              ),

              const SizedBox(height: 10),

              // password textfield
              Padding(
                padding: const EdgeInsets.only(left: 30.0),
                child: Align(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    'Contraseña',
                    style: TextStyle(
                      color: Colors.black,
                      fontSize: 17,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 8),

              ValueListenableBuilder<bool>(
                valueListenable: _passwordValidNotifier,
                builder: (context, isValid, child) {
                  return Focus(
                    onFocusChange: (hasFocus) {
                      if (!hasFocus) {
                        final password = passwordController.text;
                        bool hasLower = RegExp(r'[a-z]').hasMatch(password);
                        bool hasUpper = RegExp(r'[A-Z]').hasMatch(password);
                        bool hasTwoDigits = RegExp(r'(?:\D*\d){2,}').hasMatch(password);
                        bool hasSymbol = RegExp(r'[!@=#/\$%&*(),.?:]').hasMatch(password);
                        bool validLength = password.length >= 8 && password.length <= 12;
                        final valid = hasLower && hasUpper && hasTwoDigits && hasSymbol && validLength;
                        _passwordValidNotifier.value = valid;
                        (context as Element).markNeedsBuild();
                      }
                    },
                    child: StatefulBuilder(
                      builder: (context, setState) {
                        return Column(
                          children: [
                            MyTextField(
                              controller: passwordController,
                              hintText: 'Tu contraseña',
                              prefixIcon: Icon(Icons.lock_outline, color: Colors.blue),
                              obscureText: true,
                            ),
                            Padding(
                              padding: const EdgeInsets.symmetric(horizontal: 25.0, vertical: 4.0),
                              child: Builder(
                                builder: (context) {
                                  String password = passwordController.text;
                                  String? errorText;

                                  if (!isValid && password.isNotEmpty) {
                                    bool hasLower = RegExp(r'[a-z]').hasMatch(password);
                                    bool hasUpper = RegExp(r'[A-Z]').hasMatch(password);
                                    bool hasTwoDigits = RegExp(r'(?:\D*\d){2,}').hasMatch(password);
                                    bool hasSymbol = RegExp(r'[!@=#/\$%&*(),.?:]').hasMatch(password);
                                    bool validLength = password.length >= 8 && password.length <= 12;

                                    if (!hasLower) {
                                      errorText = 'Debe tener al menos una letra minúscula';
                                    } else if (!hasUpper) {
                                      errorText = 'Debe tener al menos una letra mayúscula';
                                    } else if (!hasTwoDigits) {
                                      errorText = 'Debe tener al menos dos números';
                                    } else if (!hasSymbol) {
                                      errorText = 'Debe tener al menos un símbolo';
                                    } else if (!validLength) {
                                      errorText = 'Debe tener entre 8 y 12 caracteres';
                                    }
                                  }

                                  return errorText != null
                                      ? Text(
                                    errorText,
                                    style: const TextStyle(color: Colors.red, fontSize: 13),
                                  )
                                      : const SizedBox.shrink();
                                },
                              ),
                            ),
                          ],
                        );
                      },
                    ),
                  );
                },
              ),

              const SizedBox(height: 10),
/*
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 25.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      '¿Olvidaste tu contraseña?',
                      style: TextStyle(color: Colors.blue),
                    ),
                  ],
                ),
              ),
*/
              const SizedBox(height: 25),

              // sign in button
              Button(
                onTap: () => signUserIn(context),
              ),

              const SizedBox(height: 50),

              // or continue with
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 25.0),
                child: Row(
                  children: [
                    Expanded(
                      child: Divider(
                        thickness: 1,
                        color: Colors.black,
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 10.0),
                      child: Text(
                        '¿No tienes cuenta?',
                        style: TextStyle(color: Colors.grey[700]),
                      ),
                    ),
                    Expanded(
                      child: Divider(
                        thickness: 1,
                        color: Colors.black,
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 25),

              const SizedBox(width: 4),
              Align(
                alignment: Alignment.center,
                child: TextButton(
                  onPressed: () {
                    Navigator.of(context).pushReplacement(
                      MaterialPageRoute(builder: (context) => RegisterPage()),
                    );
                  },
                  child: const Text(
                    'Crear una cuenta nueva',
                    style: TextStyle(
                      color: Colors.black,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
