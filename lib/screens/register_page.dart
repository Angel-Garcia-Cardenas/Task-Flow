import 'package:flutter/material.dart';
import '../widgets/RegisterButton.dart';
import '../widgets/my_textfield.dart';
import './login_page.dart';

class RegisterPage extends StatelessWidget {
  RegisterPage({super.key});

  // Notifier for name field validity
  final ValueNotifier<bool> _nameValidNotifier = ValueNotifier<bool>(true);
  // Notifier for email field validity
  final ValueNotifier<bool> _emailValidNotifier = ValueNotifier<bool>(true);
  // Notifier for password field validity
  final ValueNotifier<bool> _passwordValidNotifier = ValueNotifier<bool>(true);
  // Notifier for confirm password field validity
  final ValueNotifier<bool> _confirmValidNotifier = ValueNotifier<bool>(true);

  // text editing controllers
  final nameController = TextEditingController();
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final confirmController = TextEditingController();

  // sign user up method
  void signUserUp(BuildContext context) {
    // 1. Validar los ValueNotifier<bool>
    if (!_nameValidNotifier.value ||
        !_emailValidNotifier.value ||
        !_passwordValidNotifier.value ||
        !_confirmValidNotifier.value) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Por favor, corrige los campos inválidos')),
      );
      return;
    }

    // 2. Verificar si algún campo está vacío y mostrar cuál falta
    if (nameController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Por favor, ingresa tu nombre de usuario')),
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
    if (confirmController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Por favor, confirma tu contraseña')),
      );
      return;
    }

    // 3. Verificar que la contraseña y la confirmación coincidan
    if (passwordController.text != confirmController.text) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Row(
            children: [
              const Icon(Icons.error, size: 32, color: Colors.blueGrey),
              const SizedBox(width: 12),
              const Expanded(
                child: Text(
                  'Las contraseñas no coinciden',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                  textAlign: TextAlign.left,
                ),
              ),
            ],
          ),
          backgroundColor: Colors.white,
          behavior: SnackBarBehavior.floating,
        ),
      );
      return;
    }
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Registro exitoso')),
    );
    Future.delayed(const Duration(milliseconds: 500), () {
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(builder: (context) => LoginPage()),
      );
    });

    // Limpiar los campos después del registro
    nameController.clear();
    emailController.clear();
    passwordController.clear();
    confirmController.clear();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFEFF3F9),
      resizeToAvoidBottomInset: true,
      body: SafeArea(
        child: Center(
          child: ListView(
            shrinkWrap: true,
            padding: EdgeInsets.only(
              bottom: MediaQuery.of(context).viewInsets.bottom + 20,
              top: 75,
            ),
            children: [
              // logo
              const Icon(
                Icons.access_time_rounded,
                size: 100,
                color: Colors.blue,
              ),

              // App title
              const SizedBox(height: 8),
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
              const SizedBox(height: 4),
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
              // Registration header
              Align(
                alignment: Alignment.center,
                child: Text(
                  'Crear Cuenta',
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
                  'Regístrate para disfrutar de Task Flow.',
                  style: TextStyle(
                    color: Colors.grey[800],
                    fontSize: 14,
                  ),
                ),
              ),

              const SizedBox(height: 25),

              // Name field
              Padding(
                padding: const EdgeInsets.only(left: 30.0),
                child: Align(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    'Nombre de Usuario',
                    style: TextStyle(
                      color: Colors.black,
                      fontSize: 17,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 8),
              // Usamos un ValueNotifier para controlar la validez del nombre
              ValueListenableBuilder<bool>(
                valueListenable: _nameValidNotifier,
                builder: (context, isValid, child) {
                  return Focus(
                    onFocusChange: (hasFocus) {
                      if (!hasFocus) {
                        // Validar el nombre al perder el foco
                        final name = nameController.text;
                        final valid = RegExp(r'^[a-zA-ZáéíóúÁÉÍÓÚüÜñÑ\s]+$').hasMatch(name) && name.isNotEmpty;
                        _nameValidNotifier.value = valid;
                        // Forzar reconstrucción para mostrar el error
                        (context as Element).markNeedsBuild();
                      }
                    },
                    child: StatefulBuilder(
                      builder: (context, setState) {
                        return Column(
                          children: [
                            MyTextField(
                              controller: nameController,
                              hintText: 'Tu username',
                              prefixIcon: Icon(Icons.person_outline, color: Colors.blue),
                              obscureText: false,
                            ),
                            Padding(
                              padding: const EdgeInsets.symmetric(horizontal: 25.0, vertical: 4.0),
                              child: Builder(
                                builder: (context) {
                                  String name = nameController.text;
                                  String? errorText;

                                  if (!isValid && name.isNotEmpty) {
                                    errorText = 'Solo letras y espacios permitidos';
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

              const SizedBox(height: 15),

              // Email field
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

              // Usamos un ValueNotifier para controlar la validez del email
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

              const SizedBox(height: 15),

              // Password field
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

              // Usamos un ValueNotifier para controlar la validez de la contraseña
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

              const SizedBox(height: 15),

              // Confirm password
              Padding(
                padding: const EdgeInsets.only(left: 30.0),
                child: Align(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    'Confirmar contraseña',
                    style: TextStyle(
                      color: Colors.black,
                      fontSize: 17,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),

              const SizedBox(height: 8),
              // Usamos un ValueNotifier para controlar la validez de la confirmación de contraseña
              ValueListenableBuilder<bool>(
                valueListenable: _confirmValidNotifier,
                builder: (context, isValid, child) {
                  return Focus(
                    onFocusChange: (hasFocus) {
                      if (!hasFocus) {
                        final confirm = confirmController.text;
                        final password = passwordController.text;
                        bool hasLower = RegExp(r'[a-z]').hasMatch(confirm);
                        bool hasUpper = RegExp(r'[A-Z]').hasMatch(confirm);
                        bool hasTwoDigits = RegExp(r'(?:\D*\d){2,}').hasMatch(confirm);
                        bool hasSymbol = RegExp(r'[!@=#/\$%&*(),.?:]').hasMatch(confirm);
                        bool validLength = confirm.length >= 8 && confirm.length <= 12;
                        bool matchesPassword = confirm == password;
                        final valid = hasLower && hasUpper && hasTwoDigits && hasSymbol && validLength && matchesPassword;
                        _confirmValidNotifier.value = valid;
                        (context as Element).markNeedsBuild();
                      }
                    },
                    child: StatefulBuilder(
                      builder: (context, setState) {
                        return Column(
                          children: [
                            MyTextField(
                              controller: confirmController,
                              hintText: 'Repite tu contraseña',
                              prefixIcon: Icon(Icons.lock_outline, color: Colors.blue),
                              obscureText: true,
                            ),
                            Padding(
                              padding: const EdgeInsets.symmetric(horizontal: 25.0, vertical: 4.0),
                              child: Builder(
                                builder: (context) {
                                  String confirm = confirmController.text;
                                  String password = passwordController.text;
                                  String? errorText;

                                  if (!isValid && confirm.isNotEmpty) {
                                    bool hasLower = RegExp(r'[a-z]').hasMatch(confirm);
                                    bool hasUpper = RegExp(r'[A-Z]').hasMatch(confirm);
                                    bool hasTwoDigits = RegExp(r'(?:\D*\d){2,}').hasMatch(confirm);
                                    bool hasSymbol = RegExp(r'[!@=#/\$%&*(),.?:]').hasMatch(confirm);
                                    bool validLength = confirm.length >= 8 && confirm.length <= 12;
                                    bool matchesPassword = confirm == password;

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
                                    } else if (!matchesPassword) {
                                      errorText = 'Las contraseñas no coinciden';
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

              const SizedBox(height: 25),

              RegisterButton(
                onTap: () => signUserUp(context),
              ),

              const SizedBox(height: 35),

              // Divider with link to login
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
                        '¿Ya tienes cuenta?',
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

              const SizedBox(height: 10),
              Align(
                alignment: Alignment.center,
                child: TextButton(
                  onPressed: () {
                    Navigator.of(context).pushReplacement(
                      MaterialPageRoute(builder: (context) => LoginPage()),
                    );
                  },
                  child: const Text(
                    'Iniciar sesión',
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
