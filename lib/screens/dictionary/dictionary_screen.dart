import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../services/dictionary_db.dart';

class DictionaryScreen extends StatefulWidget {
  const DictionaryScreen({super.key});

  @override
  State<DictionaryScreen> createState() => _DictionaryScreenState();
}

class _DictionaryScreenState extends State<DictionaryScreen> {
  // Palette (نفس ستايلج)
  static const cOffWhite = Color(0xFFF2EFE6);
  static const cPurple = Color(0xFF8E5CCB);
  static const cBlue = Color(0xFF14A1FF);
  static const cPink = Color(0xFFFF6FB5);
  static const cYellow = Color(0xFFFFE600);
  static const cGreen = Color(0xFF2ECC71);

  final TextEditingController _searchController = TextEditingController();

  bool _loading = true;

  // نتائج SQLite
  List<Map<String, dynamic>> _items = [];

  // المصطلح المختار
  Map<String, dynamic>? _selected;

  // ✅ اقتراحات أثناء الكتابة
  List<String> _suggestions = [];

  @override
  void initState() {
    super.initState();
    _loadInitial();
  }

  Future<void> _loadInitial() async {
    setState(() => _loading = true);
    final list = await DictionaryDB.getAllTerms();
    if (!mounted) return;

    setState(() {
      _items = list;
      _selected = list.isNotEmpty ? list.first : null;
      _loading = false;
    });
  }

  Future<void> _searchSentence(String text) async {
    setState(() => _loading = true);

    final list = await DictionaryDB.searchTerms(text);
    // ✅ اقتراحات
    final sugg = await DictionaryDB.suggestTerms(text);

    if (!mounted) return;

    setState(() {
      _items = list;
      _suggestions = sugg;

      // إذا المختار اختفى من النتائج نختار أول نتيجة
      if (_selected == null || !_items.any((e) => e['id'] == _selected!['id'])) {
        _selected = _items.isNotEmpty ? _items.first : null;
      }

      _loading = false;
    });
  }

  Future<void> _pickSuggestion(String term) async {
    _searchController.text = term;
    _searchController.selection = TextSelection.fromPosition(
      TextPosition(offset: term.length),
    );
    await _searchSentence(term);
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  String get _term => (_selected?['term'] ?? '').toString();
  String get _meaning => (_selected?['meaning'] ?? '').toString();
  String get _example => (_selected?['example'] ?? '').toString();
  String get _explanation => (_selected?['explanation'] ?? '').toString();

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        backgroundColor: Colors.white,
        body: Stack(
          children: [
            const Positioned.fill(child: ColoredBox(color: Colors.white)),

            // ✅ خلفية رموز برمجية
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
              child: SingleChildScrollView(
                physics: const BouncingScrollPhysics(),
                padding: const EdgeInsets.fromLTRB(16, 10, 16, 24),
                child: Column(
                  children: [
                    // عنوان
                    Row(
                      children: [
                        Text(
                          'القاموس',
                          style: GoogleFonts.fredoka(
                            fontSize: 20,
                            fontWeight: FontWeight.w800,
                            letterSpacing: 0.5,
                            color: Colors.black87,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 14),

                    // ✅ شريط البحث
                    _searchBar(),

                    // ✅ اقتراحات تحت البحث
                    if (_suggestions.isNotEmpty) ...[
                      const SizedBox(height: 10),
                      Align(
                        alignment: Alignment.centerRight,
                        child: Wrap(
                          spacing: 8,
                          runSpacing: 8,
                          children: _suggestions.map((t) {
                            return InkWell(
                              borderRadius: BorderRadius.circular(999),
                              onTap: () => _pickSuggestion(t),
                              child: Container(
                                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                                decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.circular(999),
                                  border: Border.all(color: Colors.black.withOpacity(0.12)),
                                  boxShadow: [
                                    BoxShadow(
                                      blurRadius: 12,
                                      offset: const Offset(0, 8),
                                      color: Colors.black.withOpacity(0.05),
                                    ),
                                  ],
                                ),
                                child: Text(
                                  t,
                                  style: GoogleFonts.cairo(
                                    fontSize: 13.5,
                                    fontWeight: FontWeight.w900,
                                    color: Colors.black87,
                                  ),
                                ),
                              ),
                            );
                          }).toList(),
                        ),
                      ),
                    ],

                    const SizedBox(height: 12),

                    // Loading
                    if (_loading)
                      const LinearProgressIndicator(minHeight: 4)
                    else
                      const SizedBox(height: 4),

                    const SizedBox(height: 12),

                    // ✅ كلمات جاهزة (Chips) - فقط 4
                    _chipsRow(),
                    const SizedBox(height: 14),

                    // ✅ العنوان المختار
                    if (_selected != null)
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
                        decoration: BoxDecoration(
                          color: cBlue.withOpacity(0.12),
                          borderRadius: BorderRadius.circular(18),
                          border: Border.all(color: cBlue.withOpacity(0.35)),
                        ),
                        child: Text(
                          _term,
                          style: GoogleFonts.cairo(
                            fontSize: 16,
                            fontWeight: FontWeight.w900,
                            color: Colors.black87,
                          ),
                        ),
                      ),

                    if (_selected != null) const SizedBox(height: 12),

                    // ✅ كارد: التعريف
                    _bigCard(
                      title: 'التعريف :',
                      emoji: '📝',
                      child: Text(
                        _selected == null ? '—' : _meaning,
                        textAlign: TextAlign.center,
                        style: GoogleFonts.cairo(
                          fontSize: 17.5,
                          fontWeight: FontWeight.w900,
                          height: 1.7,
                          color: Colors.black87,
                        ),
                      ),
                    ),

                    const SizedBox(height: 12),

                    // ✅ كارد: المثال
                    _bigCard(
                      title: 'المثال :',
                      emoji: '💻',
                      child: _selected == null ? _emptyText() : _codeFromExample(_example),
                    ),

                    const SizedBox(height: 12),

                    // ✅ كارد: التوضيح
                    _bigCard(
                      title: 'التوضيح :',
                      emoji: '✨',
                      child: Text(
                        _selected == null ? '—' : (_explanation.trim().isEmpty ? '—' : _explanation),
                        textAlign: TextAlign.center,
                        style: GoogleFonts.cairo(
                          fontSize: 16,
                          fontWeight: FontWeight.w800,
                          height: 1.7,
                          color: Colors.black87,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // =========================
  // شريط البحث
  // =========================
  Widget _searchBar() {
    return Container(
      height: 54,
      padding: const EdgeInsets.symmetric(horizontal: 14),
      decoration: BoxDecoration(
        color: Colors.white,
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
        children: [
          const Icon(Icons.search_rounded, color: Colors.black45),
          const SizedBox(width: 10),
          Expanded(
            child: TextField(
              controller: _searchController,
              style: GoogleFonts.cairo(fontSize: 15.5, fontWeight: FontWeight.w800),
              decoration: InputDecoration(
                hintText: 'ابحث بجملة أو كلمة...',
                hintStyle: GoogleFonts.cairo(
                  fontSize: 14.5,
                  fontWeight: FontWeight.w800,
                  color: Colors.black38,
                ),
                border: InputBorder.none,
              ),
              onChanged: _searchSentence,
            ),
          ),
          ValueListenableBuilder<TextEditingValue>(
            valueListenable: _searchController,
            builder: (context, v, _) {
              if (v.text.isEmpty) return const SizedBox.shrink();
              return IconButton(
                onPressed: () {
                  _searchController.clear();
                  _suggestions = [];
                  _searchSentence('');
                },
                icon: const Icon(Icons.close_rounded),
                color: Colors.black45,
              );
            },
          ),
        ],
      ),
    );
  }

  // =========================
  // Chips (فقط 4)
  // =========================
  Widget _chipsRow() {
    if (!_loading && _items.isEmpty) {
      return Center(
        child: Text(
          'لا توجد نتائج.',
          style: GoogleFonts.cairo(
            fontSize: 15,
            fontWeight: FontWeight.w800,
            color: Colors.black54,
          ),
        ),
      );
    }

    final visibleItems = _items.take(3).toList();

    return Wrap(
      alignment: WrapAlignment.center,
      spacing: 10,
      runSpacing: 10,
      children: visibleItems.map((item) {
        final selected = _selected?['id'] == item['id'];

        return InkWell(
          borderRadius: BorderRadius.circular(999),
          onTap: () => setState(() => _selected = item),
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 180),
            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 9),
            decoration: BoxDecoration(
              color: selected ? cPink.withOpacity(0.18) : Colors.white,
              borderRadius: BorderRadius.circular(999),
              border: Border.all(
                color: selected ? cPink.withOpacity(0.70) : Colors.black.withOpacity(0.12),
                width: selected ? 2.0 : 1.0,
              ),
              boxShadow: [
                BoxShadow(
                  blurRadius: 14,
                  offset: const Offset(0, 10),
                  color: Colors.black.withOpacity(0.07),
                ),
              ],
            ),
            child: Text(
              item['term'].toString(),
              style: GoogleFonts.cairo(
                fontSize: 13.5,
                fontWeight: FontWeight.w900,
                color: Colors.black87,
              ),
            ),
          ),
        );
      }).toList(),
    );
  }

  // =========================
  // كارد كبير
  // =========================
  Widget _bigCard({required String title, required String emoji, required Widget child}) {
    return Container(
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
          Row(
            children: [
              Expanded(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    Text(
                      title,
                      style: GoogleFonts.cairo(
                        fontSize: 18,
                        fontWeight: FontWeight.w900,
                        color: Colors.black87,
                      ),
                    ),
                    const SizedBox(width: 8),
                    Text(emoji, style: const TextStyle(fontSize: 18)),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 14),
          child,
        ],
      ),
    );
  }

  Widget _emptyText() {
    return Text(
      '—',
      style: GoogleFonts.cairo(fontSize: 15, fontWeight: FontWeight.w800, color: Colors.black54),
    );
  }

  // =========================
  // مثال بنفس ستايل الدروس
  // =========================
  Widget _codeFromExample(String example) {
    final t = example.trim();
    if (t.isEmpty) return _emptyText();
    final lines = _parseExampleToLines(t);
    return _CodeBlock(lines: lines);
  }

  List<_CodeLine> _parseExampleToLines(String code) {
    final raw = code
        .replaceAll('\r\n', '\n')
        .split('\n')
        .map((e) => e.trimRight())
        .where((e) => e.trim().isNotEmpty)
        .toList();

    final out = <_CodeLine>[];

    for (final line in raw) {
      final s = line.trim();
      final eq = s.indexOf('=');

      if (eq > 0 && eq < s.length - 1) {
        final left = s.substring(0, eq).trim();
        final right = s.substring(eq + 1).trim();
        out.add(_CodeLine(left: left, middle: '=', right: right));
      } else {
        out.add(_CodeLine(left: s, middle: '', right: ''));
      }
    }
    return out;
  }
}

/* ===============================
   CodeBlock (مثل الدروس) ✅ مصحح
=============================== */

class _CodeBlock extends StatelessWidget {
  final List<_CodeLine> lines;
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
          children: lines.map((l) {
            return Padding(
              padding: const EdgeInsets.only(bottom: 8),
              child: RichText(
                textDirection: TextDirection.ltr,
                text: TextSpan(
                  style: GoogleFonts.fredoka(fontSize: 16, fontWeight: FontWeight.w700),
                  children: [
                    TextSpan(
                      text: l.left,
                      style: const TextStyle(color: Color(0xFF60A5FA)),
                    ),
                    if (l.middle.isNotEmpty) const TextSpan(text: '  '),
                    if (l.middle.isNotEmpty)
                      TextSpan(
                        text: l.middle,
                        style: const TextStyle(color: Color(0xFFE5E7EB)),
                      ),
                    if (l.right.isNotEmpty) const TextSpan(text: '  '),
                    if (l.right.isNotEmpty)
                      TextSpan(
                        text: l.right,
                        style: const TextStyle(color: Color(0xFF34D399)),
                      ),
                  ],
                ),
              ),
            );
          }).toList(),
        ),
      ),
    );
  }
}

class _CodeLine {
  final String left;
  final String middle;
  final String right;
  const _CodeLine({required this.left, required this.middle, required this.right});
}

/* ===============================
   خلفية الرموز
=============================== */

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
  const _Symbol({required this.x, required this.y, required this.text, required this.color});
}
