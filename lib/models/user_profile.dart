// lib/models/user_profile.dart
import 'dart:async';    
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class UserProfile extends ChangeNotifier {
  final _auth = FirebaseAuth.instance;
  final _db   = FirebaseFirestore.instance;

  String? uid;
  String? displayName;
  String? photoURL;
  String? email;

  late DocumentReference<Map<String,dynamic>> _docRef;
  StreamSubscription? _listener;

  UserProfile() {
    final user = _auth.currentUser;
    if (user != null) {
      uid         = user.uid;
      email       = user.email;
      _docRef     = _db.collection('users').doc(uid);
      // Escuchar cambios en el doc de perfil
      _listener = _docRef.snapshots().listen((snap) {
        final data = snap.data();
        displayName = data?['displayName'] as String?;
        photoURL    = data?['photoURL']    as String?;
        notifyListeners();
      });
    }
  }

  /// Sólo llamar desde pantalla de edición de perfil
  Future<void> updateProfile({
    required String newName,
    String?     newPhotoURL,
  }) async {
    final user = _auth.currentUser!;
  
  // 1) Actualiza el displayName si cambió
  if (newName != user.displayName) {
    await user.updateDisplayName(newName);
  }
  
  // 2) Actualiza el photoURL si lo proporcionaste y cambió
  if (newPhotoURL != null && newPhotoURL != user.photoURL) {
    await user.updatePhotoURL(newPhotoURL);
  }

  // 3) Sincroniza también en Firestore
  await _docRef.set({
    'displayName': newName,
    'photoURL'   : newPhotoURL,
    'email'      : user.email,
  }, SetOptions(merge: true));
}

  @override
  void dispose() {
    _listener?.cancel();
    super.dispose();
  }

  /// Actualiza el uid y email si el usuario cambia
  void updateUser(User user) {
    uid         = user.uid;
    email       = user.email;
    displayName = user.displayName;
    photoURL    = user.photoURL;
    notifyListeners();
  }
}