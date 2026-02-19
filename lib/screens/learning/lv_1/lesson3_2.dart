import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'quiz1.dart';
import '../../../widgets/level_top_bar.dart';

class Lesson3_2Screen extends StatelessWidget {
  final String userId;
  final String userName;
  final int stepIndex;
  final int totalSteps;

  const Lesson3_2Screen({
    super.key,
    required this.userId,
    required this.userName,
    this.stepIndex = 6,
    this.totalSteps = 8,
  });

  static const cOffWhite = Color(0xFFF2EFE6);
  static const cPurple = Color(0xFF8E5CCB);
  static const cBlue = Color(0xFF14A1FF);
  static const cPink = Color(0xFFFF6FB5);
  static const cYellow = Color(0xFFFFE600);
  static const cGreen = Color(0xFF2ECC71);

  double get _progress {
    if (totalSteps <= 0) return 0;
    return (stepIndex / totalSteps).clamp(0.0, 1.0);
  }

  @override
  Widget build(BuildContext context) {
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
                    _Symbol(x: 0.16, y: 0.20, text: 'if', color: cBlue),
                    _Symbol(x: 0.22, y: 0.46, text: '<', color: cPurple),
                    _Symbol(x: 0.74, y: 0.18, text: '5000', color: cPink),
                    _Symbol(x: 0.82, y: 0.44, text: ':', color: cYellow),
                    _Symbol(x: 0.14, y: 0.76, text: '+', color: cPink),
                    _Symbol(x: 0.86, y: 0.72, text: '1000', color: cBlue),
                    _Symbol(x: 0.38, y: 0.16, text: 'a', color: cYellow),
                    _Symbol(x: 0.62, y: 0.80, text: 'b', color: cPurple),
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
                    levelTitle: 'اساسيات البرمجة',
                    onBack: () => Navigator.pop(context),
                  ),

                  const SizedBox(height: 18),
                  Expanded(
                    child: Stack(
                      children: [
                        SingleChildScrollView(
                          physics: const BouncingScrollPhysics(),
                          padding: const EdgeInsets.fromLTRB(16, 0, 16, 120),
                          child: Column(
                            children: const [


                              _LessonCard(
                                title: 'الدرس الثالث (2/2)',
                                subtitle: 'مثال الرواتب باستخدام if',
                                child: _InfoTile(
                                  icon: Icons.code_rounded,
                                  title: 'الفكرة',
                                  text:
                                  'لدينا راتبان: a و b\nإذا كان أي راتب أقل من 5000 نضيف 1000.',
                                ),
                              ),
                              SizedBox(height: 12),
                              _LessonCard(
                                title: 'الكود 💻',
                                subtitle: '',
                                child: _CodeBlock(
                                  lines: [
                                    'a = 4000',
                                    'b = 9000',
                                    '',
                                    'if a < 5000:',
                                    '    a = a + 1000',
                                    '',
                                    'if b < 5000:',
                                    '    b = b + 1000',
                                    '',
                                    'print(a)',
                                    'print(b)',
                                  ],
                                ),
                              ),
                              SizedBox(height: 12),
                              _LessonCard(
                                title: 'نشاط صغير 🎯',
                                subtitle: 'اضغطي لإظهار الإجابة',
                                child: _TapToReveal(
                                  question:
                                  'بعد تنفيذ الكود… ما قيمة a و b؟',
                                  answer:
                                  'a = 5000\nb = 9000\nلأن a فقط أقل من 5000.',
                                ),
                              ),
                              SizedBox(height: 12),
                              _HintStrip(
                                text:
                                'ملاحظة مهمّة: المسافة قبل الأمر داخل if (Indent) تعني أن هذا الأمر تابع للشرط.',
                              ),
                            ],
                          ),
                        ),
                        Positioned(
                          left: 16,
                          right: 16,
                          bottom: 16,
                          child: SafeArea(
                            top: false,
                            child: Center(
                              child: SizedBox(
                                width: 180,
                                height: 56,
                                child: ElevatedButton(
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: cGreen,
                                    foregroundColor: Colors.white,
                                    elevation: 2,
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(26),
                                      side: const BorderSide(
                                          color: Colors.white, width: 3),
                                    ),
                                  ),
                                  onPressed: () {
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (_) => Quiz1Screen(
                                          userId: userId,
                                          userName: userName,

                                        ),
                                      ),
                                    );
                                  },                                  child: Text(
                                    'التالي',
                                    style: GoogleFonts.cairo(
                                      fontSize: 17,
                                      fontWeight: FontWeight.w900,
                                    ),
                                  ),
                                ),
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
          ],
        ),
      ),
    );
  }
}

/* ================= Widgets ================= */

class _RobotHead extends StatelessWidget {
  const _RobotHead();

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 36,
      height: 36,
      decoration: BoxDecoration(
        color: Lesson3_2Screen.cOffWhite,
        borderRadius: BorderRadius.circular(14),
        boxShadow: [
          BoxShadow(
            blurRadius: 16,
            offset: const Offset(0, 10),
            color: Colors.black.withOpacity(0.06),
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(14),
        child: Image.asset(
          'assets/logo/robot_head.jpg',
          fit: BoxFit.cover,
          errorBuilder: (_, __, ___) => const Icon(
            Icons.smart_toy_rounded,
            color: Lesson3_2Screen.cPurple,
          ),
        ),
      ),
    );
  }
}

class _CodeyBubble extends StatelessWidget {
  final String text;
  const _CodeyBubble({required this.text});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.fromLTRB(14, 12, 14, 12),
      decoration: BoxDecoration(
        color: const Color(0xFFEEF7FF),
        borderRadius: BorderRadius.circular(22),
        border: Border.all(color: Colors.black.withOpacity(0.06)),
        boxShadow: [
          BoxShadow(
            blurRadius: 18,
            offset: const Offset(0, 10),
            color: Colors.black.withOpacity(0.06),
          ),
        ],
      ),
      child: Row(
        children: [
          const Icon(Icons.smart_toy_rounded, size: 22),
          const SizedBox(width: 10),
          Expanded(
            child: Text(
              text,
              style: GoogleFonts.cairo(
                fontSize: 15,
                fontWeight: FontWeight.w800,
                color: Colors.black87,
                height: 1.7,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _LessonCard extends StatelessWidget {
  final String title;
  final String subtitle;
  final Widget child;

  const _LessonCard({
    required this.title,
    required this.subtitle,
    required this.child,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.fromLTRB(18, 18, 18, 18),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.96),
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
          Text(
            title,
            textAlign: TextAlign.center,
            style: GoogleFonts.cairo(
              fontSize: 20,
              fontWeight: FontWeight.w900,
              color: Colors.black87,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            subtitle,
            textAlign: TextAlign.center,
            style: GoogleFonts.cairo(
              fontSize: 15.5,
              fontWeight: FontWeight.w800,
              color: Colors.black54,
            ),
          ),
          const SizedBox(height: 14),
          child,
        ],
      ),
    );
  }
}

class _InfoTile extends StatelessWidget {
  final IconData icon;
  final String title;
  final String text;

  const _InfoTile({
    required this.icon,
    required this.title,
    required this.text,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.fromLTRB(12, 12, 12, 12),
      decoration: BoxDecoration(
        color: const Color(0xFFF7F7F7),
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: Colors.black.withOpacity(0.06)),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 42,
            height: 42,
            decoration: BoxDecoration(
              color: const Color(0xFFEFE8FF),
              borderRadius: BorderRadius.circular(14),
            ),
            child: Icon(icon, color: Lesson3_2Screen.cPurple, size: 22),
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: GoogleFonts.cairo(
                    fontSize: 15.5,
                    fontWeight: FontWeight.w900,
                    color: Colors.black87,
                  ),
                ),
                const SizedBox(height: 6),
                Text(
                  text,
                  style: GoogleFonts.cairo(
                    fontSize: 14.5,
                    fontWeight: FontWeight.w700,
                    color: Colors.black54,
                    height: 1.6,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _CodeBlock extends StatelessWidget {
  final List<String> lines;
  const _CodeBlock({required this.lines});

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.ltr,
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.fromLTRB(14, 12, 14, 12),
        decoration: BoxDecoration(
          color: const Color(0xFF111827),
          borderRadius: BorderRadius.circular(16),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: lines
              .map(
                (line) => Padding(
              padding: const EdgeInsets.only(bottom: 6),
              child: Text(
                line,
                style: GoogleFonts.fredoka(
                  fontSize: 15.5,
                  fontWeight: FontWeight.w700,
                  color: const Color(0xFFE5E7EB),
                  height: 1.35,
                ),
              ),
            ),
          )
              .toList(),
        ),
      ),
    );
  }
}

class _TapToReveal extends StatefulWidget {
  final String question;
  final String answer;

  const _TapToReveal({required this.question, required this.answer});

  @override
  State<_TapToReveal> createState() => _TapToRevealState();
}

class _TapToRevealState extends State<_TapToReveal> {
  bool _show = false;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => setState(() => _show = !_show),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 220),
        width: double.infinity,
        padding: const EdgeInsets.fromLTRB(14, 12, 14, 12),
        decoration: BoxDecoration(
          color: _show ? const Color(0xFFEFFBF2) : const Color(0xFFFFF7E6),
          borderRadius: BorderRadius.circular(18),
          border: Border.all(color: Colors.black.withOpacity(0.06)),
        ),
        child: Column(
          children: [
            Row(
              children: [
                Icon(
                  _show ? Icons.visibility_off_rounded : Icons.touch_app_rounded,
                  color: Colors.black54,
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(
                    widget.question,
                    style: GoogleFonts.cairo(
                      fontSize: 14.8,
                      fontWeight: FontWeight.w800,
                      color: Colors.black87,
                      height: 1.6,
                    ),
                  ),
                ),
              ],
            ),
            if (_show) ...[
              const SizedBox(height: 10),
              const Divider(height: 1),
              const SizedBox(height: 10),
              Text(
                widget.answer,
                textAlign: TextAlign.center,
                style: GoogleFonts.cairo(
                  fontSize: 15.2,
                  fontWeight: FontWeight.w900,
                  color: Lesson3_2Screen.cPurple,
                  height: 1.6,
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}

class _HintStrip extends StatelessWidget {
  final String text;
  const _HintStrip({required this.text});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.fromLTRB(14, 12, 14, 12),
      decoration: BoxDecoration(
        color: const Color(0xFFF3F0FF),
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: Colors.black.withOpacity(0.06)),
      ),
      child: Row(
        children: [
          const Icon(Icons.lightbulb_rounded, color: Lesson3_2Screen.cPurple),
          const SizedBox(width: 10),
          Expanded(
            child: Text(
              text,
              style: GoogleFonts.cairo(
                fontSize: 14.5,
                fontWeight: FontWeight.w800,
                color: Colors.black87,
                height: 1.6,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _CircleIcon extends StatelessWidget {
  final IconData icon;
  final VoidCallback onTap;
  const _CircleIcon({required this.icon, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 42,
        height: 42,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(18),
          boxShadow: [
            BoxShadow(
              blurRadius: 18,
              offset: const Offset(0, 10),
              color: Colors.black.withOpacity(0.08),
            ),
          ],
        ),
        child: Icon(icon, color: Colors.black87, size: 18),
      ),
    );
  }
}

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
  final double x;
  final double y;
  final String text;
  final Color color;
  const _Symbol({
    required this.x,
    required this.y,
    required this.text,
    required this.color,
  });
}
