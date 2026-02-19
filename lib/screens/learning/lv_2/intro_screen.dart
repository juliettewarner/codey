// lv2_intro_screen.dart
import 'dart:math';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../widgets/level_top_bar.dart';
import 'quiz1.dart';

class Lv2IntroScreen extends StatelessWidget {
  final String userId;
  final String userName;

  const Lv2IntroScreen({
    super.key,
    required this.userId,
    required this.userName,
  });

  static const cPurple = Color(0xFF8E5CCB);
  static const cBlue = Color(0xFF14A1FF);
  static const cPink = Color(0xFFFF6FB5);
  static const cYellow = Color(0xFFFFE600);
  static const cGreen = Color(0xFF2ECC71);

  // ✅ حطي صورتج هنا (نفس ستايل الصورة اللي دزيتيها)
  static const String introImagePath = 'assets/images/girl.png';

  @override
  Widget build(BuildContext context) {
    const stepIndex = 0;
    const totalSteps = 5;
    final progress = (stepIndex / totalSteps).clamp(0.0, 1.0);

    final size = MediaQuery.of(context).size;
    final imgH = min(240.0, size.height * 0.28); // ✅ متجاوبة لكل الشاشات

    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        backgroundColor: Colors.white,
        body: Stack(
          children: [
            const Positioned.fill(child: ColoredBox(color: Colors.white)),
            Positioned.fill(
              child: CustomPaint(
                painter: _CodeSymbolsPainter(
                  symbols: const [
                    _Symbol(x: 0.18, y: 0.16, text: '</>', color: cBlue),
                    _Symbol(x: 0.22, y: 0.46, text: '{}', color: cPurple),
                    _Symbol(x: 0.78, y: 0.18, text: ';', color: cPink),
                    _Symbol(x: 0.84, y: 0.48, text: '()', color: cYellow),
                    _Symbol(x: 0.14, y: 0.78, text: '<>', color: cPink),
                    _Symbol(x: 0.86, y: 0.74, text: '[]', color: cBlue),
                    _Symbol(x: 0.40, y: 0.14, text: '=>', color: cYellow),
                    _Symbol(x: 0.62, y: 0.86, text: '//', color: cPurple),
                    _Symbol(x: 0.52, y: 0.10, text: 'var', color: cBlue),
                  ],
                ),
              ),
            ),
            SafeArea(
              child: Column(
                children: [
                  // ✅ Top bar
                  LevelTopBar(
                    userId: userId,
                    levelTitle: 'اسئلة متقدمة',
                    onBack: () => Navigator.pop(context),
                  ),

                  // ✅ Progress
                  Padding(
                    padding: const EdgeInsets.fromLTRB(16, 10, 16, 0),
                    child: Directionality(
                      textDirection: TextDirection.ltr,
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(999),
                        child: SizedBox(
                          height: 9,
                          width: double.infinity,
                          child: LinearProgressIndicator(
                            value: progress,
                            backgroundColor: const Color(0xFFEDEAE3),
                            valueColor: const AlwaysStoppedAnimation(cGreen),
                          ),
                        ),
                      ),
                    ),
                  ),

                  const SizedBox(height: 18),

                  Expanded(
                    child: SingleChildScrollView(
                      padding: const EdgeInsets.fromLTRB(16, 0, 16, 24),
                      physics: const BouncingScrollPhysics(),
                      child: Container(
                        width: double.infinity,
                        padding: const EdgeInsets.fromLTRB(18, 18, 18, 18),
                        decoration: BoxDecoration(
                          color: Colors.white.withOpacity(0.94),
                          borderRadius: BorderRadius.circular(28),
                          boxShadow: [
                            BoxShadow(
                              blurRadius: 24,
                              offset: const Offset(0, 16),
                              color: Colors.black.withOpacity(0.10),
                            ),
                          ],
                        ),
                        child: Column(
                          children: [
                            // ✅ الصورة داخل الكارد (ستايل لطيف + متجاوب)
                            ClipRRect(
                              borderRadius: BorderRadius.circular(22),
                              child: Container(
                                height: imgH,
                                width: double.infinity,
                                color: const Color(0xFFF6F4FB),
                                child: Image.asset(
                                  introImagePath,
                                  fit: BoxFit.contain,
                                ),
                              ),
                            ),

                            const SizedBox(height: 14),

                            Text(
                              'المستوى الثاني (Lv.2)',
                              style: GoogleFonts.cairo(
                                fontSize: 18,
                                fontWeight: FontWeight.w900,
                                color: Colors.black87,
                              ),
                            ),
                            const SizedBox(height: 12),
                            Text(
                              'مرحبًا $userName 👋\n\n'
                                  'هنا راح تصير الأسئلة “أذكى” شوية ✨\n'
                                  'راح تحلّلين ناتج كود، وتكتشفين أخطاء، وتفكرين خطوة خطوة.\n\n'
                                  'كل إجابة صحيحة = نقطة ⭐\n'
                                  'وأكملي 5 أسئلة حتى ينحسب تقدم Lv.2.',
                              textAlign: TextAlign.center,
                              style: GoogleFonts.cairo(
                                fontSize: 16,
                                fontWeight: FontWeight.w900,
                                height: 1.7,
                                color: Colors.black87,
                              ),
                            ),
                            const SizedBox(height: 18),

                            SizedBox(
                              height: 54,
                              width: double.infinity,
                              child: ElevatedButton(
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: cPurple,
                                  foregroundColor: Colors.white,
                                  elevation: 0,
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(18),
                                  ),
                                ),
                                onPressed: () {
                                  Navigator.pushReplacement(
                                    context,
                                    MaterialPageRoute(
                                      builder: (_) => Lv2Quiz1Screen(
                                        userId: userId,
                                        userName: userName,
                                      ),
                                    ),
                                  );
                                },
                                child: Text(
                                  'ابدأ التحدّي 🚀',
                                  style: GoogleFonts.cairo(
                                    fontSize: 15,
                                    fontWeight: FontWeight.w900,
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

/* Helpers */
class _CodeSymbolsPainter extends CustomPainter {
  final List<_Symbol> symbols;
  _CodeSymbolsPainter({required this.symbols});

  @override
  void paint(Canvas canvas, Size size) {
    for (final s in symbols) {
      final tp = TextPainter(
        text: TextSpan(
          text: s.text,
          style: GoogleFonts.fredoka(
            fontSize: 34,
            fontWeight: FontWeight.w700,
            color: s.color.withOpacity(0.10),
          ),
        ),
        textDirection: TextDirection.ltr,
      )..layout();

      final x = size.width * s.x - (tp.width / 2);
      final y = size.height * s.y - (tp.height / 2);
      canvas.save();
      canvas.translate(x, y);
      canvas.rotate(-0.25);
      tp.paint(canvas, Offset.zero);
      canvas.restore();
    }
  }

  @override
  bool shouldRepaint(covariant _CodeSymbolsPainter oldDelegate) => false;
}

class _Symbol {
  final double x, y;
  final String text;
  final Color color;
  const _Symbol({
    required this.x,
    required this.y,
    required this.text,
    required this.color,
  });
}
