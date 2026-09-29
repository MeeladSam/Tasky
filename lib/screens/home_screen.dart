import 'package:flutter/material.dart';
import '../core/app_theme.dart';
import '../services/storage_service.dart';
import '../widgets/task_tile.dart';
import '../widgets/user_avatar.dart';
import 'new_task_screen.dart';
import 'tasks_list_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final s = StorageService.instance;
  bool _showCompleted = true;

  String _greeting() {
    final h = DateTime.now().hour;
    if (h < 12) return 'Good Morning';
    if (h < 17) return 'Good Afternoon';
    return 'Good Evening';
  }

  @override
  Widget build(BuildContext context) {
    return ListenableBuilder(
      listenable: Listenable.merge([s.tasks, s.userName, s.quote]),
      builder: (context, _) {
        final all = s.tasks.value;
        final done = all.where((t) => t.isCompleted).length;
        final total = all.length;
        final percent = total == 0 ? 0.0 : done / total;
        final high = all.where((t) => t.isHighPriority).toList();
        final myTasks =
            _showCompleted ? all : all.where((t) => !t.isCompleted).toList();

        return Scaffold(
          floatingActionButton: FloatingActionButton.extended(
            backgroundColor: AppTheme.green,
            foregroundColor: Colors.white,
            elevation: 0,
            icon: const Icon(Icons.add, size: 18),
            label:
                const Text('Add New Task', style: TextStyle(fontSize: 12)),
            onPressed: () => Navigator.push(
              context,
              MaterialPageRoute(builder: (_) => const NewTaskScreen()),
            ),
          ),
          body: SafeArea(
            child: CustomScrollView(
              slivers: [
                SliverPadding(
                  padding: const EdgeInsets.all(16),
                  sliver: SliverToBoxAdapter(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // ---- Header ----
                        Row(
                          children: [
                            const UserAvatar(radius: 18),
                            const SizedBox(width: 10),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    '${_greeting()}, ${s.userName.value}',
                                    style: const TextStyle(fontSize: 12),
                                  ),
                                  Text(
                                    s.quote.value,
                                    maxLines: 2,
                                    overflow: TextOverflow.ellipsis,
                                    style: const TextStyle(
                                        fontSize: 9, color: Colors.grey),
                                  ),
                                ],
                              ),
                            ),
                            ValueListenableBuilder<bool>(
                              valueListenable: s.isDark,
                              builder: (_, dark, __) => GestureDetector(
                                onTap: () => s.setDark(!dark),
                                child: Container(
                                  width: 38,
                                  height: 38,
                                  decoration: BoxDecoration(
                                    color: Theme.of(context).cardColor,
                                    shape: BoxShape.circle,
                                  ),
                                  child: Icon(
                                    dark ? Icons.wb_sunny_outlined : Icons.nightlight_outlined,
                                    size: 20,
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 16),
                        Text(
                          percent == 1 && total > 0
                              ? 'All done! 🎉'
                              : 'Yuhuu, Your work is almost done! 👋',
                          style: const TextStyle(
                              fontSize: 22, fontWeight: FontWeight.w400),
                        ),
                        const SizedBox(height: 16),

                        // ---- Achieved tasks card ----
                        Container(
                          padding: const EdgeInsets.all(12),
                          decoration: BoxDecoration(
                            color: Theme.of(context).cardColor,
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: Row(
                            children: [
                              Expanded(
                                child: Column(
                                  crossAxisAlignment:
                                      CrossAxisAlignment.start,
                                  children: [
                                    const Text('Achieved Tasks',
                                        style: TextStyle(fontSize: 13)),
                                    const SizedBox(height: 2),
                                    Text('$done Out of $total Done',
                                        style: const TextStyle(
                                            fontSize: 10, color: Colors.grey)),
                                  ],
                                ),
                              ),
                              SizedBox(
                                width: 44,
                                height: 44,
                                child: Stack(
                                  alignment: Alignment.center,
                                  children: [
                                    SizedBox(
                                      width: 44,
                                      height: 44,
                                      child: CircularProgressIndicator(
                                        value: percent,
                                        strokeWidth: 4,
                                        backgroundColor: Colors.grey.shade700,
                                        color: AppTheme.green,
                                      ),
                                    ),
                                    Text('${(percent * 100).round()}%',
                                        style: const TextStyle(fontSize: 9)),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(height: 10),

                        // ---- High priority card ----
                        Container(
                          padding: const EdgeInsets.fromLTRB(12, 10, 8, 10),
                          decoration: BoxDecoration(
                            color: Theme.of(context).cardColor,
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    const Text('High Priority Tasks',
                                        style: TextStyle(
                                            fontSize: 12,
                                            color: AppTheme.green)),
                                    const SizedBox(height: 6),
                                    if (high.isEmpty)
                                      const Text('No high priority tasks',
                                          style: TextStyle(
                                              fontSize: 10,
                                              color: Colors.grey)),
                                    ...high.take(4).map(
                                          (t) => Padding(
                                            padding: const EdgeInsets.only(
                                                bottom: 6),
                                            child: Row(
                                              children: [
                                                SizedBox(
                                                  width: 20,
                                                  height: 20,
                                                  child: Checkbox(
                                                    value: t.isCompleted,
                                                    onChanged: (v) =>
                                                        s.toggleTask(
                                                            t, v ?? false),
                                                  ),
                                                ),
                                                const SizedBox(width: 8),
                                                Expanded(
                                                  child: Text(
                                                    t.title,
                                                    maxLines: 1,
                                                    overflow:
                                                        TextOverflow.ellipsis,
                                                    style: TextStyle(
                                                      fontSize: 11,
                                                      color: t.isCompleted
                                                          ? Colors.grey
                                                          : null,
                                                      decoration: t.isCompleted
                                                          ? TextDecoration
                                                              .lineThrough
                                                          : null,
                                                    ),
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                        ),
                                  ],
                                ),
                              ),
                              GestureDetector(
                                onTap: () => Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (_) => TasksListScreen(
                                      title: 'High Priority Tasks',
                                      filter: (t) => t.isHighPriority,
                                    ),
                                  ),
                                ),
                                child: Container(
                                  width: 34,
                                  height: 34,
                                  margin: const EdgeInsets.only(top: 24),
                                  decoration: BoxDecoration(
                                    shape: BoxShape.circle,
                                    border: Border.all(color: Colors.grey),
                                  ),
                                  child: const Icon(Icons.north_east,
                                      size: 16),
                                ),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(height: 18),

                        // ---- My Tasks header ----
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            const Text('My Tasks',
                                style: TextStyle(fontSize: 14)),
                            Row(
                              children: [
                                const Text('Show completed',
                                    style: TextStyle(
                                        fontSize: 10, color: Colors.grey)),
                                Switch(
                                  value: _showCompleted,
                                  onChanged: (v) =>
                                      setState(() => _showCompleted = v),
                                ),
                              ],
                            ),
                          ],
                        ),
                        if (myTasks.isEmpty)
                          const Padding(
                            padding: EdgeInsets.symmetric(vertical: 24),
                            child: Center(
                              child: Text('No tasks yet. Add your first one!',
                                  style: TextStyle(
                                      fontSize: 12, color: Colors.grey)),
                            ),
                          ),
                      ],
                    ),
                  ),
                ),
                SliverPadding(
                  padding: const EdgeInsets.fromLTRB(16, 0, 16, 90),
                  sliver: SliverList(
                    delegate: SliverChildBuilderDelegate(
                      (context, i) => TaskTile(
                          key: ValueKey(myTasks[i].id), task: myTasks[i]),
                      childCount: myTasks.length,
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
