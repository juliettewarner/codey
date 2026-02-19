import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../services/auth_service.dart';
import '../profile/profile_screen.dart';

// شاشات المستويات
import '../learning/lv_0/intro1_screen.dart';
import '../learning/lv_1/intro_screen.dart';
import '../learning/lv_1/lesson1_1.dart';
import '../learning/lv_1/lesson2_1.dart';
import '../learning/lv_1/lesson3_1.dart';
import '../dictionary/dictionary_screen.dart';
import '../learning/lv_1/quiz1.dart';

// ✅ Lv2
import '../learning/lv_2/intro_screen.dart';
import '../learning/lv_2/quiz1.dart' as lv2q1;
import '../learning/lv_2/quiz2.dart' as lv2q2;
import '../learning/lv_2/quiz3.dart' as lv2q3;
import '../learning/lv_2/quiz4.dart' as lv2q4;
import '../learning/lv_2/quiz5.dart' as lv2q5;

class HomeScreen extends StatefulWidget {
  final String userName;
  final String userId;

  const HomeScreen({
    super.key,
    required this.userName,
    required this.userId,
  });

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> with TickerProviderStateMixin {
  int _index = 1;
  final _auth = AuthService();

  @override
  Widget build(BuildContext context) {
    final pages = <Widget>[
      const _ComingSoonPage(title: 'صفحة الاختبارات'),
      _LevelsMapPage(
        userId: widget.userId,
        userName: widget.userName,
        auth: _auth,
      ),
      const DictionaryScreen(),
      ProfileScreen(userId: widget.userId),
    ];

    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        backgroundColor: Colors.white,
        body: SafeArea(
          child: IndexedStack(index: _index, children: pages),
        ),
        bottomNavigationBar: _CreativeBottomNav(
          currentIndex: _index,
          onTap: (i) => setState(() => _index = i),
        ),
      ),
    );
  }
}

class _LevelsMapPage extends StatefulWidget {
  final String userId;
  final String userName;
  final AuthService auth;

  const _LevelsMapPage({
    required this.userId,
    required this.userName,
    required this.auth,
  });

  @override
  State<_LevelsMapPage> createState() => _LevelsMapPageState();
}

class _LevelsMapPageState extends State<_LevelsMapPage>
    with SingleTickerProviderStateMixin {
  late final AnimationController _pulse;
  late final ScrollController _scrollCtrl;
  bool _didJump = false;

  // Palette
  static const cOffWhite = Color(0xFFF2EFE6);
  static const cPurple = Color(0xFF8E5CCB);
  static const cBlue = Color(0xFF14A1FF);
  static const cPink = Color(0xFFFF6FB5);
  static const cYellow = Color(0xFFFFE600);
  static const cGreen = Color(0xFF2ECC71);

  // Background + Path
  static const bgSoft = Color(0xFFFAFAFA);
  static const pathLocked = Color(0xFFEAEAEA);

  static const lv1A = Color(0xFFAA85D6);
  static const lv1B = Color(0xFF8D5BC9);

  static const lv0A = Color(0xFF3AA9FF);
  static const lv0B = Color(0xFF147BFF);

  static const grey1 = Color(0xFFBDBDBD);
  static const grey2 = Color(0xFFE0E0E0);

  static const ringColor = Color(0xFFFF4FB8);

  @override
  void initState() {
    super.initState();
    _scrollCtrl = ScrollController();

    _pulse = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 900),
      lowerBound: 0.0,
      upperBound: 1.0,
    )..repeat(reverse: true);
  }

  @override
  void dispose() {
    _scrollCtrl.dispose();
    _pulse.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
      stream: widget.auth.userStream(userId: widget.userId),
      builder: (context, snapshot) {
        final data = snapshot.data?.data();
        final points = (data?['points'] ?? 0) as int;

        final lv0Progress = _as01(data?['lv0Progress'] ?? 0.0);
        final lv1Progress = _as01(data?['lv1Progress'] ?? 0.0);
        final lv2Progress = _as01(data?['lv2Progress'] ?? 0.0);
        final lv3Progress = _as01(data?['lv3Progress'] ?? 0.0);

        final lv0Open = true;
        final lv1Open = points >= 5;
        final lv2Open = points >= 10;
        final lv3Open = points >= 20; // ✅ شرط فتح المستوى 3

        // ⭐ العقدة الحالية
        final String activeId = lv3Open
            ? 'lv3'
            : (lv2Open ? 'lv2' : (lv1Open ? 'lv1' : 'lv0'));

        final double activeProgress = lv3Open
            ? lv3Progress
            : (lv2Open ? lv2Progress : (lv1Open ? lv1Progress : lv0Progress));

        // Lv1
        final t1Open = lv1Open;
        final t2Open = lv1Open;
        final t3Open = lv1Open;
        final quizOpen = lv1Open;

        // ✅ Lv2 (5 نودات صغيرة)
        final lv2qOpen = lv2Open;

        return LayoutBuilder(
          builder: (context, constraints) {
            final w = constraints.maxWidth;
            final h = constraints.maxHeight;

            final mapHeight = h * 3.50; // ✅ زدناها شوي حتى تسع Lv3 و نودات Lv2

            WidgetsBinding.instance.addPostFrameCallback((_) {
              if (!_didJump && _scrollCtrl.hasClients) {
                _didJump = true;
                _scrollCtrl.jumpTo(_scrollCtrl.position.maxScrollExtent);
              }
            });

            final nodes = <_MapNode>[
              // ===================== Lv0 =====================
              _MapNode(
                id: 'lv0',
                type: _NodeType.level,
                title: 'Lv.0',
                subtitle: 'مقدمة عن الحاسوب\nوالبرمجة',
                x: 0.45,
                y: 0.93,
                locked: !lv0Open,
                gradientA: lv0A,
                gradientB: lv0B,
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => Lv0Intro1Screen(
                        userId: widget.userId,
                        userName: widget.userName,
                      ),
                    ),
                  );
                },
              ),

              // ===================== Lv1 =====================
              _MapNode(
                id: 'lv1',
                type: _NodeType.level,
                title: 'Lv.1',
                subtitle: 'أساسيات البرمجة',
                x: 0.29,
                y: 0.82,
                locked: !lv1Open,
                gradientA: lv1A,
                gradientB: lv1B,
                onTap: () {
                  if (!lv1Open) {
                    _snack(context, 'يجب جمع 5 نقاط حتى يفتح Lv.1 ⭐');
                    return;
                  }
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => Lv1IntroScreen(
                        userId: widget.userId,
                        userName: widget.userName,
                      ),
                    ),
                  );
                },
              ),

              _MapNode(
                id: 't1',
                type: _NodeType.topic,
                title: 'المتغيرات',
                x: 0.70,
                y: 0.77,
                locked: !t1Open,
                gradientA: lv1A,
                gradientB: lv1B,
                onTap: () {
                  if (!t1Open) {
                    _snack(context, 'هذا القسم مقفول حالياً 🔒');
                    return;
                  }
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => Lesson1_1Screen(
                        userId: widget.userId,
                        userName: widget.userName,
                      ),
                    ),
                  );
                },
              ),

              _MapNode(
                id: 't2',
                type: _NodeType.topic,
                title: 'الإدخال\nوالإخراج',
                x: 0.35,
                y: 0.73,
                locked: !t2Open,
                gradientA: lv1A,
                gradientB: lv1B,
                onTap: () {
                  if (!t2Open) {
                    _snack(context, 'هذا القسم مقفول حالياً 🔒');
                    return;
                  }
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => Lesson2_1Screen(
                        userId: widget.userId,
                        userName: widget.userName,
                      ),
                    ),
                  );
                },
              ),

              _MapNode(
                id: 't3',
                type: _NodeType.topic,
                title: 'الشرط',
                x: 0.55,
                y: 0.68,
                locked: !t3Open,
                gradientA: lv1A,
                gradientB: lv1B,
                onTap: () {
                  if (!t3Open) {
                    _snack(context, 'هذا القسم مقفول حالياً 🔒');
                    return;
                  }
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => Lesson3_1Screen(
                        userId: widget.userId,
                        userName: widget.userName,
                      ),
                    ),
                  );
                },
              ),

              _MapNode(
                id: 'quiz',
                type: _NodeType.quiz,
                title: 'Quiz',
                x: 0.26,
                y: 0.63,
                locked: !quizOpen,
                gradientA: const Color(0xFFFFF1C2),
                gradientB: const Color(0xFFF1BD1F),
                onTap: () {
                  if (!quizOpen) {
                    _snack(context, 'هذا القسم مقفول حالياً 🔒');
                    return;
                  }
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => Quiz1Screen(
                        userId: widget.userId,
                        userName: widget.userName,
                      ),
                    ),
                  );
                },
              ),

              // ===================== Lv2 (Level) =====================
              _MapNode(
                id: 'lv2',
                type: _NodeType.level,
                title: 'Lv.2',
                subtitle: 'أسئلة متقدمة',
                x: 0.62,
                y: 0.53,
                locked: !lv2Open,
                gradientA: const Color(0xFFFF4FB8),
                gradientB: const Color(0xFFE6008B),
                onTap: () {
                  if (!lv2Open) {
                    _snack(context, 'يجب جمع 10 نقطة حتى يفتح Lv.2 ⭐');
                    return;
                  }
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => Lv2IntroScreen(
                        userId: widget.userId,
                        userName: widget.userName,
                      ),
                    ),
                  );
                },
              ),

              // ✅ 5 نودات صغيرة للمستوى 2
              _MapNode(
                id: 'lv2q1',
                type: _NodeType.topic,
                title: 'ناتج الكود',
                x: 0.35,
                y: 0.48,
                locked: !lv2qOpen,
                gradientA: const Color(0xFFFF4FB8),
                gradientB: const Color(0xFFE6008B),
                onTap: () {
                  if (!lv2qOpen) {
                    _snack(context, 'افتحي Lv.2 أولاً ⭐');
                    return;
                  }
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => lv2q1.Lv2Quiz1Screen(
                        userId: widget.userId,
                        userName: widget.userName,
                      ),
                    ),
                  );
                },
              ),
              _MapNode(
                id: 'lv2q2',
                type: _NodeType.topic,
                title: 'اكتشاف الخطأ',
                x: 0.70,
                y: 0.43,
                locked: !lv2qOpen,
                gradientA: const Color(0xFFFF4FB8),
                gradientB: const Color(0xFFE6008B),
                onTap: () {
                  if (!lv2qOpen) {
                    _snack(context, 'افتحي Lv.2 أولاً ⭐');
                    return;
                  }
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => lv2q2.Lv2Quiz2Screen(
                        userId: widget.userId,
                        userName: widget.userName,
                      ),
                    ),
                  );
                },
              ),
              _MapNode(
                id: 'lv2q3',
                type: _NodeType.topic,
                title: 'الشروط if',
                x: 0.48,
                y: 0.38,
                locked: !lv2qOpen,
                gradientA: const Color(0xFFFF4FB8),
                gradientB: const Color(0xFFE6008B),
                onTap: () {
                  if (!lv2qOpen) {
                    _snack(context, 'افتحي Lv.2 أولاً ⭐');
                    return;
                  }
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => lv2q3.Lv2Quiz3Screen(
                        userId: widget.userId,
                        userName: widget.userName,
                      ),
                    ),
                  );
                },
              ),
              _MapNode(
                id: 'lv2q4',
                type: _NodeType.topic,
                title: 'الكود الصحيح',
                x: 0.22,
                y: 0.33,
                locked: !lv2qOpen,
                gradientA: const Color(0xFFFF4FB8),
                gradientB: const Color(0xFFE6008B),
                onTap: () {
                  if (!lv2qOpen) {
                    _snack(context, 'افتحي Lv.2 أولاً ⭐');
                    return;
                  }
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => lv2q4.Lv2Quiz4Screen(
                        userId: widget.userId,
                        userName: widget.userName,
                      ),
                    ),
                  );
                },
              ),
              _MapNode(
                id: 'lv2q5',
                type: _NodeType.topic,
                title: 'ربط متغيرات',
                x: 0.62,
                y: 0.29,
                locked: !lv2qOpen,
                gradientA: const Color(0xFFFF4FB8),
                gradientB: const Color(0xFFE6008B),
                onTap: () {
                  if (!lv2qOpen) {
                    _snack(context, 'افتحي Lv.2 أولاً ⭐');
                    return;
                  }
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => lv2q5.Lv2Quiz5Screen(
                        userId: widget.userId,
                        userName: widget.userName,
                      ),
                    ),
                  );
                },
              ),

              // ===================== Lv3 =====================
              _MapNode(
                id: 'lv3',
                type: _NodeType.level,
                title: 'Lv.3',
                subtitle: 'تحديات أصعب',
                x: 0.50,
                y: 0.15,
                locked: !lv3Open,
                gradientA: const Color(0xFF2ECC71),
                gradientB: const Color(0xFF18B35A),
                onTap: () {
                  if (!lv3Open) {
                    _snack(context, 'يجب جمع 15 نقطة حتى يفتح Lv.3 ⭐');
                    return;
                  }
                  _snack(context, 'Lv.3 بعده قيد الإعداد 😊');
                },
              ),
            ];

            Offset cOf(String id) {
              final n = nodes.firstWhere((e) => e.id == id);
              return Offset(w * n.x, mapHeight * n.y);
            }

            // ✅ مسار كامل
            final pathCenters = <Offset>[
              cOf('lv0'),
              cOf('lv1'),
              cOf('t1'),
              cOf('t2'),
              cOf('t3'),
              cOf('quiz'),
              cOf('lv2'),
              cOf('lv2q1'),
              cOf('lv2q2'),
              cOf('lv2q3'),
              cOf('lv2q4'),
              cOf('lv2q5'),
              cOf('lv3'),
            ];

            return Stack(
              children: [
                const Positioned.fill(child: ColoredBox(color: Colors.white)),

                // أعلى اليسار
                Positioned(
                  left: 16,
                  top: 10,
                  child: Row(
                    children: [
                      Container(
                        width: 40,
                        height: 40,
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(14),
                          boxShadow: [
                            BoxShadow(
                              blurRadius: 18,
                              offset: const Offset(0, 10),
                              color: Colors.black.withOpacity(0.08),
                            ),
                          ],
                        ),
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(14),
                          child: Image.asset(
                            'assets/logo/robot_head.jpg',
                            fit: BoxFit.cover,
                          ),
                        ),
                      ),
                      const SizedBox(width: 10),
                      Text(
                        'CODEY',
                        style: GoogleFonts.fredoka(
                          fontSize: 18,
                          fontWeight: FontWeight.w700,
                          letterSpacing: 2.2,
                          color: Colors.black87,
                        ),
                      ),
                    ],
                  ),
                ),

                // أعلى اليمين: النقاط
                Positioned(
                  right: 16,
                  top: 10,
                  child: _PointsChip(points: points),
                ),

                // الخريطة
                Positioned.fill(
                  top: 70,
                  child: SingleChildScrollView(
                    controller: _scrollCtrl,
                    physics: const BouncingScrollPhysics(),
                    child: SizedBox(
                      width: w,
                      height: mapHeight,
                      child: Stack(
                        children: [
                          Positioned.fill(
                            child: CustomPaint(
                              painter: _PlayfulBgPainter(),
                            ),
                          ),


                          // رموز بالخلفية
                          // رموز بالخلفية (متحركة)
                          Positioned.fill(
                            child: AnimatedBuilder(
                              animation: _pulse,
                              builder: (context, _) {
                                return CustomPaint(
                                  painter: _CodeSymbolsPainter(
                                    t: _pulse.value, // ✅ نمرّر قيمة الحركة
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

                                      // ✅ رموز إضافية حتى تصير أحلى للأطفال
                                      _Symbol(x: 0.30, y: 0.60, text: 'if', color: cGreen),
                                      _Symbol(x: 0.58, y: 0.58, text: 'print', color: cBlue),
                                      _Symbol(x: 0.44, y: 0.28, text: '==', color: cPink),
                                      _Symbol(x: 0.80, y: 0.30, text: '++', color: cYellow),
                                      _Symbol(x: 0.10, y: 0.34, text: 'int', color: cPurple),
                                    ],
                                  ),
                                );
                              },
                            ),
                          ),


                          // المسار
                          Positioned.fill(
                            child: CustomPaint(
                              painter: _DuolingoPathPainter(
                                nodes: pathCenters,
                                baseColor: pathLocked,
                                strokeWidth: 16,
                              ),
                            ),
                          ),

                          // العقد
                          for (final n in nodes)
                            _PositionedNode(
                              node: n,
                              mapWidth: w,
                              mapHeight: mapHeight,
                              isActive: n.id == activeId,
                              ringProgress: (n.id == activeId) ? activeProgress : null,
                              pulse: n.id == activeId,
                              pulseAnim: _pulse,
                            ),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            );
          },
        );
      },
    );
  }

  double _as01(dynamic v) {
    if (v is int) return v.clamp(0, 1).toDouble();
    if (v is double) return v.clamp(0.0, 1.0);
    if (v is num) return v.toDouble().clamp(0.0, 1.0);
    return 0.0;
  }

  void _snack(BuildContext context, String msg) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(msg)));
  }
}

class _PositionedNode extends StatelessWidget {
  final _MapNode node;
  final double mapWidth;
  final double mapHeight;
  final bool isActive;
  final bool pulse;
  final AnimationController? pulseAnim;
  final double? ringProgress;

  const _PositionedNode({
    required this.node,
    required this.mapWidth,
    required this.mapHeight,
    required this.isActive,
    required this.pulse,
    required this.pulseAnim,
    required this.ringProgress,
  });

  @override
  Widget build(BuildContext context) {
    final dx = mapWidth * node.x;
    final dy = mapHeight * node.y;

    final size = node.type == _NodeType.level ? 84.0 : 52.0;

    Widget child = _DuolingoNode(
      title: node.title,
      subtitle: node.subtitle,
      type: node.type,
      size: size,
      locked: node.locked,
      active: isActive,
      ringProgress: ringProgress,
      gradientA: node.locked ? _LevelsMapPageState.grey1 : node.gradientA,
      gradientB: node.locked ? _LevelsMapPageState.grey2 : node.gradientB,
      onTap: node.onTap,
    );

    if (pulse && pulseAnim != null) {
      child = AnimatedBuilder(
        animation: pulseAnim!,
        builder: (context, w) {
          final t = pulseAnim!.value;
          final scale = 1.0 + (t * 0.045);
          return Transform.scale(scale: scale, child: w);
        },
        child: child,
      );
    }

    return Positioned(
      left: dx - size / 2,
      top: dy - size / 2,
      child: child,
    );
  }
}

class _DuolingoNode extends StatelessWidget {
  final String title;
  final String? subtitle;
  final _NodeType type;
  final double size;
  final bool locked;
  final bool active;
  final Color gradientA;
  final Color gradientB;
  final VoidCallback onTap;
  final double? ringProgress;

  const _DuolingoNode({
    required this.title,
    required this.subtitle,
    required this.type,
    required this.size,
    required this.locked,
    required this.active,
    required this.gradientA,
    required this.gradientB,
    required this.onTap,
    required this.ringProgress,
  });

  @override
  Widget build(BuildContext context) {
    final isSmall = type != _NodeType.level;

    final icon = locked
        ? Icons.lock_rounded
        : (type == _NodeType.quiz
        ? Icons.quiz_rounded
        : type == _NodeType.topic
        ? Icons.description_rounded
        : Icons.school_rounded);

    final showRing = active && ringProgress != null;

    return GestureDetector(
      onTap: locked ? null : onTap,
      child: Opacity(
        opacity: locked ? 0.45 : 1,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Stack(
              alignment: Alignment.center,
              children: [
                if (showRing)
                  SizedBox(
                    width: size + 20,
                    height: size + 20,
                    child: Theme(
                      data: Theme.of(context).copyWith(
                        colorScheme: Theme.of(context).colorScheme.copyWith(
                          primary: _LevelsMapPageState.ringColor,
                        ),
                      ),
                      child: CircularProgressIndicator(
                        value: ringProgress!.clamp(0.0, 1.0),
                        strokeWidth: 8,
                        backgroundColor: Colors.white.withOpacity(0.6),
                      ),
                    ),
                  ),
                Container(
                  width: size,
                  height: size,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    gradient: LinearGradient(
                      colors: [gradientA, gradientB],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    ),
                    boxShadow: [
                      BoxShadow(
                        blurRadius: 18,
                        offset: const Offset(0, 12),
                        color: Colors.black.withOpacity(0.15),
                      ),
                    ],
                  ),
                  child: Center(
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(icon, color: Colors.white, size: size * 0.42),
                        if (!isSmall) ...[
                          const SizedBox(height: 4),
                          Text(
                            title,
                            textAlign: TextAlign.center,
                            style: GoogleFonts.fredoka(
                              fontSize: 14,
                              fontWeight: FontWeight.w700,
                              color: Colors.white,
                            ),
                          ),
                        ],
                      ],
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),
            if (isSmall)
              Text(
                title,
                textAlign: TextAlign.center,
                style: GoogleFonts.cairo(
                  fontSize: 12,
                  fontWeight: FontWeight.w900,
                  color: Colors.black87,
                  height: 1.15,
                ),
              ),
            if (!isSmall && subtitle != null) ...[
              const SizedBox(height: 4),
              Text(
                subtitle!,
                textAlign: TextAlign.center,
                style: GoogleFonts.cairo(
                  fontSize: 13,
                  fontWeight: FontWeight.w900,
                  color: Colors.black,
                  height: 1.2,
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}

class _DuolingoPathPainter extends CustomPainter {
  final List<Offset> nodes;
  final Color baseColor;
  final double strokeWidth;

  _DuolingoPathPainter({
    required this.nodes,
    required this.baseColor,
    required this.strokeWidth,
  });

  @override
  void paint(Canvas canvas, Size size) {
    if (nodes.length < 2) return;

    final path = Path()..moveTo(nodes.first.dx, nodes.first.dy);

    for (int i = 0; i < nodes.length - 1; i++) {
      final a = nodes[i];
      final b = nodes[i + 1];
      final mid = Offset((a.dx + b.dx) / 2, (a.dy + b.dy) / 2);

      final dx = (i.isEven ? 1 : -1) * (size.width * 0.18);
      final ctrl = Offset(mid.dx + dx, mid.dy);

      path.quadraticBezierTo(ctrl.dx, ctrl.dy, b.dx, b.dy);
    }

    final paint = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = strokeWidth
      ..strokeCap = StrokeCap.round
      ..color = baseColor.withOpacity(0.45);

    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(covariant _DuolingoPathPainter oldDelegate) {
    return oldDelegate.nodes != nodes ||
        oldDelegate.baseColor != baseColor ||
        oldDelegate.strokeWidth != strokeWidth;
  }
}

class _CodeSymbolsPainter extends CustomPainter {
  final List<_Symbol> symbols;
  final double t; // ✅ قيمة الحركة 0..1

  _CodeSymbolsPainter({required this.symbols, this.t = 0.0});

  @override
  void paint(Canvas canvas, Size size) {
    for (int i = 0; i < symbols.length; i++) {
      final s = symbols[i];

      // ✅ حركة بسيطة: كل رمز يتحرك شوي لفوك/جوه
      final wobbleY = (i.isEven ? 1 : -1) * (6.0 * (t - 0.5));
      final wobbleX = (i.isOdd ? 1 : -1) * (4.0 * (t - 0.5));

      final tp = TextPainter(
        text: TextSpan(
          text: s.text,
          style: GoogleFonts.fredoka(
            fontSize: 34,
            fontWeight: FontWeight.w700,
            color: s.color.withOpacity(0.08),
          ),
        ),
        textDirection: TextDirection.ltr,
      )..layout();

      final x = size.width * s.x - (tp.width / 2) + wobbleX;
      final y = size.height * s.y - (tp.height / 2) + wobbleY;

      canvas.save();
      canvas.translate(x, y);
      canvas.rotate(-0.25);
      tp.paint(canvas, Offset.zero);
      canvas.restore();
    }
  }

  @override
  bool shouldRepaint(covariant _CodeSymbolsPainter oldDelegate) {
    return oldDelegate.t != t || oldDelegate.symbols != symbols;
  }
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

class _PointsChip extends StatelessWidget {
  final int points;
  const _PointsChip({required this.points});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 9),
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
      child: Row(
        children: [
          Text(
            points.toString(),
            style: GoogleFonts.cairo(
              fontWeight: FontWeight.w800,
              fontSize: 14,
              color: Colors.black87,
            ),
          ),
          const SizedBox(width: 8),
          const Icon(Icons.stars_rounded, size: 18, color: Color(0xFF8E5CCB)),
        ],
      ),
    );
  }
}
class _PlayfulBgPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    // Gradient خلفية خفيفة
    final rect = Offset.zero & size;
    final bgPaint = Paint()
      ..shader = const LinearGradient(
        begin: Alignment.topCenter,
        end: Alignment.bottomCenter,
        colors: [
          Color(0xFFF7F3FF), // بنفسجي فاتح
          Color(0xFFF2FAFF), // ازرق فاتح
          Color(0xFFFFFFFF),
        ],
      ).createShader(rect);
    canvas.drawRect(rect, bgPaint);

    // دوائر لطيفة (فقاعات)
    void bubble(double x, double y, double r, Color c, double o) {
      final p = Paint()..color = c.withOpacity(o);
      canvas.drawCircle(Offset(size.width * x, size.height * y), r, p);
    }

    bubble(0.15, 0.18, 46, const Color(0xFF8E5CCB), 0.08);
    bubble(0.85, 0.25, 60, const Color(0xFF14A1FF), 0.07);
    bubble(0.25, 0.55, 70, const Color(0xFFFF6FB5), 0.06);
    bubble(0.78, 0.62, 50, const Color(0xFFFFE600), 0.05);
    bubble(0.12, 0.82, 64, const Color(0xFF2ECC71), 0.05);

    // خطوط خفيفة مثل ورق دفاتر (اختياري لطيف)
    final line = Paint()
      ..color = const Color(0xFF000000).withOpacity(0.03)
      ..strokeWidth = 1;
    for (double y = 0; y < size.height; y += 42) {
      canvas.drawLine(Offset(0, y), Offset(size.width, y), line);
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

enum _NodeType { level, topic, quiz }

class _MapNode {
  final String id;
  final _NodeType type;

  final String title;
  final String? subtitle;

  final double x;
  final double y;
  final bool locked;
  final Color gradientA;
  final Color gradientB;
  final VoidCallback onTap;

  const _MapNode({
    required this.id,
    required this.type,
    required this.title,
    this.subtitle,
    required this.x,
    required this.y,
    required this.locked,
    required this.gradientA,
    required this.gradientB,
    required this.onTap,
  });
}

class _CreativeBottomNav extends StatelessWidget {
  final int currentIndex;
  final ValueChanged<int> onTap;

  const _CreativeBottomNav({
    required this.currentIndex,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    const bg = Colors.white;
    const active = Color(0xFF8E5CCB);
    const inactive = Color(0xFF7A7A7A);

    final items = const [
      _NavItem(icon: Icons.bookmark_border, label: 'القاموس', index: 2),
      _NavItem(icon: Icons.home_rounded, label: 'الرئيسية', index: 1),
      _NavItem(icon: Icons.description_outlined, label: 'الاختبارات', index: 0),
      _NavItem(icon: Icons.person_outline, label: 'بروفايل', index: 3),
    ];

    return Container(
      padding: const EdgeInsets.fromLTRB(18, 10, 18, 16),
      decoration: BoxDecoration(
        color: Colors.transparent,
        boxShadow: [
          BoxShadow(
            blurRadius: 26,
            offset: const Offset(0, -10),
            color: Colors.black.withOpacity(0.06),
          ),
        ],
      ),
      child: Container(
        height: 70,
        decoration: BoxDecoration(
          color: bg,
          borderRadius: BorderRadius.circular(22),
          boxShadow: [
            BoxShadow(
              blurRadius: 18,
              offset: const Offset(0, 10),
              color: Colors.black.withOpacity(0.08),
            ),
          ],
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: List.generate(items.length, (i) {
            final item = items[i];
            final isActive = currentIndex == item.index;

            return GestureDetector(
              onTap: () => onTap(item.index),
              behavior: HitTestBehavior.opaque,
              child: SizedBox(
                width: 70,
                height: 70,
                child: Stack(
                  alignment: Alignment.center,
                  children: [
                    AnimatedContainer(
                      duration: const Duration(milliseconds: 240),
                      width: isActive ? 42 : 0,
                      height: isActive ? 42 : 0,
                      decoration: const BoxDecoration(
                        color: Color(0xFFEEE7F7),
                        shape: BoxShape.circle,
                      ),
                    ),
                    Icon(
                      item.icon,
                      size: 26,
                      color: isActive ? active : inactive,
                    ),
                    Positioned(
                      bottom: 10,
                      child: AnimatedContainer(
                        duration: const Duration(milliseconds: 240),
                        width: isActive ? 26 : 0,
                        height: 4,
                        decoration: BoxDecoration(
                          color: isActive ? active : Colors.transparent,
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            );
          }),
        ),
      ),
    );
  }
}

class _NavItem {
  final IconData icon;
  final String label;
  final int index;
  const _NavItem({required this.icon, required this.label, required this.index});
}

class _ComingSoonPage extends StatelessWidget {
  final String title;
  const _ComingSoonPage({required this.title});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Text(
        title,
        style: GoogleFonts.cairo(fontSize: 20, fontWeight: FontWeight.w700),
      ),
    );
  }
}


