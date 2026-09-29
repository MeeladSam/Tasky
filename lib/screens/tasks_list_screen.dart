import 'package:flutter/material.dart';
import '../models/task.dart';
import '../services/storage_service.dart';
import '../widgets/task_tile.dart';

class TasksListScreen extends StatelessWidget {
  final String title;
  final bool Function(Task) filter;
  final bool showBack;

  const TasksListScreen({
    super.key,
    required this.title,
    required this.filter,
    this.showBack = true,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        leading: showBack
            ? IconButton(
                icon: const Icon(Icons.arrow_back, size: 20),
                onPressed: () => Navigator.pop(context),
              )
            : null,
        title: Text(title, style: const TextStyle(fontSize: 14)),
      ),
      body: ValueListenableBuilder<List<Task>>(
        valueListenable: StorageService.instance.tasks,
        builder: (context, tasks, _) {
          final list = tasks.where(filter).toList();
          if (list.isEmpty) {
            return const Center(
              child: Text('Nothing here yet',
                  style: TextStyle(color: Colors.grey, fontSize: 12)),
            );
          }
          return ListView.builder(
            padding: const EdgeInsets.all(16),
            itemCount: list.length,
            itemBuilder: (_, i) =>
                TaskTile(key: ValueKey(list[i].id), task: list[i]),
          );
        },
      ),
    );
  }
}
