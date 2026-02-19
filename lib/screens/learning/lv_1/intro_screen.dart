import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../widgets/level_top_bar.dart';

import 'lesson1_1.dart';

class Lv1IntroScreen extends StatelessWidget {
  final String userId;
  final String userName;

  final int stepIndex; // 1
  final int totalSteps; // 9

  const Lv1IntroScreen({
    super.key,
    required this.userId,
    required this.userName,
    this.stepIndex = 1,
    this.totalSteps = 9,
  });

  static const cOffWhite = Color(0xFFF2EFE6);
  static const cPurple = Color(0xFF8E5CCB);
  static const cBlue = Color(0xFF14A1FF);
  static const cPink = Color(0xFFFF6FB5);
  static const cYellow = Color(0xFFFFE600);
  static const cGreen = Color(0xFF2ECC71);

  double get _progress {
    if (totalSteps <= 0) return 0;
    final v = stepIndex / totalSteps;
    return v.clamp(0.0, 1.0);
  }

  @override
  Widget build(BuildContext context) {
    const double topSpacing = 50;

    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        backgroundColor: Colors.white,
        body: Stack(
          children: [
            const Positioned.fill(child: ColoredBox(color: Colors.white)),

            // رموز بالخلفية
            Positioned.fill(
              child: CustomPaint(
                painter: _CodeSymbolsPainter(
                  symbols: const [
                    _Symbol(x: 0.16, y: 0.20, text: '</>', color: cBlue),
                    _Symbol(x: 0.22, y: 0.46, text: '{}', color: cPurple),
                    _Symbol(x: 0.74, y: 0.18, text: ';', color: cPink),
                    _Symbol(x: 0.82, y: 0.44, text: '()', color: cYellow),
                    _Symbol(x: 0.14, y: 0.76, text: '<>', color: cPink),
                    _Symbol(x: 0.86, y: 0.72, text: '[]', color: cBlue),
                    _Symbol(x: 0.38, y: 0.16, text: '=>', color: cYellow),
                    _Symbol(x: 0.62, y: 0.80, text: '//', color: cPurple),
                    _Symbol(x: 0.52, y: 0.12, text: 'var', color: cBlue),
                  ],
                ),
              ),
            ),

            SafeArea(
              child: Column(
                children: [
                  // Top bar
                  LevelTopBar(
                    userId: userId,
                    levelTitle: 'اساسيات البرمجة',
                    onBack: () => Navigator.pop(context),
                  ),





                  const SizedBox(height: topSpacing),

                  Expanded(
                    child: Stack(
                      children: [
                        SingleChildScrollView(
                          physics: const BouncingScrollPhysics(),
                          padding: const EdgeInsets.fromLTRB(16, 0, 16, 120),
                          child: Column(
                            children: [
                              Container(
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
                                    const SizedBox(height: 8),

                                    Image.asset(
                                      'assets/images/boy1.png',
                                      width: 190,
                                      height: 190,
                                      fit: BoxFit.contain,
                                      errorBuilder: (_, __, ___) => Container(
                                        width: 190,
                                        height: 190,
                                        alignment: Alignment.center,
                                        decoration: BoxDecoration(
                                          color: const Color(0xFFF7F7F7),
                                          borderRadius: BorderRadius.circular(18),
                                          border: Border.all(
                                            color: Colors.black.withOpacity(0.06),
                                          ),
                                        ),
                                        child: const Icon(
                                          Icons.image_not_supported_rounded,
                                          size: 42,
                                          color: Color(0xFF8E5CCB),
                                        ),
                                      ),
                                    ),

                                    const SizedBox(height: 14),

                                    Text(
                                      'المستوى الأول',
                                      textAlign: TextAlign.center,
                                      style: GoogleFonts.cairo(
                                        fontSize: 22,
                                        fontWeight: FontWeight.w900,
                                        color: Colors.black87,
                                        height: 1.6,
                                      ),
                                    ),
                                    const SizedBox(height: 6),
                                    Text(
                                      'في هذا المستوى سنتعلّم ثلاثة دروس مهمّة.:\nالمتغيرات، الإدخال والإخراج، والشرط.\nوفي النهاية سنحلّ 5 أسئلة للمراجعة.',
                                      textAlign: TextAlign.center,
                                      style: GoogleFonts.cairo(
                                        fontSize: 15.5,
                                        fontWeight: FontWeight.w700,
                                        color: Colors.black54,
                                        height: 1.7,
                                      ),
                                    ),

                                    const SizedBox(height: 14),

                                    _MiniCard(
                                      title: '✅ ماذا سنتعلّم؟',
                                      items: const [
                                        'الدرس 1: المتغيرات.',
                                        'الدرس 2: الإدخال والإخراج.',
                                        'الدرس 3: الشرط.',
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),

                        // زر التالي
                        Positioned(
                          left: 16,
                          right: 16,
                          bottom: 16,
                          child: SafeArea(
                            top: false,
                            child: Center(
                              child: SizedBox(
                                width: 160,
                                height: 54,
                                child: ElevatedButton(
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: cGreen,
                                    foregroundColor: Colors.white,
                                    elevation: 2,
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(24),
                                      side: const BorderSide(color: Colors.white, width: 3),
                                    ),
                                  ),
                                  onPressed: () {
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (_) => Lesson1_1Screen(
                                          userId: userId,
                                          userName: userName,
                                        ),
                                      ),
                                    );
                                  },
                                  child: Text(
                                    'التالي',
                                    style: GoogleFonts.cairo(
                                      fontSize: 17,
                                      fontWeight: FontWeight.w900,
                                      color: Colors.white,
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

/* ===== Widgets (نفس مالچ) ===== */

class _MiniCard extends StatelessWidget {
  final String title;
  final List<String> items;
  const _MiniCard({required this.title, required this.items});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.fromLTRB(14, 12, 14, 12),
      decoration: BoxDecoration(
        color: const Color(0xFFF7F7F7),
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: Colors.black.withOpacity(0.06)),
      ),
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
          const SizedBox(height: 8),
          ...items.map(
                (t) => Padding(
              padding: const EdgeInsets.only(bottom: 6),
              child: Text(
                '• $t',
                style: GoogleFonts.cairo(
                  fontSize: 14.5,
                  fontWeight: FontWeight.w700,
                  color: Colors.black54,
                  height: 1.6,
                ),
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
      final textPainter = TextPainter(
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

      final x = size.width * s.x - (textPainter.width / 2);
      final y = size.height * s.y - (textPainter.height / 2);

      canvas.save();
      canvas.translate(x, y);
      canvas.rotate(-0.25);
      textPainter.paint(canvas, Offset.zero);
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
