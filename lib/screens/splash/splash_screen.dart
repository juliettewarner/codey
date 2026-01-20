import 'package:flutter/material.dart';
import 'dart:async';
import '../auth/login_screen.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();

    // ⏱️ بعد 5 ثواني يروح لصفحة تسجيل الدخول
    Timer(const Duration(seconds: 5), () {
      if (mounted) {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => const LoginScreen()),
        );
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          // 🎨 الخلفية
          Container(
            width: double.infinity,
            height: double.infinity,
            decoration: const BoxDecoration(
              image: DecorationImage(
                image: AssetImage('assets/images/splash_screen.png'),
                fit: BoxFit.cover,
              ),
            ),
          ),

          // 🌟 المحتوى (اللوگو + النصوص + الأيقونة)
          Center(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                // 🖼️ اللّوگو
                Image.asset(
                  'assets/images/app_logo.png', // ← عدلي المسار حسب مكان اللّوگو
                  width: 120,
                  height: 120,
                ),

                const SizedBox(height: 20),

                // ✍️ النص الرئيسي
                const Text(
                  'C O D E Y',
                  style: TextStyle(
                    fontSize: 28,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                    shadows: [
                      Shadow(
                        blurRadius: 8,
                        color: Colors.black45,
                        offset: Offset(2, 2),
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 30),

                // 💬 النص الصغير + الأيقونة بالأسفل (وسط)
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: const [
                    Icon(
                      Icons.auto_awesome, // ← أيقونة بسيطة متوهجة
                      color: Colors.white,
                      size: 22,
                    ),
                    SizedBox(width: 8),
                    Text(
                      'version 1 . 0 . 0',
                      style: TextStyle(
                        fontSize: 16,
                        color: Colors.white70,
                        fontStyle: FontStyle.italic,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
