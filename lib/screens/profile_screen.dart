// lib/screens/profile_screen.dart
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/user_profile.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});
  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  final _nameCtrl = TextEditingController();
  @override
  Widget build(BuildContext context) {
    final profile = context.watch<UserProfile>();

    // Inicializa el controlador con el nombre actual
    _nameCtrl.text = profile.displayName ?? '';

    return Scaffold(
      appBar: AppBar(title: const Text('Mi Perfil')),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            if (profile.photoURL != null)
              CircleAvatar(
                radius: 40,
                backgroundImage: NetworkImage(profile.photoURL!),
              ),
            const SizedBox(height: 16),
            TextField(
              controller: _nameCtrl,
              decoration: const InputDecoration(labelText: 'Nombre'),
            ),
            const SizedBox(height: 24),
            ElevatedButton(
              onPressed: () async {
                await profile.updateProfile(newName: _nameCtrl.text.trim());
                if (!mounted) return;
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Perfil actualizado')),
                );
              },
              child: const Text('Guardar cambios'),
            ),
          ],
        ),
      ),
    );
  }
}
