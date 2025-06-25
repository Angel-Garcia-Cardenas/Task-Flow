// widgets/task_tile.dart - Modern card design
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:todo_app/models/task_list.dart';
import '../models/task.dart';
import 'package:intl/intl.dart';

class TaskTile extends StatelessWidget {
  final Task task;
  final int index;

  const TaskTile({
    super.key,
    required this.task,
    required this.index,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Card(
      color: Colors.white,
      margin: EdgeInsets.zero,
      child: InkWell(
        borderRadius: BorderRadius.circular(12),
        onTap: () {
          Provider.of<TaskList>(context, listen: false).toggleDone(index);
        },
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Row(
            children: [
              // Priority indicator
              Container(
                width: 4,
                height: 75,
                decoration: BoxDecoration(
                  color: task.priorityColor,
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
              const SizedBox(width: 0),

              // Checkbox
              // Checkbox
              Checkbox(
                value: task.completed,
                onChanged: (_) {
                  Provider.of<TaskList>(context, listen: false)
                      .toggleDone(index);
                },
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(4),
                ),
                activeColor: task.completed ? Colors.blue : Colors.grey,
                checkColor: Colors.white,
              ),
              const SizedBox(width: 0),

              // Task content
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Expanded(
                          child: Text(
                            task.title,
                            style: theme.textTheme.titleMedium?.copyWith(
                              decoration: task.completed
                                  ? TextDecoration.lineThrough
                                  : null,
                              color: task.completed
                                  ? Colors.grey
                                  : Colors.black,
                              fontWeight: FontWeight.w400,
                            ),
                          ),
                        ),
                      ],
                    ),
                    if (task.description != null &&
                        task.description!.isNotEmpty) ...[
                      const SizedBox(height: 4),
                      Text(
                        task.description!,
                        style: theme.textTheme.bodySmall?.copyWith(
                          color: Colors.black,
                          fontWeight: FontWeight.w500,
                        ),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ],
                    if (task.dueDate != null) ...[
                      const SizedBox(height: 8),
                      Row(
                        children: [
                          Container(
                            decoration: BoxDecoration(
                              color: task.priorityColor.withOpacity(0.15),
                              borderRadius: BorderRadius.circular(6),
                            ),
                            padding: const EdgeInsets.symmetric(
                              horizontal: 8,
                              vertical: 4,
                            ),
                            margin: const EdgeInsets.only(right: 8),
                            child: Row(
                              children: [
                                Icon(
                                  Icons.flag,
                                  size: 16,
                                  color: task.priorityColor,
                                ),
                                const SizedBox(width: 4),
                                Text(
                                  task.priorityName,
                                  style: theme.textTheme.labelSmall?.copyWith(
                                    color: task.priorityColor,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          // Due date
                          Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 8,
                              vertical: 4,
                            ),
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                const Icon(
                                  Icons.calendar_today,
                                  size: 16,
                                  color: Colors.black,
                                ),
                                const SizedBox(width: 4),
                                Text(
                                  ' ${DateFormat('dd/MM/yyyy').format(task.dueDate!)}',
                                  style: theme.textTheme.labelSmall?.copyWith(
                                    color: Colors.black,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          // Category name
                          if (task.category != null && task.category.name.isNotEmpty)
                            Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 8,
                                vertical: 4,
                              ),
                              margin: const EdgeInsets.only(left: 8),
                              child: Row(
                                children: [
                                  const SizedBox(width: 4),
                                  Text(
                                    task.category.name,
                                    style: theme.textTheme.labelSmall?.copyWith(
                                      color: Colors.black,
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                        ],
                      ),
                    ],
                  ],
                ),
              ),

              // Delete button
              Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  IconButton(
                    icon: const Icon(Icons.edit_outlined),
                    onPressed: () {
                      // TODO: Implement edit functionality
                    },
                    color: Colors.grey,
                    tooltip: 'Editar tarea',
                  ),
                  IconButton(
                    icon: const Icon(Icons.delete_outline),
                    onPressed: () {
                      _showDeleteDialog(context);
                    },
                    color: Colors.red,
                    tooltip: 'Eliminar tarea',
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _showDeleteDialog(BuildContext context) {
    final theme = Theme.of(context);
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: Row(
          children: [
            Icon(Icons.warning_amber_rounded,
                color: theme.colorScheme.error, size: 28),
            const SizedBox(width: 8),
            const Text('Eliminar tarea'),
          ],
        ),
        content: RichText(
          text: TextSpan(
            style: theme.textTheme.bodyMedium,
            children: [
              const TextSpan(
                  text: '¿Está seguro que desaea eliminar la tarea?'),
            ],
          ),
        ),
        actionsPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        actionsAlignment: MainAxisAlignment.end,
        actions: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              TextButton.icon(
                icon: const Icon(Icons.close),
                label: const Text('Cancelar'),
                onPressed: () => Navigator.of(context).pop(),
                style: TextButton.styleFrom(
                  backgroundColor: Colors.grey,
                  foregroundColor: Colors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
              ),
              Spacer(),
              FilledButton.icon(
                icon: const Icon(Icons.delete_outline),
                label: const Text('Eliminar'),
                onPressed: () async {
                // 1) Obtenemos el TaskList sin escuchar para no disparar rebuilds aquí
                final taskList = Provider.of<TaskList>(context, listen: false);

                // 2) Eliminamos la tarea pasándole el objeto Task
                await taskList.removeTask(task); 

                // 3) Cerramos el diálogo
                Navigator.of(context).pop();
              },
                style: FilledButton.styleFrom(
                  backgroundColor: theme.colorScheme.error,
                  foregroundColor: theme.colorScheme.onError,
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12)),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
