import 'package:flutter/material.dart';
import '../core/app_theme.dart';
import '../services/storage_service.dart';
import 'main_shell.dart';
import 'welcome_screen.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    Future.delayed(const Duration(seconds: 2), () {
      if (!mounted) return;
      final hasUser = StorageService.instance.userName.value.isNotEmpty;
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (_) => hasUser ? const MainShell() : const WelcomeScreen(),
        ),
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    const bg = Color(0xFF181818);
    const glow = Color(0xFF1C4A32);

    return Scaffold(
      backgroundColor: bg,
      body: Stack(
        fit: StackFit.expand,
        children: [
          Container(
            decoration: const BoxDecoration(
              gradient: RadialGradient(
                center: Alignment.topLeft,
                radius: 1.1,
                colors: [glow, Color(0x00181818)],
              ),
            ),
          ),
          Container(
            decoration: const BoxDecoration(
              gradient: RadialGradient(
                center: Alignment.bottomRight,
                radius: 1.0,
                colors: [glow, Color(0x00181818)],
              ),
            ),
          ),
          const Center(child: AppLogo(size: 72)),
        ],
      ),
    );
  }
}

class AppLogo extends StatelessWidget {
  final double size;
  const AppLogo({super.key, this.size = 40});

  @override
  Widget build(BuildContext context) {
    return CustomPaint(size: Size.square(size), painter: _LogoPainter());
  }
}

class _LogoPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final d = size.width;

    canvas.drawCircle(
      Offset(d / 2, d / 2),
      d / 2,
      Paint()..color = AppTheme.green,
    );

    final dark = Paint()
      ..color = const Color(0xFF1E1E1E)
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round
      ..strokeWidth = d * 0.115;

    canvas.drawLine(
      Offset(d * 0.29, d * 0.48),
      Offset(d * 0.45, d * 0.66),
      dark,
    );

    // النقطتين
    final dot = Paint()..color = const Color(0xFF1E1E1E);
    canvas.drawCircle(Offset(d * 0.615, d * 0.525), d * 0.068, dot);
    canvas.drawCircle(Offset(d * 0.75, d * 0.385), d * 0.072, dot);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}