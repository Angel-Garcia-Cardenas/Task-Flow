// models/task.dart - Enhanced with categories and priority
import 'package:flutter/material.dart';

enum TaskPriority { Alta, Media, Baja }

enum TaskCategory { Escolar, Personal, Trabajo, Compras, Salud, Otros }

class Task {
  String title;
  String? description;
  bool completed;
  DateTime? dueDate;
  TaskPriority priority;
  TaskCategory category;
  DateTime createdAt;

  Task({
    required this.title,
    this.description,
    this.completed = false,
    this.dueDate,
    this.priority = TaskPriority.Media,
    this.category = TaskCategory.Personal,
    DateTime? createdAt,
  }) : createdAt = createdAt ?? DateTime.now();

  Color get priorityColor {
    switch (priority) {
      case TaskPriority.Alta:
        return Colors.red;
        Colors.red;
      case TaskPriority.Media:
        return Colors.orange;
      case TaskPriority.Baja:
        return Colors.green;
    }
  }

  String get priorityName {
    switch (priority) {
      case TaskPriority.Alta:
        return 'Alta';
      case TaskPriority.Media:
        return 'Media';
      case TaskPriority.Baja:
        return 'Baja';
    }
  }

  IconData get categoryIcon {
    switch (category) {
      case TaskCategory.Escolar:
        return Icons.school;
      case TaskCategory.Trabajo:
        return Icons.work;
      case TaskCategory.Personal:
        return Icons.person;
      case TaskCategory.Compras:
        return Icons.shopping_cart;
      case TaskCategory.Salud:
        return Icons.health_and_safety;
      case TaskCategory.Otros:
        return Icons.category;
    }
  }

  bool get isOverdue {
    if (dueDate == null || completed) return false;
    return dueDate!.isBefore(DateTime.now());
  }
}

class TaskList extends ChangeNotifier {
  final List<Task> _tasks = [];

  List<Task> get tasks => List.unmodifiable(_tasks);

  List<Task> get completedTasks =>
      _tasks.where((task) => task.completed).toList();
  List<Task> get pendingTasks =>
      _tasks.where((task) => !task.completed).toList();
  List<Task> get overdueTasks =>
      _tasks.where((task) => task.isOverdue).toList();

  int get completedCount => completedTasks.length;
  int get pendingCount => pendingTasks.length;
  int get overdueCount => overdueTasks.length;

  void addTask(Task task) {
    _tasks.add(task);
    notifyListeners();
  }

  void removeTask(int index) {
    _tasks.removeAt(index);
    notifyListeners();
  }

  void toggleDone(int index) {
    _tasks[index].completed = !_tasks[index].completed;
    notifyListeners();
  }

  void updateTask(int index, Task newTask) {
    _tasks[index] = newTask;
    notifyListeners();
  }

  List<Task> getFilteredTasks(String filter) {
    switch (filter) {
      case 'completed':
        return completedTasks;
      case 'pending':
        return pendingTasks;
      case 'overdue':
        return overdueTasks;
      default:
        return tasks;
    }
  }
}
