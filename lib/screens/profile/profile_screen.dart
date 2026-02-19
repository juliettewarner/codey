import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../services/auth_service.dart';
import '../../services/session_service.dart';
import '../auth/login_screen.dart';

class ProfileScreen extends StatelessWidget {
  final String userId;
  const ProfileScreen({super.key, required this.userId});

  // Palette
  static const cOffWhite = Color(0xFFF2EFE6);
  static const cPurple = Color(0xFF8E5CCB);
  static const cBlue = Color(0xFF14A1FF);
  static const cPink = Color(0xFFFF6FB5);
  static const cYellow = Color(0xFFFFE600);

  // ✅ صور الأفاتارات الموجودة بالـ assets
  static const List<String> _avatars = ['a1', 'a2', 'a3', 'a4', 'a5', 'a6'];

  // =========================
  // ✅ Dialog تأكيد تسجيل الخروج
  // =========================
  Future<void> _confirmLogout(BuildContext context) async {
    final result = await showDialog<bool>(
      context: context,
      barrierDismissible: false,
      builder: (ctx) {
        return Directionality(
          textDirection: TextDirection.rtl,
          child: AlertDialog(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(22),
            ),
            title: Text(
              'تأكيد',
              style: GoogleFonts.cairo(
                fontSize: 18,
                fontWeight: FontWeight.w900,
              ),
            ),
            content: Text(
              'هل أنتِ متأكدة من تسجيل الخروج؟',
              style: GoogleFonts.cairo(
                fontSize: 15,
                fontWeight: FontWeight.w700,
              ),
            ),
            actionsPadding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
            actions: [
              // زر إلغاء
              OutlinedButton(
                onPressed: () => Navigator.pop(ctx, false),
                style: OutlinedButton.styleFrom(
                  foregroundColor: cPurple,
                  side: const BorderSide(color: cPurple, width: 2),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(14),
                  ),
                ),
                child: Text(
                  'إلغاء',
                  style: GoogleFonts.cairo(
                    fontWeight: FontWeight.w800,
                  ),
                ),
              ),

              // زر تأكيد الخروج
              ElevatedButton(
                onPressed: () => Navigator.pop(ctx, true),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.redAccent,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(24),
                    side: const BorderSide(color: Colors.white, width: 3),
                  ),
                ),
                child: Text(
                  'تسجيل الخروج',
                  style: GoogleFonts.cairo(
                    fontWeight: FontWeight.w800,
                    color: Colors.white,
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );

    if (result == true) {
      await SessionService().clearSession();
      if (!context.mounted) return;

      Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(builder: (_) => const LoginScreen()),
            (route) => false,
      );
    }
  }

  // =========================
  // ✅ اختيار أفاتار
  // =========================
  void _showAvatarPicker(BuildContext context, String userId) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(22)),
      ),
      builder: (_) {
        return Directionality(
          textDirection: TextDirection.rtl,
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  'اختاري أفاتار',
                  style: GoogleFonts.cairo(
                    fontSize: 16,
                    fontWeight: FontWeight.w900,
                  ),
                ),
                const SizedBox(height: 14),
                GridView.builder(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemCount: _avatars.length,
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 3,
                    crossAxisSpacing: 12,
                    mainAxisSpacing: 12,
                  ),
                  itemBuilder: (context, i) {
                    final id = _avatars[i];
                    return InkWell(
                      borderRadius: BorderRadius.circular(18),
                      onTap: () async {
                        try {
                          await AuthService().updateUser(
                            userId: userId,
                            data: {'avatarId': id},
                          );
                          if (context.mounted) Navigator.pop(context);
                        } catch (e) {
                          if (context.mounted) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                content: Text('صار خطأ بتحديث الصورة: $e'),
                              ),
                            );
                          }
                        }
                      },
                      child: Container(
                        decoration: BoxDecoration(
                          color: cOffWhite,
                          borderRadius: BorderRadius.circular(18),
                          boxShadow: [
                            BoxShadow(
                              blurRadius: 14,
                              offset: const Offset(0, 10),
                              color: Colors.black.withOpacity(0.08),
                            ),
                          ],
                        ),
                        child: Padding(
                          padding: const EdgeInsets.all(10),
                          child: Image.asset(
                            'assets/avatars/$id.png',
                            fit: BoxFit.contain,
                            errorBuilder: (_, __, ___) => const Icon(
                              Icons.person_rounded,
                              color: cPurple,
                              size: 36,
                            ),
                          ),
                        ),
                      ),
                    );
                  },
                ),
                const SizedBox(height: 10),
              ],
            ),
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final auth = AuthService();

    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        backgroundColor: Colors.white,
        body: Stack(
          children: [
            const Positioned.fill(child: ColoredBox(color: Colors.white)),

            // ✅ رموز بالخلفية
            Positioned.fill(
              child: CustomPaint(
                painter: _CodeSymbolsPainter(
                  symbols: const [
                    _Symbol(x: 0.16, y: 0.18, text: '</>', color: cBlue),
                    _Symbol(x: 0.22, y: 0.46, text: '{}', color: cPurple),
                    _Symbol(x: 0.78, y: 0.18, text: ';', color: cPink),
                    _Symbol(x: 0.80, y: 0.50, text: '()', color: cYellow),
                    _Symbol(x: 0.14, y: 0.78, text: '<>', color: cPink),
                    _Symbol(x: 0.86, y: 0.76, text: '[]', color: cBlue),
                    _Symbol(x: 0.36, y: 0.12, text: '=>', color: cYellow),
                    _Symbol(x: 0.62, y: 0.86, text: '//', color: cPurple),
                    _Symbol(x: 0.52, y: 0.10, text: 'var', color: cBlue),
                  ],
                ),
              ),
            ),

            SafeArea(
              child: StreamBuilder(
                stream: auth.userStream(userId: userId),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Center(child: CircularProgressIndicator());
                  }

                  if (!snapshot.hasData || snapshot.data?.data() == null) {
                    return Center(
                      child: Text(
                        'ما لكيت بيانات المستخدم',
                        style: GoogleFonts.cairo(
                          fontSize: 16,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    );
                  }

                  final data = snapshot.data!.data()!;
                  final name = (data['name'] ?? '').toString();
                  final age = (data['age'] ?? 0).toString();
                  final points = (data['points'] ?? 0).toString();
                  final level = (data['level'] ?? 0).toString();
                  final avatarId = (data['avatarId'] ?? '').toString();

                  return SingleChildScrollView(
                    padding: const EdgeInsets.fromLTRB(18, 10, 18, 24),
                    child: Column(
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              'الصفحة الشخصية',
                              style: GoogleFonts.fredoka(
                                fontSize: 20,
                                fontWeight: FontWeight.w800,
                                letterSpacing: 0.5,
                                color: Colors.black87,
                              ),
                            ),
                          ],
                        ),

                        const SizedBox(height: 18),

                        _ProfileHeaderCard(
                          name: name,
                          age: age,
                          avatarId: avatarId,
                          onChangeAvatar: () =>
                              _showAvatarPicker(context, userId),
                        ),

                        const SizedBox(height: 25),

                        Row(
                          children: [
                            Expanded(
                              child: _StatCard(
                                title: 'المستوى',
                                value: level,
                                icon: Icons.rocket_launch_rounded,
                                bg: cPurple,
                              ),
                            ),
                            const SizedBox(width: 30),
                            Expanded(
                              child: _StatCard(
                                title: 'النقاط',
                                value: points,
                                icon: Icons.stars_rounded,
                                bg: cBlue,
                              ),
                            ),
                          ],
                        ),

                        const SizedBox(height: 150),

                        SizedBox(
                          width: 220,
                          height: 52,
                          child: ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.redAccent,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(24),
                                side: const BorderSide(
                                  color: Colors.white,
                                  width: 3, // ✅ نفس سماكة زر التأكيد
                                ),
                              ),

                            ),
                            onPressed: () => _confirmLogout(context),
                            child: Text(
                              'تسجيل الخروج',
                              style: GoogleFonts.cairo(
                                fontSize: 16,
                                fontWeight: FontWeight.w800,
                                color: Colors.white,
                              ),
                            ),
                          ),
                        ),

                      ],
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}

/* ---------------- Widgets ---------------- */

class _ProfileHeaderCard extends StatelessWidget {
  final String name;
  final String age;
  final String avatarId;
  final VoidCallback onChangeAvatar;

  const _ProfileHeaderCard({
    required this.name,
    required this.age,
    required this.avatarId,
    required this.onChangeAvatar,
  });

  static const cOffWhite = Color(0xFFF2EFE6);
  static const cPurple = Color(0xFF8E5CCB);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: cOffWhite,
        borderRadius: BorderRadius.circular(22),
        boxShadow: [
          BoxShadow(
            blurRadius: 18,
            offset: const Offset(0, 12),
            color: Colors.black.withOpacity(0.10),
          ),
          BoxShadow(
            blurRadius: 0,
            offset: const Offset(0, 0),
            color: Colors.white.withOpacity(0.40),
            spreadRadius: 1,
          ),
        ],
      ),
      child: Column(
        children: [
          Container(
            width: 110,
            height: 110,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(32),
              boxShadow: [
                BoxShadow(
                  blurRadius: 18,
                  offset: const Offset(0, 12),
                  color: Colors.black.withOpacity(0.10),
                ),
              ],
            ),
            child: Padding(
              padding: const EdgeInsets.all(14),
              child: (avatarId.isEmpty)
                  ? const Icon(
                Icons.person_rounded,
                size: 60,
                color: cPurple,
              )
                  : Image.asset(
                'assets/avatars/$avatarId.png',
                fit: BoxFit.contain,
                errorBuilder: (_, __, ___) => const Icon(
                  Icons.person_rounded,
                  size: 60,
                  color: cPurple,
                ),
              ),
            ),
          ),

          const SizedBox(height: 10),

          SizedBox(
            height: 36,
            child: OutlinedButton.icon(
              onPressed: onChangeAvatar,
              icon: const Icon(Icons.edit_rounded, size: 18),
              label: Text(
                'تعديل الصورة',
                style: GoogleFonts.cairo(
                  fontSize: 13,
                  fontWeight: FontWeight.w800,
                ),
              ),
              style: OutlinedButton.styleFrom(
                foregroundColor: cPurple,
                side: const BorderSide(color: cPurple),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(14),
                ),
              ),
            ),
          ),

          const SizedBox(height: 14),

          Text(
            name.isEmpty ? 'مستخدم' : name,
            textAlign: TextAlign.center,
            style: GoogleFonts.cairo(
              fontSize: 18,
              fontWeight: FontWeight.w900,
              color: Colors.black87,
            ),
          ),

          const SizedBox(height: 6),

          Text(
            'العمر: $age',
            textAlign: TextAlign.center,
            style: GoogleFonts.cairo(
              fontSize: 14,
              fontWeight: FontWeight.w700,
              color: Colors.black54,
            ),
          ),
        ],
      ),
    );
  }
}

class _StatCard extends StatelessWidget {
  final String title;
  final String value;
  final IconData icon;
  final Color bg;

  const _StatCard({
    required this.title,
    required this.value,
    required this.icon,
    required this.bg,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 92,
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: bg,
        borderRadius: BorderRadius.circular(22),
        boxShadow: [
          BoxShadow(
            blurRadius: 18,
            offset: const Offset(0, 12),
            color: Colors.black.withOpacity(0.12),
          ),
          BoxShadow(
            blurRadius: 0,
            offset: const Offset(0, 0),
            color: Colors.white.withOpacity(0.18),
            spreadRadius: 1,
          ),
        ],
      ),
      child: Stack(
        children: [
          Positioned(
            left: 10,
            top: 10,
            child: Container(
              width: 16,
              height: 16,
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.22),
                shape: BoxShape.circle,
              ),
            ),
          ),
          Row(
            children: [
              Icon(icon, color: Colors.white, size: 26),
              const SizedBox(width: 10),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      title,
                      style: GoogleFonts.cairo(
                        fontSize: 13,
                        fontWeight: FontWeight.w800,
                        color: Colors.white.withOpacity(0.92),
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      value,
                      style: GoogleFonts.fredoka(
                        fontSize: 22,
                        fontWeight: FontWeight.w800,
                        color: Colors.white,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

/* ---------------- Background Painter ---------------- */

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
