import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../widgets/my_textfield.dart';
import '../widgets/save_chagenge.dart';
import '../screens/home_screen.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => ProfilePageState();
}

// Notifier for name field validity
final ValueNotifier<bool> _nameValidNotifier = ValueNotifier<bool>(true);
// Notifier for email field validity
final ValueNotifier<bool> _emailValidNotifier = ValueNotifier<bool>(true);
// Notifier for current password field validity
final ValueNotifier<bool> _currentPasswordValidNotifier = ValueNotifier<bool>(true);
// Notifier for password field validity
final ValueNotifier<bool> _passwordValidNotifier = ValueNotifier<bool>(true);
// Notifier for confirm password field validity
final ValueNotifier<bool> _confirmValidNotifier = ValueNotifier<bool>(true);

class ProfilePageState extends State<ProfilePage> {
  final nameController = TextEditingController();
  final emailController = TextEditingController();
  final currentPasswordController = TextEditingController();
  final newPasswordController = TextEditingController();
  final confirmController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _loadUserProfile();
  }

  Future<void> _loadUserProfile() async {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) return;

    // Load email from Auth
    emailController.text = user.email ?? '';
    
    // Load other profile data from Firestore
    final doc = await FirebaseFirestore.instance
        .collection('users')
        .doc(user.uid)
        .get();
    final data = doc.data();
    if (data != null) {
      nameController.text = data['displayName'] ?? '';
    }
  }

  Future<void> saveProfile() async {
    // Validate fields
    if (!_nameValidNotifier.value ||
        !_emailValidNotifier.value ||
        !_currentPasswordValidNotifier.value ||
        !_passwordValidNotifier.value ||
        !_confirmValidNotifier.value) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Por favor, corrige los campos inválidos')),
      );
      return;
    }

    final user = FirebaseAuth.instance.currentUser;
    if (user == null) return;

    try {
      // Update email if changed
      if (emailController.text.trim() != user.email) {
        await user.updateEmail(emailController.text.trim());
      }

      // Update password if provided
      if (newPasswordController.text.isNotEmpty) {
        final credential = EmailAuthProvider.credential(
          email: user.email!,
          password: currentPasswordController.text,
        );
        await user.reauthenticateWithCredential(credential);
        await user.updatePassword(newPasswordController.text);
      }

      // Update name (and other fields) in Firestore
      await FirebaseFirestore.instance
          .collection('users')
          .doc(user.uid)
          .set({
        'displayName': nameController.text.trim(),
      }, SetOptions(merge: true));

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Perfil actualizado correctamente')),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error al actualizar perfil: $e')),
      );
    }
  }

  @override
  void dispose() {
    nameController.dispose();
    emailController.dispose();
    currentPasswordController.dispose();
    newPasswordController.dispose();
    confirmController.dispose();
    super.dispose();
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
        leading: IconButton(
          icon: Icon(Icons.close, color: Colors.grey),
          onPressed: () {
            Navigator.of(context).pushReplacement(
              MaterialPageRoute(builder: (context) => HomeScreen()),
            );
          },
        ),
      ),
      body: SafeArea(
        child: ListView(
          padding: EdgeInsets.only(
            top: 10,
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
                  ValueListenableBuilder<bool>(
                    valueListenable: _nameValidNotifier,
                    builder: (context, isValid, child) {
                      return Focus(
                        onFocusChange: (hasFocus) {
                          if (!hasFocus) {
                            // Validar el nombre al perder el foco
                            final name = nameController.text;
                            final valid = RegExp(r'^[a-zA-ZáéíóúÁÉÍÓÚüÜñÑ\s]+$')
                                .hasMatch(name) &&
                                name.isNotEmpty;
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
                                  prefixIcon: Icon(Icons.person_outline,
                                      color: Colors.blue),
                                  obscureText: false,
                                ),
                                Padding(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 25.0, vertical: 4.0),
                                  child: Builder(
                                    builder: (context) {
                                      String name = nameController.text;
                                      String? errorText;

                                      if (!isValid && name.isNotEmpty) {
                                        errorText =
                                        'Solo letras y espacios permitidos';
                                      }

                                      return errorText != null
                                          ? Text(
                                        errorText,
                                        style: const TextStyle(
                                            color: Colors.red,
                                            fontSize: 13),
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

                  // Usamos un ValueNotifier para controlar la validez del email
                  ValueListenableBuilder<bool>(
                    valueListenable: _emailValidNotifier,
                    builder: (context, isValid, child) {
                      return Focus(
                        onFocusChange: (hasFocus) {
                          if (!hasFocus) {
                            final email = emailController.text;
                            final valid =
                                RegExp(r"^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$")
                                    .hasMatch(email) &&
                                    email.isNotEmpty;
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
                                  prefixIcon: Icon(Icons.mail_outline,
                                      color: Colors.blue),
                                  obscureText: false,
                                ),
                                Padding(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 25.0, vertical: 4.0),
                                  child: Builder(
                                    builder: (context) {
                                      String email = emailController.text;
                                      String? errorText;

                                      if (!isValid && email.isNotEmpty) {
                                        errorText =
                                        'Formato de correo inválido';
                                      }

                                      return errorText != null
                                          ? Text(
                                        errorText,
                                        style: const TextStyle(
                                            color: Colors.red,
                                            fontSize: 13),
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
                  const SizedBox(height: 0),
                ],
              ),
            ),

            const SizedBox(height: 0),
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
                  ValueListenableBuilder<bool>(
                    valueListenable: _passwordValidNotifier,
                    builder: (context, isValid, child) {
                      return Focus(
                        onFocusChange: (hasFocus) {
                          if (!hasFocus) {
                            final password = newPasswordController.text;
                            bool hasLower = RegExp(r'[a-z]').hasMatch(password);
                            bool hasUpper = RegExp(r'[A-Z]').hasMatch(password);
                            bool hasTwoDigits =
                            RegExp(r'(?:\D*\d){2,}').hasMatch(password);
                            bool hasSymbol = RegExp(r'[!@=#/\$%&*(),.?:]')
                                .hasMatch(password);
                            bool validLength =
                                password.length >= 8 && password.length <= 12;
                            final valid = hasLower &&
                                hasUpper &&
                                hasTwoDigits &&
                                hasSymbol &&
                                validLength;
                            _passwordValidNotifier.value = valid;
                            (context as Element).markNeedsBuild();
                          }
                        },
                        child: StatefulBuilder(
                          builder: (context, setState) {
                            return Column(
                              children: [
                                MyTextField(
                                  controller: newPasswordController,
                                  hintText: 'Nueva contraseña',
                                  prefixIcon: const Icon(Icons.lock_outline,
                                      color: Colors.blue),
                                  obscureText: true,
                                ),
                                Padding(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 25.0, vertical: 4.0),
                                  child: Builder(
                                    builder: (context) {
                                      String password =
                                          newPasswordController.text;
                                      String? errorText;

                                      if (!isValid && password.isNotEmpty) {
                                        bool hasLower =
                                        RegExp(r'[a-z]').hasMatch(password);
                                        bool hasUpper =
                                        RegExp(r'[A-Z]').hasMatch(password);
                                        bool hasTwoDigits =
                                        RegExp(r'(?:\D*\d){2,}')
                                            .hasMatch(password);
                                        bool hasSymbol =
                                        RegExp(r'[!@=#/\$%&*(),.?:]')
                                            .hasMatch(password);
                                        bool validLength =
                                            password.length >= 8 &&
                                                password.length <= 12;

                                        if (!hasLower) {
                                          errorText =
                                          'Debe tener al menos una letra minúscula';
                                        } else if (!hasUpper) {
                                          errorText =
                                          'Debe tener al menos una letra mayúscula';
                                        } else if (!hasTwoDigits) {
                                          errorText =
                                          'Debe tener al menos dos números';
                                        } else if (!hasSymbol) {
                                          errorText =
                                          'Debe tener al menos un símbolo';
                                        } else if (!validLength) {
                                          errorText =
                                          'Debe tener entre 8 y 12 caracteres';
                                        }
                                      }
                                      return errorText != null
                                          ? Text(
                                        errorText,
                                        style: const TextStyle(
                                            color: Colors.red,
                                            fontSize: 13),
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
                  ValueListenableBuilder<bool>(
                    valueListenable: _confirmValidNotifier,
                    builder: (context, isValid, child) {
                      return Focus(
                        onFocusChange: (hasFocus) {
                          if (!hasFocus) {
                            final confirm = confirmController.text;
                            final password = newPasswordController.text;
                            bool hasLower = RegExp(r'[a-z]').hasMatch(confirm);
                            bool hasUpper = RegExp(r'[A-Z]').hasMatch(confirm);
                            bool hasTwoDigits =
                            RegExp(r'(?:\D*\d){2,}').hasMatch(confirm);
                            bool hasSymbol =
                            RegExp(r'[!@=#/\$%&*(),.?:]').hasMatch(confirm);
                            bool validLength =
                                confirm.length >= 8 && confirm.length <= 12;
                            bool matchesPassword = confirm == password;
                            final valid = hasLower &&
                                hasUpper &&
                                hasTwoDigits &&
                                hasSymbol &&
                                validLength &&
                                matchesPassword;
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
                                  prefixIcon: Icon(Icons.lock_outline,
                                      color: Colors.blue),
                                  obscureText: true,
                                ),
                                Padding(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 25.0, vertical: 4.0),
                                  child: Builder(
                                    builder: (context) {
                                      String confirm = confirmController.text;
                                      String password =
                                          newPasswordController.text;
                                      String? errorText;

                                      if (!isValid && confirm.isNotEmpty) {
                                        bool hasLower =
                                        RegExp(r'[a-z]').hasMatch(confirm);
                                        bool hasUpper =
                                        RegExp(r'[A-Z]').hasMatch(confirm);
                                        bool hasTwoDigits =
                                        RegExp(r'(?:\D*\d){2,}')
                                            .hasMatch(confirm);
                                        bool hasSymbol =
                                        RegExp(r'[!@=#/\$%&*(),.?:]')
                                            .hasMatch(confirm);
                                        bool validLength =
                                            confirm.length >= 8 &&
                                                confirm.length <= 12;
                                        bool matchesPassword =
                                            confirm == password;

                                        if (!hasLower) {
                                          errorText =
                                          'Debe tener al menos una letra minúscula';
                                        } else if (!hasUpper) {
                                          errorText =
                                          'Debe tener al menos una letra mayúscula';
                                        } else if (!hasTwoDigits) {
                                          errorText =
                                          'Debe tener al menos dos números';
                                        } else if (!hasSymbol) {
                                          errorText =
                                          'Debe tener al menos un símbolo';
                                        } else if (!validLength) {
                                          errorText =
                                          'Debe tener entre 8 y 12 caracteres';
                                        } else if (!matchesPassword) {
                                          errorText =
                                          'Las contraseñas no coinciden';
                                        }
                                      }

                                      return errorText != null
                                          ? Text(
                                        errorText,
                                        style: const TextStyle(
                                            color: Colors.red,
                                            fontSize: 13),
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
                ],
              ),
            ),

            const SizedBox(height: 10),
            SaveButton(
              onTap: saveProfile,
            ),
          ],
        ),
      ),
    );
  }
}