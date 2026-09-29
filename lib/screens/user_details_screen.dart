import 'package:flutter/material.dart';
import '../services/storage_service.dart';
import '../widgets/primary_button.dart';

class UserDetailsScreen extends StatefulWidget {
  const UserDetailsScreen({super.key});

  @override
  State<UserDetailsScreen> createState() => _UserDetailsScreenState();
}

class _UserDetailsScreenState extends State<UserDetailsScreen> {
  final s = StorageService.instance;
  final _formKey = GlobalKey<FormState>();
  late final TextEditingController _name;
  late final TextEditingController _quote;

  @override
  void initState() {
    super.initState();
    _name = TextEditingController(text: s.userName.value);
    _quote = TextEditingController(text: s.quote.value);
  }

  @override
  void dispose() {
    _name.dispose();
    _quote.dispose();
    super.dispose();
  }

  void _save() {
    if (!_formKey.currentState!.validate()) return;
    s.setUserName(_name.text.trim());
    s.setQuote(_quote.text.trim());
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('User Details', style: TextStyle(fontSize: 14)),
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
                const Text('User Name', style: TextStyle(fontSize: 12)),
                const SizedBox(height: 8),
                TextFormField(
                  controller: _name,
                  validator: (v) => (v == null || v.trim().isEmpty)
                      ? 'Name is required'
                      : null,
                ),
                const SizedBox(height: 16),
                const Text('Motivation Quote', style: TextStyle(fontSize: 12)),
                const SizedBox(height: 8),
                TextFormField(
                  controller: _quote,
                  maxLines: 6,
                  validator: (v) => (v == null || v.trim().isEmpty)
                      ? 'Please write a quote'
                      : null,
                ),
                const Spacer(),
                PrimaryButton(text: 'Save Changes', onPressed: _save),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
