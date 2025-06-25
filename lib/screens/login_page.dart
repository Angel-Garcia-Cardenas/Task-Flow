/*import 'package:flutter/material.dart';
import 'package:modernlogintute/components/my_button.dart';
import 'package:modernlogintute/components/my_textfield.dart';
import 'package:modernlogintute/components/square_tile.dart';

class LoginPage extends StatelessWidget {
  LoginPage({super.key});

  // text editing controllers
  final usernameController = TextEditingController();
  final passwordController = TextEditingController();

  // sign user in method
  void signUserIn() {}

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[300],
      body: SafeArea(
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const SizedBox(height: 50),

              // logo
              const Icon(
                Icons.lock,
                size: 100,
              ),

              const SizedBox(height: 50),

              // welcome back, you've been missed!
              Text(
                'Welcome back you\'ve been missed!',
                style: TextStyle(
                  color: Colors.grey[700],
                  fontSize: 16,
                ),
              ),

              const SizedBox(height: 25),

              // username textfield
              MyTextField(
                controller: usernameController,
                hintText: 'Username',
                obscureText: false,
              ),

              const SizedBox(height: 10),

              // password textfield
              MyTextField(
                controller: passwordController,
                hintText: 'Password',
                obscureText: true,
              ),

              const SizedBox(height: 10),

              // forgot password?
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 25.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    Text(
                      'Forgot Password?',
                      style: TextStyle(color: Colors.grey[600]),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 25),

              // sign in button
              MyButton(
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
                        thickness: 0.5,
                        color: Colors.grey[400],
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 10.0),
                      child: Text(
                        'Or continue with',
                        style: TextStyle(color: Colors.grey[700]),
                      ),
                    ),
                    Expanded(
                      child: Divider(
                        thickness: 0.5,
                        color: Colors.grey[400],
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 50),

              // google + apple sign in buttons
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: const [
                  // google button
                  SquareTile(imagePath: 'lib/images/google.png'),

                  SizedBox(width: 25),

                  // apple button
                  SquareTile(imagePath: 'lib/images/apple.png')
                ],
              ),

              const SizedBox(height: 50),

              // not a member? register now
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    '¿Eres nuevo?',
                    style: TextStyle(color: Colors.grey[700]),
                  ),
                  const SizedBox(width: 4),
                  const Text(
                    '¿Registrate ahora!',
                    style: TextStyle(
                      color: Colors.blue,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              )
            ],
          ),
        ),
      ),
    );
  }
}*/
// lib/screens/login_page.dart
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../widgets/button.dart';
import '../widgets/my_textfield.dart';
import 'home_screen.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  // controladores
  final emailController    = TextEditingController();
  final passwordController = TextEditingController();

  bool   _isLoading = false;
  String? _errorMsg;

  Future<void> signUserIn() async {
    setState(() {
      _isLoading = true;
      _errorMsg  = null;
    });

    try {
      await FirebaseAuth.instance.signInWithEmailAndPassword(
        email:    emailController.text.trim(),
        password: passwordController.text,
      );
      if (!mounted) return;
      // navegar al home reemplazando esta página
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(builder: (_) => const HomeScreen()),
      );
    } on FirebaseAuthException catch (e) {
      if (mounted) {
        setState(() {
          _errorMsg  = e.message;
          _isLoading = false;
        });
      }
    } catch (_) {
      if (mounted) {
        setState(() {
          _errorMsg  = 'Error desconocido, inténtalo de nuevo.';
          _isLoading = false;
        });
      }
    }
  }

  @override
  void dispose() {
    emailController.dispose();
    passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFEFF3F9),
      body: SafeArea(
        child: Center(
          child: ListView(
            shrinkWrap: true,
            padding: const EdgeInsets.symmetric(horizontal: 30),
            children: [

              // logo + título
              const Icon(Icons.access_time_rounded, size: 100, color: Colors.blue),
              const SizedBox(height: 8),
              const Text(
                'Task Flow',
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 40, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 4),
              Text(
                'Organiza tu día, alcanza tus metas.',
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 16, color: Colors.grey[800]),
              ),

              const SizedBox(height: 50),
              const Text(
                'Iniciar Sesión',
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 8),
              Text(
                'Accede a tu cuenta para continuar.',
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 14, color: Colors.grey[800]),
              ),

              const SizedBox(height: 25),

              // Campo correo
              const Align(
                alignment: Alignment.centerLeft,
                child: Text('Correo electrónico',
                    style: TextStyle(fontSize: 17, fontWeight: FontWeight.bold)),
              ),
              const SizedBox(height: 8),
              MyTextField(
                controller: emailController,
                hintText:   'tuemail@email.com',
                prefixIcon: const Icon(Icons.mail_outline, color: Colors.blue),
                obscureText: false,
              ),

              // validación email al perder foco
              Builder(
                builder: (context) {
                  final email = emailController.text;
                  String? error;
                  if (!FocusScope.of(context).hasPrimaryFocus && email.isNotEmpty) {
                    if (!RegExp(r"^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$")
                        .hasMatch(email)) {
                      error = 'Formato de correo inválido';
                    }
                  }
                  return error != null
                      ? Padding(
                          padding: const EdgeInsets.only(top: 4),
                          child: Text(error,
                              style: const TextStyle(color: Colors.red, fontSize: 13)),
                        )
                      : const SizedBox.shrink();
                },
              ),

              const SizedBox(height: 16),

              // Campo contraseña
              const Align(
                alignment: Alignment.centerLeft,
                child: Text('Contraseña',
                    style: TextStyle(fontSize: 17, fontWeight: FontWeight.bold)),
              ),
              const SizedBox(height: 8),
              MyTextField(
                controller:  passwordController,
                hintText:    'Tu contraseña',
                prefixIcon:  const Icon(Icons.lock, color: Colors.blue),
                obscureText: true,
              ),

              // validación password al perder foco
              Builder(
                builder: (context) {
                  final pwd = passwordController.text;
                  String? error;
                  if (!FocusScope.of(context).hasPrimaryFocus && pwd.isNotEmpty) {
                    final hasLower    = RegExp(r'[a-z]').hasMatch(pwd);
                    final hasUpper    = RegExp(r'[A-Z]').hasMatch(pwd);
                    final hasTwoDigits= RegExp(r'(?:\D*\d){2,}').hasMatch(pwd);
                    final hasSymbol   = RegExp(r'[!@=#/\$%&*(),.?:]').hasMatch(pwd);
                    final validLength = pwd.length >= 8 && pwd.length <= 12;

                    if (!hasLower) {
                      error = 'Debe tener al menos una letra minúscula';
                    } else if (!hasUpper) {
                      error = 'Debe tener al menos una letra mayúscula';
                    } else if (!hasTwoDigits) {
                      error = 'Debe tener al menos dos números';
                    } else if (!hasSymbol) {
                      error = 'Debe tener al menos un símbolo';
                    } else if (!validLength) {
                      error = 'Debe tener entre 8 y 12 caracteres';
                    }
                  }
                  return error != null
                      ? Padding(
                          padding: const EdgeInsets.only(top: 4),
                          child: Text(error,
                              style: const TextStyle(color: Colors.red, fontSize: 13)),
                        )
                      : const SizedBox.shrink();
                },
              ),

              const SizedBox(height: 16),

              // mensaje de error de login
              if (_errorMsg != null)
                Padding(
                  padding: const EdgeInsets.only(bottom: 12),
                  child: Text(
                    _errorMsg!,
                    textAlign: TextAlign.center,
                    style: const TextStyle(color: Colors.red),
                  ),
                ),

              // botón o loader
              Center(
                child: _isLoading
                    ? const CircularProgressIndicator()
                    : Button(onTap: signUserIn),
              ),

              const SizedBox(height: 50),

              // separador y link a registro
              Row(children: const [
                Expanded(child: Divider()),
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 8),
                  child: Text('¿No tienes cuenta?'),
                ),
                Expanded(child: Divider()),
              ]),

              const SizedBox(height: 16),
              Center(
                child: TextButton(
                  onPressed: () {
                    // navegar a RegisterPage si la tienes
                  },
                  child: const Text(
                    'Crear una cuenta nueva',
                    style: TextStyle(fontWeight: FontWeight.bold),
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
