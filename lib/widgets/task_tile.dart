import 'package:flutter/material.dart';
import '../models/task.dart';
import '../screens/new_task_screen.dart';
import '../services/storage_service.dart';

class TaskTile extends StatelessWidget {
  final Task task;
  const TaskTile({super.key, required this.task});

  @override
  Widget build(BuildContext context) {
    final s = StorageService.instance;
    final done = task.isCompleted;

    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
      decoration: BoxDecoration(
        color: Theme.of(context).cardColor,
        borderRadius: BorderRadius.circular(10),
      ),
      child: Row(
        children: [
          Checkbox(
            value: done,
            onChanged: (v) => s.toggleTask(task, v ?? false),
          ),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  task.title,
                  style: TextStyle(
                    fontSize: 12,
                    color: done ? Colors.grey : null,
                    decoration: done ? TextDecoration.lineThrough : null,
                  ),
                ),
                if (task.description.isNotEmpty && !done)
                  Text(
                    task.description,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(fontSize: 9, color: Colors.grey),
                  ),
              ],
            ),
          ),
          PopupMenuButton<String>(
            icon: const Icon(Icons.more_vert, size: 18, color: Colors.grey),
            onSelected: (v) {
              if (v == 'edit') {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (_) => NewTaskScreen(task: task)),
                );
              } else {
                s.deleteTask(task);
              }
            },
            itemBuilder: (_) => const [
              PopupMenuItem(value: 'edit', child: Text('Edit')),
              PopupMenuItem(value: 'delete', child: Text('Delete')),
            ],
          ),
        ],
      ),
    );
  }
}
