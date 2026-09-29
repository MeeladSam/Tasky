import 'package:flutter/material.dart';
import '../models/task.dart';
import '../services/storage_service.dart';
import '../widgets/primary_button.dart';

class NewTaskScreen extends StatefulWidget {
  final Task? task; // null = add, not null = edit
  const NewTaskScreen({super.key, this.task});

  @override
  State<NewTaskScreen> createState() => _NewTaskScreenState();
}

class _NewTaskScreenState extends State<NewTaskScreen> {
  final _formKey = GlobalKey<FormState>();
  late final TextEditingController _title;
  late final TextEditingController _desc;
  late bool _high;

  bool get _isEdit => widget.task != null;

  @override
  void initState() {
    super.initState();
    _title = TextEditingController(text: widget.task?.title ?? '');
    _desc = TextEditingController(text: widget.task?.description ?? '');
    _high = widget.task?.isHighPriority ?? false;
  }

  @override
  void dispose() {
    _title.dispose();
    _desc.dispose();
    super.dispose();
  }

  void _save() {
    if (!_formKey.currentState!.validate()) return;
    final s = StorageService.instance;
    if (_isEdit) {
      s.updateTask(widget.task!, _title.text.trim(), _desc.text.trim(), _high);
    } else {
      s.addTask(_title.text.trim(), _desc.text.trim(), _high);
    }
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(_isEdit ? 'Edit Task' : 'New Task',
            style: const TextStyle(fontSize: 14)),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, size: 20),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text('Task Name', style: TextStyle(fontSize: 12)),
                const SizedBox(height: 8),
                TextFormField(
                  controller: _title,
                  decoration: const InputDecoration(
                      hintText: 'Finish UI design for login screen'),
                  validator: (v) => (v == null || v.trim().isEmpty)
                      ? 'Task name is required'
                      : null,
                ),
                const SizedBox(height: 16),
                const Text('Task Description', style: TextStyle(fontSize: 12)),
                const SizedBox(height: 8),
                TextFormField(
                  controller: _desc,
                  maxLines: 6,
                  decoration: const InputDecoration(
                    hintText:
                        'Finish onboarding UI and hand off to devs by Thursday',
                  ),
                ),
                const SizedBox(height: 16),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text('High Priority',
                        style: TextStyle(fontSize: 12)),
                    Switch(
                      value: _high,
                      onChanged: (v) => setState(() => _high = v),
                    ),
                  ],
                ),
                const Spacer(),
                PrimaryButton(
                  text: _isEdit ? 'Save Changes' : 'Add Task',
                  icon: _isEdit ? null : Icons.add,
                  onPressed: _save,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
