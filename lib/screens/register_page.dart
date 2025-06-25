// lib/screens/register_page.dart
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../widgets/RegisterButton.dart';
import '../widgets/my_textfield.dart';
import './login_page.dart';

class RegisterPage extends StatefulWidget {
  const RegisterPage({super.key});

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  // Notifiers para validación
  final ValueNotifier<bool> _nameValidNotifier     = ValueNotifier<bool>(true);
  final ValueNotifier<bool> _emailValidNotifier    = ValueNotifier<bool>(true);
  final ValueNotifier<bool> _passwordValidNotifier = ValueNotifier<bool>(true);
  final ValueNotifier<bool> _confirmValidNotifier  = ValueNotifier<bool>(true);

  // Controladores de texto
  final TextEditingController nameController     = TextEditingController();
  final TextEditingController emailController    = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController confirmController  = TextEditingController();

  bool _isLoading = false;
  String? _errorMsg;

  Future<void> signUserUp(BuildContext context) async {
    // Iniciar loader y limpiar errores previos
    setState(() {
      _isLoading = true;
      _errorMsg  = null;
    });

    // Validaciones
    final name  = nameController.text.trim();
    final email = emailController.text.trim();
    final pwd   = passwordController.text;
    final conf  = confirmController.text;

    final validName  = RegExp(r'^[a-zA-Z0-9 _-]{3,30}$').hasMatch(name) && name.isNotEmpty;
    final validEmail = RegExp(r'^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$').hasMatch(email) && email.isNotEmpty;

    final hasLower     = RegExp(r'[a-z]').hasMatch(pwd);
    final hasUpper     = RegExp(r'[A-Z]').hasMatch(pwd);
    final hasDigits    = RegExp(r'(?:\D*\d){2,}').hasMatch(pwd);
    final hasSymbol    = RegExp(r'[!@=#/\\$%&*(),.?:]').hasMatch(pwd);
    final validLength  = pwd.length >= 8 && pwd.length <= 12;
    final validPwd     = hasLower && hasUpper && hasDigits && hasSymbol && validLength;
    final validConfirm = validPwd && (conf == pwd);

    _nameValidNotifier.value     = validName;
    _emailValidNotifier.value    = validEmail;
    _passwordValidNotifier.value = validPwd;
    _confirmValidNotifier.value  = validConfirm;

    if (!validName || !validEmail || !validPwd || !validConfirm) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Por favor, corrige los campos inválidos')),
      );
      setState(() => _isLoading = false);
      return;
    }

    try {
      final cred = await FirebaseAuth.instance.createUserWithEmailAndPassword(
        email: email,
        password: pwd,
      );
      await FirebaseFirestore.instance
          .collection('users')
          .doc(cred.user!.uid)
          .set({
        'displayName': name,
        'email': email,
        'createdAt': FieldValue.serverTimestamp(),
      });

      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Registro exitoso')),
      );

      // Detener loader
      setState(() => _isLoading = false);
      await Future.delayed(const Duration(milliseconds: 500));
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(builder: (_) => const LoginPage()),
      );

      nameController.clear();
      emailController.clear();
      passwordController.clear();
      confirmController.clear();
    } on FirebaseAuthException catch (e) {
      if (!mounted) return;
      setState(() {
        _errorMsg  = e.message;
        _isLoading = false;
      });
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(_errorMsg!)),
      );
    } catch (e, stackTrace) { // <--- Captura la excepción y el stack trace
      if (!mounted) return;
      print('Caught unexpected error: $e'); // Imprime el error
      print('Stack trace: $stackTrace');  // Imprime el stack trace
      setState(() {
        _errorMsg  = 'Error inesperado, inténtalo de nuevo';
        _isLoading = false;
      });
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(_errorMsg!)),
      );
    }
  }

  @override
  void dispose() {
    nameController.dispose();
    emailController.dispose();
    passwordController.dispose();
    confirmController.dispose();
    super.dispose();
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
              const Icon(Icons.access_time_rounded, size: 100, color: Colors.blue),
              const SizedBox(height: 8),
              const Center(child: Text('Task Flow', style: TextStyle(fontSize: 40, fontWeight: FontWeight.bold))),
              const SizedBox(height: 4),
              Center(child: Text('Organiza tu día, alcanza tus metas.', style: TextStyle(fontSize: 16, color: Colors.grey[800]))),
              const SizedBox(height: 50),
              const Center(child: Text('Crear Cuenta', style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold))),
              const SizedBox(height: 8),
              Center(child: Text('Regístrate para disfrutar de Task Flow.', style: TextStyle(fontSize: 14, color: Colors.grey[800]))),
              const SizedBox(height: 25),

              // Nombre de Usuario
              const Padding(padding: EdgeInsets.only(left: 30), child: Text('Nombre de Usuario', style: TextStyle(fontSize: 17, fontWeight: FontWeight.bold))),
              const SizedBox(height: 8),
              ValueListenableBuilder<bool>(
                valueListenable: _nameValidNotifier,
                builder: (context, isValid, child) => Column(
                  children: [
                    MyTextField(controller: nameController, hintText: 'Tu username', prefixIcon: const Icon(Icons.person_outline, color: Colors.blue), obscureText: false),
                    if (!isValid && nameController.text.isNotEmpty)
                      const Padding(padding: EdgeInsets.symmetric(horizontal: 25, vertical: 4), child: Align(alignment: Alignment.centerLeft, child: Text('El nombre de usuario no es válido. Debe tener entre 3 y 30 caracteres y solo puede contener letras, números, espacios, guiones o guiones bajos.', style: TextStyle(color: Colors.red, fontSize: 13)))),
                  ],
                ),
              ),
              const SizedBox(height: 15),

              // Correo electrónico
              const Padding(padding: EdgeInsets.only(left: 30), child: Text('Correo electrónico', style: TextStyle(fontSize: 17, fontWeight: FontWeight.bold))),
              const SizedBox(height: 8),
              ValueListenableBuilder<bool>(
                valueListenable: _emailValidNotifier,
                builder: (context, isValid, child) => Column(
                  children: [
                    MyTextField(controller: emailController, hintText: 'correo@dominio.com', prefixIcon: const Icon(Icons.mail_outline, color: Colors.blue), obscureText: false),
                    if (!isValid && emailController.text.isNotEmpty)
                      const Padding(padding: EdgeInsets.symmetric(horizontal: 25, vertical: 4), child: Align(alignment: Alignment.centerLeft, child: Text('Formato de correo inválido', style: TextStyle(color: Colors.red, fontSize: 13)))),
                  ],
                ),
              ),
              const SizedBox(height: 15),

              // Contraseña
              const Padding(padding: EdgeInsets.only(left: 30), child: Text('Contraseña', style: TextStyle(fontSize: 17, fontWeight: FontWeight.bold))),
              const SizedBox(height: 8),
              ValueListenableBuilder<bool>(
                valueListenable: _passwordValidNotifier,
                builder: (context, isValid, child) => Column(
                  children: [
                    MyTextField(controller: passwordController, hintText: 'Tu contraseña', prefixIcon: const Icon(Icons.lock_outline, color: Colors.blue), obscureText: true),
                    if (!isValid && passwordController.text.isNotEmpty)
                      const Padding(padding: EdgeInsets.symmetric(horizontal: 25, vertical: 4), child: Align(alignment: Alignment.centerLeft, child: Text('Contraseña debe tener minúscula, mayúscula, dos dígitos, símbolo y 8-12 caracteres', style: TextStyle(color: Colors.red, fontSize: 13)))),
                  ],
                ),
              ),
              const SizedBox(height: 15),

              // Confirmar contraseña
              const Padding(padding: EdgeInsets.only(left: 30), child: Text('Confirmar contraseña', style: TextStyle(fontSize: 17, fontWeight: FontWeight.bold))),
              const SizedBox(height: 8),
              ValueListenableBuilder<bool>(
                valueListenable: _confirmValidNotifier,
                builder: (context, isValid, child) => Column(
                  children: [
                    MyTextField(controller: confirmController, hintText: 'Repite tu contraseña', prefixIcon: const Icon(Icons.lock_outline, color: Colors.blue), obscureText: true),
                    if (!isValid && confirmController.text.isNotEmpty)
                      const Padding(padding: EdgeInsets.symmetric(horizontal: 25, vertical: 4), child: Align(alignment: Alignment.centerLeft, child: Text('Contraseñas deben coincidir y cumplir requisitos', style: TextStyle(color: Colors.red, fontSize: 13)))),
                  ],
                ),
              ),

              const SizedBox(height: 25),

              // Mensaje de error
              if (_errorMsg != null)
                Padding(padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 8), child: Text(_errorMsg!, style: const TextStyle(color: Colors.red), textAlign: TextAlign.center)),

              // Botón o loader
              Center(
                child: _isLoading
                    ? const CircularProgressIndicator()
                    : RegisterButton(onTap: () => signUserUp(context)),
              ),

              const SizedBox(height: 35),

              // Enlace a login
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 25.0),
                child: Row(
                  children: [
                    const Expanded(child: Divider()),
                    Padding(padding: const EdgeInsets.symmetric(horizontal: 10.0), child: Text('¿Ya tienes cuenta?', style: TextStyle(color: Colors.grey[700]))),
                    const Expanded(child: Divider()),
                  ],
                ),
              ),
              const SizedBox(height: 10),
              Align(
                alignment: Alignment.center,
                child: TextButton(
                  onPressed: () => Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (_) => const LoginPage())),
                  child: const Text('Iniciar sesión', style: TextStyle(fontWeight: FontWeight.bold)),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
