import 'package:flutter/material.dart';
import '../services/storage_service.dart';
import '../widgets/primary_button.dart';
import 'main_shell.dart';
import 'splash_screen.dart';

class WelcomeScreen extends StatefulWidget {
  const WelcomeScreen({super.key});

  @override
  State<WelcomeScreen> createState() => _WelcomeScreenState();
}

class _WelcomeScreenState extends State<WelcomeScreen> {
  final _nameController = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  @override
  void dispose() {
    _nameController.dispose();
    super.dispose();
  }

  void _start() {
    if (!_formKey.currentState!.validate()) return;
    StorageService.instance.setUserName(_nameController.text.trim());
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (_) => const MainShell()),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
          child: Form(
            key: _formKey,
            child: Column(
              children: [
                const Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    AppLogo(size: 28),
                    SizedBox(width: 8),
                    Text('Tasky',
                        style: TextStyle(
                            fontSize: 18, fontWeight: FontWeight.w500)),
                  ],
                ),
                const SizedBox(height: 60),
                const Text('Welcome To Tasky 👋',
                    style:
                        TextStyle(fontSize: 18, fontWeight: FontWeight.w500)),
                const SizedBox(height: 6),
                const Text('Your productivity journey starts here.',
                    style: TextStyle(fontSize: 11)),
                const SizedBox(height: 24),
                // بدّلها بصورة الـ illustration: Image.asset('assets/images/welcome.png')
                Icon(Icons.laptop_mac_rounded,
                    size: 140, color: Colors.grey.shade600),
                const SizedBox(height: 30),
                const Align(
                  alignment: Alignment.centerLeft,
                  child: Text('Full Name', style: TextStyle(fontSize: 12)),
                ),
                const SizedBox(height: 8),
                TextFormField(
                  controller: _nameController,
                  textInputAction: TextInputAction.done,
                  onFieldSubmitted: (_) => _start(),
                  decoration: const InputDecoration(hintText: 'e.g. Melad Sam'),
                  validator: (v) {
                    if (v == null || v.trim().isEmpty) {
                      return 'Please enter your name';
                    }
                    if (v.trim().length < 2) return 'Name is too short';
                    return null;
                  },
                ),
                const SizedBox(height: 20),
                PrimaryButton(text: "Let's Get Started", onPressed: _start),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
