import 'package:flutter/foundation.dart';
import 'package:hive_flutter/hive_flutter.dart';
import '../models/task.dart';

class StorageService {
  StorageService._();
  static final StorageService instance = StorageService._();

  late Box _tasksBox;
  late Box _settingsBox;

  final ValueNotifier<List<Task>> tasks = ValueNotifier([]);
  final ValueNotifier<bool> isDark = ValueNotifier(true);
  final ValueNotifier<String> userName = ValueNotifier('');
  final ValueNotifier<String> quote =
      ValueNotifier('One task at a time. One step closer.');
  final ValueNotifier<String> avatarPath = ValueNotifier('');

  Future<void> init() async {
    await Hive.initFlutter();
    _tasksBox = await Hive.openBox('tasks');
    _settingsBox = await Hive.openBox('settings');

    final raw = _tasksBox.get('list', defaultValue: []) as List;
    tasks.value =
        raw.map((e) => Task.fromMap(Map<String, dynamic>.from(e))).toList();

    isDark.value = _settingsBox.get('isDark', defaultValue: true) as bool;
    userName.value = _settingsBox.get('userName', defaultValue: '') as String;
    quote.value = _settingsBox.get('quote',
        defaultValue: 'One task at a time. One step closer.') as String;
    avatarPath.value =
        _settingsBox.get('avatarPath', defaultValue: '') as String;
  }

  // ---------- Tasks ----------
  void _saveTasks() {
    _tasksBox.put('list', tasks.value.map((t) => t.toMap()).toList());
  }

  void _emit(List<Task> list) {
    tasks.value = list; // new list => triggers UI rebuild
    _saveTasks();
  }

  void addTask(String title, String desc, bool high) {
    final t = Task(
      id: DateTime.now().microsecondsSinceEpoch.toString(),
      title: title,
      description: desc,
      isHighPriority: high,
    );
    _emit([...tasks.value, t]);
  }

  void updateTask(Task task, String title, String desc, bool high) {
    task
      ..title = title
      ..description = desc
      ..isHighPriority = high;
    _emit([...tasks.value]);
  }

  void toggleTask(Task task, bool value) {
    task.isCompleted = value;
    _emit([...tasks.value]);
  }

  void deleteTask(Task task) {
    _emit(tasks.value.where((t) => t.id != task.id).toList());
  }

  // ---------- Settings ----------
  void setDark(bool v) {
    isDark.value = v;
    _settingsBox.put('isDark', v);
  }

  void setUserName(String v) {
    userName.value = v;
    _settingsBox.put('userName', v);
  }

  void setQuote(String v) {
    quote.value = v;
    _settingsBox.put('quote', v);
  }

  void setAvatar(String v) {
    avatarPath.value = v;
    _settingsBox.put('avatarPath', v);
  }

  void logout() => setUserName('');
}
