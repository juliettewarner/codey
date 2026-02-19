import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../services/auth_service.dart';
import '../../services/session_service.dart';
import '../home/home_screen.dart';
import 'login_screen.dart';

class SignupScreen extends StatefulWidget {
  const SignupScreen({super.key});

  @override
  State<SignupScreen> createState() => _SignupScreenState();
}

class _SignupScreenState extends State<SignupScreen> {
  final _name = TextEditingController();
  final _pass = TextEditingController();
  final _age = TextEditingController();
  final _auth = AuthService();
  final _session = SessionService();

  bool _loading = false;

  @override
  void dispose() {
    _name.dispose();
    _pass.dispose();
    _age.dispose();
    super.dispose();
  }

  void _msg(String t) {
    if (!mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(t)));
  }

  Future<void> _signup() async {
    final name = _name.text.trim();
    final pass = _pass.text.trim();
    final ageText = _age.text.trim();

    if (name.isEmpty || pass.isEmpty || ageText.isEmpty) {
      _msg('املأ كل الحقول');
      return;
    }

    final age = int.tryParse(ageText);
    if (age == null) {
      _msg('العمر لازم رقم');
      return;
    }

    setState(() => _loading = true);

    try {
      final userId = await _auth.signUp(name: name, password: pass, age: age);
      if (!mounted) return;

      await _session.saveSession(userId: userId, userName: name);

      _msg('تم إنشاء الحساب ✅');
      if (!mounted) return;

      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (_) => HomeScreen(userName: name, userId: userId),
        ),
      );
    } catch (e) {
      _msg('صار خطأ: $e');
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
          fit: StackFit.expand, // ✅ الخلفية تغطي كل الشاشة
          children: [
            Image.asset(
              'assets/images/splash_screen.png',
              fit: BoxFit.cover,
            ),

            Container(color: Colors.black.withOpacity(0.10)),

            SafeArea(
              child: SingleChildScrollView(
                // ✅ نزول تلقائي حسب الجهاز
                padding: EdgeInsets.fromLTRB(24, h * 0.10, 24, 26),
                child: Column(
                  children: [
                    // ✅ أيقونة الشخص
                    Image.asset(
                      'assets/logo/person.png',
                      width: 62,
                      height: 62,
                      color: Colors.white,
                    ),

                    const SizedBox(height: 18),

                    // ✅ عنوان "انشاء حساب"
                    Text(
                      'انشاء حساب',
                      style: GoogleFonts.cairo(
                        color: Colors.white,
                        fontSize: 34,
                        fontWeight: FontWeight.w800,
                      ),
                    ),

                    const SizedBox(height: 30),

                    _Field(
                      controller: _name,
                      hint: 'الاسم',
                      keyboardType: TextInputType.text,
                    ),
                    const SizedBox(height: 16),

                    _Field(
                      controller: _age,
                      hint: 'العمر',
                      keyboardType: TextInputType.number,
                    ),
                    const SizedBox(height: 16),

                    _Field(
                      controller: _pass,
                      hint: 'الرمز السري',
                      obscure: true,
                      keyboardType: TextInputType.visiblePassword,
                    ),

                    const SizedBox(height: 26),

                    // ✅ زر انشاء الحساب
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
                        onPressed: _loading ? null : _signup,
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
                          'انشاء الحساب',
                          style: GoogleFonts.cairo(
                            fontSize: 16,
                            fontWeight: FontWeight.w800,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ),

                    const SizedBox(height: 22),

                    // ✅ لديك حساب بالفعل؟ سجل الآن
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          'لديك حساب بالفعل؟',
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
                              MaterialPageRoute(builder: (_) => const LoginScreen()),
                            );
                          },
                          child: Text(
                            'سجل الآن',
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

class _Field extends StatefulWidget {
  final TextEditingController controller;
  final String hint;
  final bool obscure;
  final TextInputType? keyboardType;

  const _Field({
    super.key,
    required this.controller,
    required this.hint,
    this.obscure = false,
    this.keyboardType,
  });

  @override
  State<_Field> createState() => _FieldState();
}

class _FieldState extends State<_Field> {
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

          // 👁️ أيقونة العين (تظهر فقط إذا obscure = true)
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

