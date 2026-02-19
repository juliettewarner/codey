import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../widgets/level_top_bar.dart';

import '../../../services/auth_service.dart';
import '../../home/home_screen.dart';

class Lv0Quiz5Screen extends StatefulWidget {
  final String userId;
  final String userName;

  const Lv0Quiz5Screen({
    super.key,
    required this.userId,
    required this.userName,
  });

  @override
  State<Lv0Quiz5Screen> createState() => _Lv0Quiz5ScreenState();
}

class _Lv0Quiz5ScreenState extends State<Lv0Quiz5Screen> {
  final _auth = AuthService();
  final _db = FirebaseFirestore.instance;

  static const cOffWhite = Color(0xFFF2EFE6);
  static const cPurple = Color(0xFF8E5CCB);
  static const cBlue = Color(0xFF14A1FF);
  static const cPink = Color(0xFFFF6FB5);
  static const cYellow = Color(0xFFFFE600);
  static const cGreen = Color(0xFF2ECC71);

  // ✅ Selection Colors
  static const _cCorrectBorder = Color(0xFF2ECC71);
  static const _cWrongBorder = Color(0xFFE74C3C);
  static const _cCorrectBg = Color(0xFFE9F8EF);
  static const _cWrongBg = Color(0xFFFDEBEC);

  int? _selectedCorrect;
  int? _selectedWrong;

  final int stepIndex = 5;
  final int totalSteps = 5;
  double get _progress => (stepIndex / totalSteps).clamp(0.0, 1.0);

  final String question = 'أي جهاز يُستخدم لإدخال البيانات إلى الحاسوب؟';
  final List<String> options = const ['الشاشة', 'لوحة المفاتيح', 'الطابعة'];
  final int correctIndex = 1;

  bool _checking = false;

  Future<void> _unlockLv1() async {
    await _db.collection('users').doc(widget.userId).set({
      'unlocked': {'lv1': true}
    }, SetOptions(merge: true));
  }

  void _goHome(String message) {
    Navigator.of(context).pushAndRemoveUntil(
      MaterialPageRoute(
        builder: (_) => HomeScreen(userName: widget.userName, userId: widget.userId),
        settings: RouteSettings(arguments: {'snack': message}),
      ),
          (route) => false,
    );
  }

  Future<void> _showResultDialog({
    required bool isCorrect,
    required String message,
  }) async {
    await showDialog(
      context: context,
      barrierDismissible: false,
      builder: (_) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: Text(
          isCorrect ? 'أحسنت ✅' : 'خطأ ❌',
          style: GoogleFonts.cairo(fontWeight: FontWeight.w900),
        ),
        content: Text(
          message,
          style: GoogleFonts.cairo(height: 1.6, fontWeight: FontWeight.w700),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text('حسنًا', style: GoogleFonts.cairo(fontWeight: FontWeight.w800)),
          ),
        ],
      ),
    );
  }

  Future<void> _onChoose(int idx) async {
    if (_checking) return;

    if (idx != correctIndex) {
      setState(() {
        _selectedWrong = idx;
        _selectedCorrect = null;
      });

      await _showResultDialog(
        isCorrect: false,
        message: 'الإجابة خاطئة، حاول مرة أخرى.',
      );

      if (!mounted) return;
      setState(() => _selectedWrong = null);
      return;
    }

    setState(() {
      _checking = true;
      _selectedCorrect = idx;
      _selectedWrong = null;
    });

    bool gotReward = false;
    try {
      gotReward = await _auth.awardPointsOnce(
        userId: widget.userId,
        rewardKey: 'lv0_q5',
        points: 1,
      );

      await _unlockLv1();
    } catch (_) {}

    if (!mounted) return;

    final msg = gotReward
        ? 'إجابتك صحيحة 👏\nلقد حصلت على نقطة واحدة.\n\nتم فتح المستوى 1 ✅'
        : 'إجابتك صحيحة ✅\nلكن هذه النقطة أخذتيها سابقاً 🙂\n\nتم فتح المستوى 1 ✅';

    await _showResultDialog(isCorrect: true, message: msg);

    if (!mounted) return;

    _goHome('أحسنتِ 🎉 صار عندج 5 نقاط وتم فتح المستوى 1 ✅');
  }

  @override
  Widget build(BuildContext context) {
    const topSpacing = 40.0;

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
                  LevelTopBar(
                    userId: widget.userId,
                    levelTitle: 'مقدمه عن الحاسوب و البرمجة',
                    onBack: () => Navigator.pop(context),
                  ),


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
                            value: _progress,
                            backgroundColor: const Color(0xFFEDEAE3),
                            valueColor: const AlwaysStoppedAnimation(cGreen),
                          ),
                        ),
                      ),
                    ),
                  ),

                  const SizedBox(height: topSpacing),

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
                            Text(
                              'سؤال 5',
                              style: GoogleFonts.cairo(
                                fontSize: 18,
                                fontWeight: FontWeight.w900,
                                color: Colors.black87,
                              ),
                            ),
                            const SizedBox(height: 12),
                            Text(
                              question,
                              textAlign: TextAlign.center,
                              style: GoogleFonts.cairo(
                                fontSize: 18,
                                fontWeight: FontWeight.w900,
                                height: 1.7,
                                color: Colors.black87,
                              ),
                            ),
                            const SizedBox(height: 16),

                            ...List.generate(options.length, (i) {
                              final isCorrectSel = _selectedCorrect == i;
                              final isWrongSel = _selectedWrong == i;

                              final borderColor = isCorrectSel
                                  ? _cCorrectBorder
                                  : isWrongSel
                                  ? _cWrongBorder
                                  : Colors.black.withOpacity(0.10);

                              final bgColor = isCorrectSel
                                  ? _cCorrectBg
                                  : isWrongSel
                                  ? _cWrongBg
                                  : Colors.white.withOpacity(0.95);

                              final borderWidth =
                              (isCorrectSel || isWrongSel) ? 3.0 : 1.0;

                              return Padding(
                                padding: const EdgeInsets.only(bottom: 10),
                                child: InkWell(
                                  borderRadius: BorderRadius.circular(18),
                                  onTap: _checking ? null : () => _onChoose(i),
                                  child: AnimatedContainer(
                                    duration: const Duration(milliseconds: 180),
                                    curve: Curves.easeOut,
                                    width: double.infinity,
                                    padding: const EdgeInsets.symmetric(
                                      horizontal: 14,
                                      vertical: 14,
                                    ),
                                    decoration: BoxDecoration(
                                      color: bgColor,
                                      borderRadius: BorderRadius.circular(18),
                                      border: Border.all(
                                        color: borderColor,
                                        width: borderWidth,
                                      ),
                                      boxShadow: [
                                        BoxShadow(
                                          blurRadius: 12,
                                          offset: const Offset(0, 8),
                                          color: Colors.black.withOpacity(0.06),
                                        ),
                                      ],
                                    ),
                                    child: Text(
                                      options[i],
                                      textAlign: TextAlign.center,
                                      style: GoogleFonts.cairo(
                                        fontSize: 16,
                                        fontWeight: FontWeight.w900,
                                        color: Colors.black87,
                                      ),
                                    ),
                                  ),
                                ),
                              );
                            }),

                            if (_checking) ...[
                              const SizedBox(height: 8),
                              const CircularProgressIndicator(),
                            ],
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
