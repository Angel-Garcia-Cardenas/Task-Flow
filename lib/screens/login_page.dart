import 'package:flutter/material.dart';
import '../widgets/button.dart';
import '../widgets/my_textfield.dart';

class LoginPage extends StatelessWidget {
  LoginPage({super.key});

  // text editing controllers
  final emailController = TextEditingController();
  final passwordController = TextEditingController();

  // sign user in method
  void signUserIn() {}

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
                child:
                Text(
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
                child:
                Text(
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
                child:
                Text(
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
                child:
                Text(
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
              Focus(
                onFocusChange: (hasFocus) {
                  if (!hasFocus) {
                    // Forzar reconstrucción para mostrar el error al perder el foco
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
                          onChanged: (_) {
                            // No validamos en cada cambio, solo al perder el foco
                          },
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 25.0, vertical: 4.0),
                          child: Builder(
                            builder: (context) {
                              String email = emailController.text;
                              String? errorText;

                              // Solo validar si el campo perdió el foco y no está vacío
                              if (!FocusScope.of(context).hasPrimaryFocus && email.isNotEmpty) {
                                bool isValidEmail = RegExp(
                                    r"^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$"
                                ).hasMatch(email);

                                if (!isValidEmail) {
                                  errorText = 'Formato de correo inválido';
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
              Focus(
                onFocusChange: (hasFocus) {
                  if (!hasFocus) {
                    // Forzar reconstrucción para mostrar el error al perder el foco
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
                          prefixIcon: Icon(Icons.lock, color: Colors.blue),
                          obscureText: true,
                          onChanged: (_) {
                            // No validamos en cada cambio, solo al perder el foco
                          },
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 25.0, vertical: 4.0),
                          child: Builder(
                            builder: (context) {
                              String password = passwordController.text;
                              String? errorText;

                              // Solo validar si el campo perdió el foco y no está vacío
                              final focus = FocusScope.of(context);
                              final hasFocus = focus.hasFocus && focus.focusedChild?.context?.widget == passwordController;

                              if (!FocusScope.of(context).hasPrimaryFocus && password.isNotEmpty) {
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
                onTap: signUserIn,
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
                    // Acción para crear una cuenta nueva
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