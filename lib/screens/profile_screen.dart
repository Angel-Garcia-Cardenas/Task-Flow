import 'package:flutter/material.dart';
import '../widgets/my_textfield.dart';
import '../widgets/save_chagenge.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => ProfilePageState();
}

class ProfilePageState extends State<ProfilePage> {
  final nameController = TextEditingController(text: 'Username');
  final emailController = TextEditingController(text: 'tuemail@email.com');
  final currentPasswordController = TextEditingController();
  final newPasswordController = TextEditingController();
  final confirmController = TextEditingController();

  void saveProfile() {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Perfil actualizado correctamente')),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFEFF3F9),
      appBar: AppBar(
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
        elevation: 4,
        shadowColor: Colors.black.withOpacity(0.5),
        title: const Text(
          'Mi Perfil',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
      ),
      body: SafeArea(
        child: ListView(
          padding: EdgeInsets.only(
            top: 20,
            bottom: MediaQuery.of(context).viewInsets.bottom + 20,
          ),
          children: [
            // Sección de datos personales
            Theme(
              data: Theme.of(context).copyWith(
                dividerColor: Colors.transparent,
                splashColor: Colors.transparent,
                highlightColor: Colors.transparent,
              ),
              child: ExpansionTile(
                initiallyExpanded: false, // Colapsado por defecto
                title: Text(
                  'Datos Personales',
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.bold,
                        color: Colors.grey,
                      ),
                ),
                tilePadding: const EdgeInsets.only(left: 30.0, right: 16.0),
                childrenPadding:
                    const EdgeInsets.symmetric(horizontal: 0.0, vertical: 8.0),
                children: [
                  Padding(
                    padding: const EdgeInsets.only(left: 30.0),
                    child: Align(
                      alignment: Alignment.centerLeft,
                      child: Text(
                        'Nombre de usuario:',
                        style: TextStyle(
                          color: Colors.black,
                          fontSize: 17,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 15),
                  MyTextField(
                    controller: nameController,
                    hintText: 'Nombre de Usuario',
                    prefixIcon:
                        const Icon(Icons.person_outline, color: Colors.blue),
                    obscureText: false,
                  ),
                  const SizedBox(height: 16),
                  Padding(
                    padding: const EdgeInsets.only(left: 30.0),
                    child: Align(
                      alignment: Alignment.centerLeft,
                      child: Text(
                        'Correo Electrónico:',
                        style: TextStyle(
                          color: Colors.black,
                          fontSize: 17,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 15),
                  MyTextField(
                    controller: emailController,
                    hintText: 'Correo electrónico',
                    prefixIcon:
                        const Icon(Icons.mail_outline, color: Colors.blue),
                    obscureText: false,
                  ),
                ],
              ),
            ),

            const SizedBox(height: 20),
            // Sección de cambio de contraseña
            Theme(
              data: Theme.of(context).copyWith(
                dividerColor: Colors.transparent,
                splashColor: Colors.transparent,
                highlightColor: Colors.transparent,
              ),
              child: ExpansionTile(
                initiallyExpanded: false,
                title: Text(
                  'Cambiar Contraseña',
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.bold,
                        color: Colors.grey,
                      ),
                ),
                tilePadding: const EdgeInsets.only(left: 30.0, right: 16.0),
                childrenPadding:
                    const EdgeInsets.symmetric(horizontal: 0.0, vertical: 8.0),
                children: [
                  Padding(
                    padding: const EdgeInsets.only(left: 30.0),
                    child: Align(
                      alignment: Alignment.centerLeft,
                      child: Text(
                        'Contraseña Actual:',
                        style: TextStyle(
                          color: Colors.black,
                          fontSize: 17,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 15),
                  MyTextField(
                    controller: currentPasswordController,
                    hintText: 'Contraseña Actual',
                    prefixIcon:
                        const Icon(Icons.lock_clock, color: Colors.blue),
                    obscureText: true,
                  ),
                  const SizedBox(height: 16),
                  Padding(
                    padding: const EdgeInsets.only(left: 30.0),
                    child: Align(
                      alignment: Alignment.centerLeft,
                      child: Text(
                        'Nueva Contraseña:',
                        style: TextStyle(
                          color: Colors.black,
                          fontSize: 17,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 15),
                  MyTextField(
                    controller: newPasswordController,
                    hintText: 'Nueva Contraseña',
                    prefixIcon: const Icon(Icons.lock, color: Colors.blue),
                    obscureText: true,
                  ),
                  const SizedBox(height: 16),
                  Padding(
                    padding: const EdgeInsets.only(left: 30.0),
                    child: Align(
                      alignment: Alignment.centerLeft,
                      child: Text(
                        'Confirmar nueva Contraseña:',
                        style: TextStyle(
                          color: Colors.black,
                          fontSize: 17,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 15),
                  MyTextField(
                    controller: confirmController,
                    hintText: 'Confirmar Nueva Contraseña',
                    prefixIcon:
                        const Icon(Icons.lock_outline, color: Colors.blue),
                    obscureText: true,
                  ),
                ],
              ),
            ),

            const SizedBox(height: 32),
            SaveButton(
              onTap: saveProfile,
            ),
          ],
        ),
      ),
    );
  }
}
