// models/task.dart - Enhanced with categories and priority
import 'package:flutter/material.dart';

enum TaskPriority { Alta, Media, Baja }

enum TaskCategory { Escolar, Personal, Trabajo, Compras, Salud, Otros }

class Task {
  final String? id;
  final String title;
  final String? description;
  bool completed;
  final DateTime? dueDate;
  final TaskPriority priority;
  final TaskCategory category;
  final DateTime createdAt;

  Task({
    this.id,
    required this.title,
    this.description,
    this.completed = false,
    this.dueDate,
    this.priority = TaskPriority.Media,
    this.category = TaskCategory.Personal,
    DateTime? createdAt,
  }) : createdAt = createdAt ?? DateTime.now();

 Map<String, dynamic> toMap() => {
    'title'  : title,
    'completed' : completed,
    'dueDate': dueDate?.millisecondsSinceEpoch,
    'priority': priority.index,
    'category': category.index,
    'description': description,
    'createdAt': createdAt.millisecondsSinceEpoch,
  };
  /// Crea una copia modificando solo los campos pasados
  Task copyWith({
    String?   id,
    String?   title,
    bool?     completed,
    DateTime? dueDate,
    TaskPriority? priority,
    TaskCategory? category,
    String?   description,
    DateTime? createdAt,
  }) {
    return Task(
      id        : id        ?? this.id,
      title     : title     ?? this.title,
      completed : completed ?? this.completed,
      dueDate   : dueDate   ?? this.dueDate,
      priority  : priority  ?? this.priority,
      category  : category  ?? this.category,
      description: description ?? this.description,
      createdAt : createdAt ?? this.createdAt,
    );
  }

  factory Task.fromMap(Map<String, dynamic> map, {String? id}) => Task(
    id     : id,
    title  : map['title'] as String,
    completed : map['completed'] as bool,
    dueDate: map['dueDate'] != null
      ? DateTime.fromMillisecondsSinceEpoch(map['dueDate'] as int)
      : null,
    priority: TaskPriority.values[map['priority'] as int],
    category: TaskCategory.values[map['category'] as int],
    description: map['description'] as String?,
    createdAt: DateTime.fromMillisecondsSinceEpoch(
      map['createdAt'] as int,
    ),
  );

  Color get priorityColor {
    switch (priority) {
      case TaskPriority.Alta:
        return Colors.red;
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

// class TaskList extends ChangeNotifier {
//   final List<Task> _tasks = [];

//   List<Task> get tasks => List.unmodifiable(_tasks);

//   List<Task> get completedTasks =>
//       _tasks.where((task) => task.completed).toList();
//   List<Task> get pendingTasks =>
//       _tasks.where((task) => !task.completed).toList();
//   List<Task> get overdueTasks =>
//       _tasks.where((task) => task.isOverdue).toList();

//   int get completedCount => completedTasks.length;
//   int get pendingCount => pendingTasks.length;
//   int get overdueCount => overdueTasks.length;

//   void addTask(Task task) {
//     _tasks.add(task);
//     notifyListeners();
//   }

//   void removeTask(int index) {
//     _tasks.removeAt(index);
//     notifyListeners();
//   }

//   void toggleDone(int index) {
//     _tasks[index].completed = !_tasks[index].completed;
//     notifyListeners();
//   }

//   void updateTask(int index, Task newTask) {
//     _tasks[index] = newTask;
//     notifyListeners();
//   }

//   List<Task> getFilteredTasks(String filter) {
//     switch (filter) {
//       case 'completed':
//         return completedTasks;
//       case 'pending':
//         return pendingTasks;
//       case 'overdue':
//         return overdueTasks;
//       default:
//         return tasks;
//     }
//   }
// }
