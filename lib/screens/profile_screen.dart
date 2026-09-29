import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import '../core/app_theme.dart';
import '../services/storage_service.dart';
import '../widgets/user_avatar.dart';
import 'user_details_screen.dart';
import 'welcome_screen.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  Future<void> _pickAvatar() async {
    final file = await FilePicker.pickFile(type: FileType.image);
    final path = file?.path;
    if (path != null) StorageService.instance.setAvatar(path);
  }

  @override
  Widget build(BuildContext context) {
    final s = StorageService.instance;

    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: const Text('My Profile', style: TextStyle(fontSize: 14)),
      ),
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.all(16),
          children: [
            Center(
              child: GestureDetector(
                onTap: _pickAvatar,
                child: Stack(
                  children: [
                    const UserAvatar(radius: 38),
                    Positioned(
                      right: 0,
                      bottom: 0,
                      child: Container(
                        padding: const EdgeInsets.all(4),
                        decoration: BoxDecoration(
                          color: Theme.of(context).cardColor,
                          shape: BoxShape.circle,
                        ),
                        child: const Icon(Icons.camera_alt_outlined, size: 12),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 10),
            ValueListenableBuilder<String>(
              valueListenable: s.userName,
              builder: (_, name, __) => Center(
                child: Text(name, style: const TextStyle(fontSize: 14)),
              ),
            ),
            const SizedBox(height: 4),
            ValueListenableBuilder<String>(
              valueListenable: s.quote,
              builder: (_, q, __) => Center(
                child: Text(q,
                    textAlign: TextAlign.center,
                    style: const TextStyle(fontSize: 10, color: Colors.grey)),
              ),
            ),
            const SizedBox(height: 24),
            const Text('Profile Info', style: TextStyle(fontSize: 13)),
            const SizedBox(height: 8),
            _tile(
              icon: Icons.person_outline,
              title: 'User Details',
              trailing: const Icon(Icons.arrow_forward, size: 16),
              onTap: () => Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => const UserDetailsScreen()),
              ),
            ),
            const Divider(height: 1),
            ValueListenableBuilder<bool>(
              valueListenable: s.isDark,
              builder: (_, dark, __) => _tile(
                icon: Icons.dark_mode_outlined,
                title: 'Dark Mode',
                trailing: Switch(value: dark, onChanged: s.setDark),
                onTap: () => s.setDark(!dark),
              ),
            ),
            const Divider(height: 1),
            _tile(
              icon: Icons.logout,
              title: 'Log Out',
              trailing: const Icon(Icons.arrow_forward, size: 16),
              onTap: () {
                s.logout();
                Navigator.pushAndRemoveUntil(
                  context,
                  MaterialPageRoute(builder: (_) => const WelcomeScreen()),
                  (_) => false,
                );
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget _tile({
    required IconData icon,
    required String title,
    required Widget trailing,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 8),
        child: Row(
          children: [
            Icon(icon, size: 18, color: AppTheme.green),
            const SizedBox(width: 10),
            Expanded(child: Text(title, style: const TextStyle(fontSize: 12))),
            trailing,
          ],
        ),
      ),
    );
  }
}
