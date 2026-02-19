import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../services/session_service.dart';
import '../auth/login_screen.dart';
import '../home/home_screen.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  final _session = SessionService();

  @override
  void initState() {
    super.initState();
    _goNext();
  }

  Future<void> _goNext() async {
    await Future.delayed(const Duration(seconds: 2));

    final session = await _session.getSession();
    final userId = session?.userId;
    final userName = session?.userName;

    if (!mounted) return;

    // ✅ إذا ماكو جلسة -> Login
    if (userId == null || userId.trim().isEmpty) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (_) => const LoginScreen()),
      );
      return;
    }

    // ✅ إذا اكو جلسة -> Home
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
        builder: (_) => HomeScreen(
          userId: userId,
          userName: (userName == null || userName.trim().isEmpty)
              ? 'مستخدم'
              : userName,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Positioned.fill(
            child: Image.asset(
              'assets/images/splash_screen.png',
              fit: BoxFit.cover,
            ),
          ),

          Center(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Image.asset(
                  'assets/logo/app_icon.png',
                  width: 70,
                  height: 70,
                  color: Colors.white,
                ),
                const SizedBox(height: 18),

                Transform.translate(
                  offset: const Offset(0, -10),
                  child: Text(
                    'CODEY',
                    style: GoogleFonts.fredoka(
                      fontSize: 44,
                      fontWeight: FontWeight.w700,
                      letterSpacing: 2,
                      color: Colors.white,
                      shadows: const [
                        Shadow(
                          blurRadius: 8,
                          color: Colors.black26,
                          offset: Offset(0, 3),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),

          const Positioned(
            left: 0,
            right: 0,
            bottom: 50,
            child: Center(
              child: Text(
                'version1.0.0',
                style: TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.w600,
                  color: Colors.white,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
