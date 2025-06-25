// widgets/add_task_dialog.dart - Enhanced add task dialog
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:todo_app/models/task_list.dart';
import '../models/task.dart';
import './notifications.dart';

class AddTaskDialog extends StatefulWidget {
  const AddTaskDialog({super.key});

  @override
  State<AddTaskDialog> createState() => _AddTaskDialogState();
}

class _AddTaskDialogState extends State<AddTaskDialog> {
  final _formKey = GlobalKey<FormState>();
  final _titleController = TextEditingController();
  final _descriptionController = TextEditingController();
  DateTime? _selectedDate;
  TaskPriority _selectedPriority = TaskPriority.Media;
  TaskCategory _selectedCategory = TaskCategory.Personal;

  @override
  void dispose() {
    _titleController.dispose();
    _descriptionController.dispose();
    super.dispose();
  }

  void _selectDate() async {
    final picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime.now(),
      lastDate: DateTime.now().add(const Duration(days: 365)),
    );
    if (picked != null) {
      setState(() {
        _selectedDate = picked;
      });
    }
  }

  Future<void> _addTask() async {
    if (_titleController.text.trim().isEmpty) return;

    final task = Task(
      title: _titleController.text.trim(),
      description: _descriptionController.text.trim().isEmpty
          ? null
          : _descriptionController.text.trim(),
      dueDate: _selectedDate,
      priority: _selectedPriority,
      category: _selectedCategory,
    );

    await Provider.of<TaskList>(context, listen:false)
    .addTask(task);
    
    Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      backgroundColor: Colors.white,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      insetPadding: const EdgeInsets.symmetric(horizontal: 40, vertical: 24),
      contentPadding: const EdgeInsets.fromLTRB(24, 20, 24, 24),
      title: const Center(
        child: Text('Nueva Tarea',
            style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold)),
      ),
      content: SizedBox(
        width: 400,
        //height: 400,
        child: SingleChildScrollView(
          child: Form(
            key: _formKey,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                // Title field
                TextFormField(
                  controller: _titleController,
                  decoration: const InputDecoration(
                    labelText: 'Nombre de la tarea',
                    hintText: 'Ej: Comprar leche',
                    hintStyle: TextStyle(color: Colors.grey),
                    labelStyle: TextStyle(color: Colors.black),
                    border: OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.black),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.black),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.black),
                    ),
                    filled: true,
                    fillColor: Colors.white,
                  ),
                  style: const TextStyle(color: Colors.black),
                  autofocus: true,
                  cursorColor: Colors.blue,
                  autovalidateMode: AutovalidateMode.disabled,
                  validator: (value) {
                    if (value == null || value.trim().isEmpty) {
                      return 'El nombre es obligatorio';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 16),

                // Category selector
                DropdownButtonFormField<TaskCategory>(
                  icon: const Icon(Icons.arrow_drop_down, color: Colors.black),
                  value: _selectedCategory,
                  decoration: const InputDecoration(
                    labelText: 'Categoría',
                    labelStyle: TextStyle(color: Colors.black),
                    border: OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.black),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.black),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.black),
                    ),
                  ),
                  items: TaskCategory.values.map((category) {
                    IconData categoryIcon;
                    switch (category) {
                      case TaskCategory.Trabajo:
                        categoryIcon = Icons.work;
                        break;
                      case TaskCategory.Escolar:
                        categoryIcon = Icons.school;
                        break;
                      case TaskCategory.Personal:
                        categoryIcon = Icons.person;
                        break;
                      case TaskCategory.Compras:
                        categoryIcon = Icons.shopping_cart;
                        break;
                      case TaskCategory.Salud:
                        categoryIcon = Icons.health_and_safety;
                        break;
                      case TaskCategory.Otros:
                        categoryIcon = Icons.category;
                        break;
                    }

                    String textoCategoria = category.name[0].toUpperCase() +
                        category.name.substring(1).toLowerCase();

                    return DropdownMenuItem(
                      value: category,
                      child: Row(
                        children: [
                          Icon(
                            categoryIcon,
                            color: Colors.blue,
                            size: 16,
                          ),
                          const SizedBox(width: 8),
                          Text(textoCategoria),
                        ],
                      ),
                    );
                  }).toList(),
                  onChanged: (value) {
                    if (value != null) {
                      setState(() {
                        _selectedCategory = value;
                      });
                    }
                  },
                  style: const TextStyle(color: Colors.black),
                  dropdownColor: Colors.white,
                ),
                const SizedBox(height: 16),

                // Priority selector
                DropdownButtonFormField<TaskPriority>(
                  icon: const Icon(Icons.arrow_drop_down, color: Colors.black),
                  value: _selectedPriority,
                  decoration: const InputDecoration(
                    labelText: 'Prioridad',
                    labelStyle: TextStyle(color: Colors.black),
                    border: OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.black),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.black),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.black),
                    ),
                  ),
                  items: TaskPriority.values.map((priority) {
                    Color priorityColor;
                    switch (priority) {
                      case TaskPriority.Alta:
                        priorityColor = Colors.red;
                        break;
                      case TaskPriority.Media:
                        priorityColor = Colors.orange;
                        break;
                      case TaskPriority.Baja:
                        priorityColor = Colors.green;
                        break;
                    }

                    String label = priority.name[0].toUpperCase() +
                        priority.name.substring(1).toLowerCase();

                    return DropdownMenuItem(
                      value: priority,
                      child: Row(
                        children: [
                          Icon(
                            Icons.flag,
                            color: priorityColor,
                            size: 18,
                          ),
                          const SizedBox(width: 8),
                          Text(
                            label,
                            style: const TextStyle(color: Colors.black),
                          ),
                        ],
                      ),
                    );
                  }).toList(),
                  onChanged: (value) {
                    if (value != null) {
                      setState(() {
                        _selectedPriority = value;
                      });
                    }
                  },
                  style: const TextStyle(color: Colors.black),
                  dropdownColor: Colors.white,
                ),
                const SizedBox(height: 16),

                // Date picker
                InkWell(
                  onTap: _selectDate,
                  child: Container(
                    padding: _selectedDate == null
                        ? const EdgeInsets.symmetric(vertical: 16, horizontal: 12)
                        : const EdgeInsets.symmetric(vertical: 3, horizontal: 10),
                    decoration: BoxDecoration(
                      border: Border.all(color: Colors.black),
                      borderRadius: BorderRadius.circular(4),
                    ),
                    child: Row(
                      children: [
                        Icon(
                          Icons.calendar_today,
                          color: Colors.blue,
                        ),
                        const SizedBox(width: 8),
                        Expanded(
                          child: Text(
                            _selectedDate == null
                                ? 'Fecha de Vencimiento'
                                : 'Finaliza: ${_selectedDate!.day}/${_selectedDate!.month}/${_selectedDate!.year}',
                            style: TextStyle(
                              color: Colors.black,
                            ),
                          ),
                        ),
                        if (_selectedDate != null)
                          IconButton(
                            icon: const Icon(Icons.clear_outlined),
                            padding: EdgeInsets.zero,
                            color: Colors.grey,
                            onPressed: () {
                              setState(() {
                                _selectedDate = null;
                              });
                            },
                          ),
                      ],
                    ),
                  ),
                ),

                const SizedBox(height: 16),
                // Description field
                TextField(
                  controller: _descriptionController,
                  decoration: const InputDecoration(
                    labelText: 'Descripción (opcional)',
                    labelStyle: TextStyle(color: Colors.black, fontSize: 13),
                    border: OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.black),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.black),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.black),
                    ),
                  ),
                  style: const TextStyle(color: Colors.black),
                  cursorColor: Colors.blue,
                  maxLines: 2,
                ),
                const SizedBox(height: 9),
                if (_selectedDate != null)
                  NotificationsWidget(eventDate: _selectedDate!),
                const SizedBox(height: 16),
              ],
            ),
          ),
        ),
      ),
      actions: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('Cancelar'),
              style: TextButton.styleFrom(
                foregroundColor: Colors.black,
                backgroundColor: Colors.white,
                shape: RoundedRectangleBorder(
                  side: BorderSide(color: Colors.grey),
                  borderRadius: BorderRadius.circular(4),
                ),
              ),
            ),
            FilledButton(
              onPressed: _addTask,
              child: const Text('Agregar'),
              style: FilledButton.styleFrom(
                foregroundColor: Colors.white,
                backgroundColor: Colors.blue,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(4),
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }
}
