import 'dart:io';
import 'package:flutter/material.dart';
import '../core/app_theme.dart';
import '../services/storage_service.dart';

class UserAvatar extends StatelessWidget {
  final double radius;
  const UserAvatar({super.key, this.radius = 18});

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<String>(
      valueListenable: StorageService.instance.avatarPath,
      builder: (context, path, _) {
        final hasImage = path.isNotEmpty && File(path).existsSync();
        return CircleAvatar(
          radius: radius,
          backgroundColor: AppTheme.green.withOpacity(0.25),
          backgroundImage: hasImage ? FileImage(File(path)) : null,
          child: hasImage
              ? null
              : Icon(Icons.person, size: radius, color: AppTheme.green),
        );
      },
    );
  }
}
