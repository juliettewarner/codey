import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../services/auth_service.dart';
import '../../services/session_service.dart';
import '../home/home_screen.dart';
import 'signup_screen.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  // خليته نفس اسمك السابق حتى ما تتلخبطين بالـ UI
  final _emailController = TextEditingController(); // هنا يعتبر "name"
  final _passController = TextEditingController();

  final _session = SessionService();
  final _auth = AuthService();

  bool _loading = false;

  @override
  void dispose() {
    _emailController.dispose();
    _passController.dispose();
    super.dispose();
  }

  void _showMsg(String text) {
    if (!mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(text)),
    );
  }

  Future<void> _handleLogin() async {
    final name = _emailController.text.trim(); // ✅ هذا اسم المستخدم
    final pass = _passController.text.trim();

    if (name.isEmpty || pass.isEmpty) {
      _showMsg('اكتب الاسم والرمز السري');
      return;
    }

    setState(() => _loading = true);

    try {
      // ✅ تسجيل دخول من Firestore (مقارنة name + password)
      final userId = await _auth.login(name: name, password: pass);

      if (userId == null) {
        _showMsg('الاسم أو الرمز السري خطأ');
        return;
      }

      // ✅ حفظ الجلسة
      await _session.saveSession(userId: userId, userName: name);

      if (!mounted) return;

      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (_) => HomeScreen(
            userName: name,
            userId: userId,
          ),
        ),
      );
    } catch (e) {
      _showMsg('صار خطأ أثناء تسجيل الدخول: $e');
    } finally {
      if (mounted) setState(() => _loading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final h = MediaQuery.of(context).size.height;

    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        body: Stack(
          fit: StackFit.expand,
          children: [
            Image.asset('assets/images/splash_screen.png', fit: BoxFit.cover),
            Container(color: Colors.black.withOpacity(0.10)),
            SafeArea(
              child: SingleChildScrollView(
                padding: EdgeInsets.fromLTRB(24, h * 0.10, 24, 26),
                child: Column(
                  children: [
                    Column(
                      children: [
                        Container(
                          padding: const EdgeInsets.all(10),
                          child: Image.asset(
                            'assets/logo/app_icon.png',
                            width: 40,
                            height: 40,
                            color: Colors.white,
                          ),
                        ),
                        const SizedBox(height: 10),
                        Text(
                          'CODEY',
                          style: GoogleFonts.fredoka(
                            fontSize: 20,
                            fontWeight: FontWeight.w700,
                            letterSpacing: 4,
                            color: Colors.white,
                          ),
                        ),
                      ],
                    ),

                    const SizedBox(height: 26),

                    Text(
                      'تسجيل الدخول',
                      style: GoogleFonts.cairo(
                        color: Colors.white,
                        fontSize: 34,
                        fontWeight: FontWeight.w800,
                      ),
                    ),

                    const SizedBox(height: 28),

                    _InputField(
                      controller: _emailController,
                      hint: 'اسم المستخدم', // ✅ بدل "الإيميل"
                      keyboardType: TextInputType.text,
                    ),
                    const SizedBox(height: 16),

                    _InputField(
                      controller: _passController,
                      hint: 'الرمز السري',
                      obscure: true,
                      keyboardType: TextInputType.visiblePassword,
                    ),

                    const SizedBox(height: 10),

                    Align(
                      alignment: Alignment.centerRight,
                      child: TextButton(
                        onPressed: () => _showMsg('ميزة الاسترجاع نضيفها بعدين 😊'),
                        child: Text(
                          'هل نسيت الرمز السري؟',
                          style: GoogleFonts.cairo(
                            color: Colors.deepPurple,
                            fontSize: 14,
                            fontWeight: FontWeight.w700,
                            decoration: TextDecoration.underline,
                          ),
                        ),
                      ),
                    ),

                    const SizedBox(height: 18),

                    SizedBox(
                      width: 220,
                      height: 48,
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFF8E5CCB),
                          foregroundColor: Colors.white,
                          elevation: 2,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(24),
                            side: const BorderSide(color: Colors.white, width: 1.3),
                          ),
                        ),
                        onPressed: _loading ? null : _handleLogin,
                        child: _loading
                            ? const SizedBox(
                          width: 22,
                          height: 22,
                          child: CircularProgressIndicator(
                            color: Colors.white,
                            strokeWidth: 3,
                          ),
                        )
                            : Text(
                          'تسجيل الدخول',
                          style: GoogleFonts.cairo(
                            fontSize: 16,
                            fontWeight: FontWeight.w800,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ),

                    const SizedBox(height: 22),

                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          'ليس لديك حساب؟',
                          style: GoogleFonts.cairo(
                            color: Colors.black87,
                            fontSize: 14,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                        TextButton(
                          onPressed: () {
                            Navigator.pushReplacement(
                              context,
                              MaterialPageRoute(builder: (_) => const SignupScreen()),
                            );
                          },
                          child: Text(
                            'انشئ الآن',
                            style: GoogleFonts.cairo(
                              color: Colors.deepPurple,
                              fontSize: 14,
                              fontWeight: FontWeight.w900,
                              decoration: TextDecoration.underline,
                            ),
                          ),
                        ),
                      ],
                    ),

                    SizedBox(height: h * 0.06),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _InputField extends StatefulWidget {
  final TextEditingController controller;
  final String hint;
  final bool obscure;
  final TextInputType? keyboardType;

  const _InputField({
    super.key,
    required this.controller,
    required this.hint,
    this.obscure = false,
    this.keyboardType,
  });

  @override
  State<_InputField> createState() => _InputFieldState();
}

class _InputFieldState extends State<_InputField> {
  late bool _obscureText;

  @override
  void initState() {
    super.initState();
    _obscureText = widget.obscure;
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 52,
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.95),
        borderRadius: BorderRadius.circular(16),
      ),
      child: TextField(
        controller: widget.controller,
        obscureText: _obscureText,
        keyboardType: widget.keyboardType,
        style: GoogleFonts.cairo(
          fontSize: 16,
          color: Colors.black87,
          fontWeight: FontWeight.w600,
        ),
        decoration: InputDecoration(
          hintText: widget.hint,
          hintStyle: GoogleFonts.cairo(
            color: Colors.black45,
            fontWeight: FontWeight.w700,
          ),
          border: InputBorder.none,
          contentPadding:
          const EdgeInsets.symmetric(horizontal: 18, vertical: 14),

          // 👁️ أيقونة العين
          suffixIcon: widget.obscure
              ? IconButton(
            icon: Icon(
              _obscureText
                  ? Icons.visibility_off
                  : Icons.visibility,
              color: Colors.grey.shade600,
            ),
            onPressed: () {
              setState(() {
                _obscureText = !_obscureText;
              });
            },
          )
              : null,
        ),
      ),
    );
  }
}

