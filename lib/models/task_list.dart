// lib/models/task_list.dart
import 'dart:async';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'task.dart';

class TaskList extends ChangeNotifier {
  final _db   = FirebaseFirestore.instance;
  final _auth = FirebaseAuth.instance;

  late CollectionReference<Map<String,dynamic>> _colRef;
  StreamSubscription? _tasksSub;

  List<Task> tasks = [];

  TaskList() {
    final user = _auth.currentUser;
    if (user != null) {
      final uid = user.uid;
      _colRef = _db.collection('users').doc(uid).collection('tasks');
      _tasksSub = _colRef.snapshots().listen((snapshot) {
        tasks = snapshot.docs
          .map((doc) => Task.fromMap(doc.data(), id: doc.id))
          .toList();
        notifyListeners();
      });
    }
  }

  Future<void> addTask(Task task) async {
    await _colRef.add(task.toMap());
  }

  Future<void> updateTask(Task task) async {
    if (task.id == null) return;
    await _colRef.doc(task.id).update(task.toMap());
  }

  Future<void> deleteTask(String id) async {
    await _colRef.doc(id).delete();
  }

  /// Conveniencia: elimina la tarea y actualiza Firestore
  Future<void> removeTask(Task task) async {
    if (task.id == null) return;
    await deleteTask(task.id!);
    // opcional: optimismo local
    tasks.removeWhere((t) => t.id == task.id);
    notifyListeners();
  }

  /// Cantidad de tareas pendientes
  int get pendingCount =>
    tasks.where((task) => !task.completed).length;

  /// Cantidad de tareas completadas
  int get completedCount =>
    tasks.where((task) => task.completed).length;

  List<Task> getFilteredTasks(String filter) {
    switch (filter) {
      case 'completed':
        return tasks.where((task) => task.completed).toList();
      case 'pending':
        return tasks.where((task) => !task.completed).toList();
      case 'overdue':
        return tasks.where((task) => task.isOverdue).toList();
      default:
        return tasks;
    }
  }
  Future<void> toggleDone(int index) async {
    final task = tasks[index];
    final newValue = !task.completed;

    // 1) Actualizamos sólo el campo 'completed' en Firestore
    if (task.id != null) {
      await _colRef.doc(task.id).update({
        'completed': newValue,
      });
    }

    // 2) (Opcional) Actualización optimista local
    //    Esto hará que la UI se actualice inmediatamente
    tasks[index] = task.copyWith(completed: newValue);
    notifyListeners();
  }
  @override
  void dispose() {
    _tasksSub?.cancel();
    super.dispose();
  }
}
