import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class DictionaryDB {
  static Database? _db;

  static Future<Database> get instance async {
    if (_db != null) return _db!;
    _db = await _open();
    return _db!;
  }

  static const String _dbName = 'codey_dict.db';
  static const int _dbVersion = 3; // ✅ رفعنا النسخة لأننا زِدنا مفردات

  static Future<Database> _open() async {
    final dbPath = await getDatabasesPath();
    final path = join(dbPath, _dbName);

    return openDatabase(
      path,
      version: _dbVersion,
      onCreate: (db, version) async {
        await db.execute('''
          CREATE TABLE dictionary (
            id INTEGER PRIMARY KEY AUTOINCREMENT,
            term TEXT NOT NULL,
            meaning TEXT NOT NULL,
            example TEXT,
            explanation TEXT
          )
        ''');

        await _seedIfEmpty(db);
      },
      onUpgrade: (db, oldVersion, newVersion) async {
        if (oldVersion < 2) {
          await db.execute('ALTER TABLE dictionary ADD COLUMN explanation TEXT');
          await db.execute('UPDATE dictionary SET explanation = "" WHERE explanation IS NULL');
        }

        // ✅ إذا كانت نسخ قديمة، نضمن وجود بيانات (إذا الجدول فارغ)
        await _seedIfEmpty(db);
      },
    );
  }

  // =========================
  // ✅ Seed مرة واحدة (إذا كان الجدول فارغًا)
  // =========================
  static Future<void> _seedIfEmpty(Database db) async {
    final r = await db.rawQuery('SELECT COUNT(*) as c FROM dictionary');
    final count = Sqflite.firstIntValue(r) ?? 0;
    if (count > 0) return;

    final data = <Map<String, Object?>>[
      {
        'term': 'البرمجة',
        'meaning': 'البرمجة هي كتابة أوامر للحاسوب ليُنفِّذ مهامًا محددة.',
        'example': 'print("Hello")',
        'explanation': 'تُستخدم الدالة print لعرض نصٍّ على الشاشة.'
      },
      {
        'term': 'المتغيِّر',
        'meaning': 'المتغيِّر هو اسم يُخزِّن قيمة يمكن تغييرها لاحقًا.',
        'example': 'age = 10',
        'explanation': 'يمكن تغيير قيمة المتغيّر age من 10 إلى 12 عند الحاجة.'
      },
      {
        'term': 'الشرط',
        'meaning': 'الشرط طريقة لاتخاذ قرار: إن تحققَ أمرٌ ما نُنفِّذ شيئًا، وإلا نُنفِّذ شيئًا آخر.',
        'example': 'if age >= 18:',
        'explanation': 'إذا كان العمر 18 أو أكثر، يُنفِّذ البرنامج الأوامر داخل الشرط.'
      },
      {
        'term': 'الحلقات (Loops)',
        'meaning': 'الحلقات تُكرِّر تنفيذ الأوامر عدة مرات بطريقة منظَّمة.',
        'example': 'for i in range(3):',
        'explanation': 'تُكرِّر هذه الحلقة الأوامر ثلاث مرات.'
      },
      {
        'term': 'الإدخال (Input)',
        'meaning': 'الإدخال هو الحصول على قيمة من المستخدم داخل البرنامج.',
        'example': 'name = input()',
        'explanation': 'ينتظر البرنامج المستخدم ليكتب قيمة، ثم يخزّنها في متغيّر.'
      },
      {
        'term': 'الإخراج (Output)',
        'meaning': 'الإخراج هو عرض نتيجة للمستخدم على الشاشة.',
        'example': 'print(name)',
        'explanation': 'بعد تخزين الاسم في متغيّر، نعرضه باستخدام print.'
      },
      {
        'term': 'التعليق (Comment)',
        'meaning': 'التعليق نصٌّ داخل الكود لا يُنفَّذ، لكنه يشرح الكود للمبرمج.',
        'example': '// هذا تعليق',
        'explanation': 'تساعد التعليقات على فهم الكود عند الرجوع إليه.'
      },
      {
        'term': 'الدالة (Function)',
        'meaning': 'الدالة مجموعة أوامر نُعطيها اسمًا لنستخدمها أكثر من مرة.',
        'example': 'def greet():',
        'explanation': 'نكتب الدالة مرة واحدة، ثم نستدعيها عند الحاجة.'
      },
      {
        'term': 'القائمة (List)',
        'meaning': 'القائمة بنية بيانات تُخزِّن عدّة قيم داخل متغيّر واحد.',
        'example': 'nums = [1, 2, 3]',
        'explanation': 'بدل إنشاء متغيّر لكل رقم، نضع القيم في قائمة واحدة.'
      },
      {
        'term': 'النص (String)',
        'meaning': 'النص سلسلة من الحروف داخل علامات اقتباس.',
        'example': 'name = "Maryam"',
        'explanation': 'أي شيء بين علامتي اقتباس يُعدُّ نصًّا.'
      },

      // ✅ مفردات إضافية
      {
        'term': 'النوع (Type)',
        'meaning': 'النوع يحدِّد شكل البيانات مثل: عدد، نص، قائمة.',
        'example': 'type(name)',
        'explanation': 'تُعيد الدالة type نوع القيمة المخزّنة.'
      },
      {
        'term': 'العدد الصحيح (Integer)',
        'meaning': 'العدد الصحيح هو رقم بلا فاصلة عشرية.',
        'example': 'x = 5',
        'explanation': 'القيمة 5 عدد صحيح.'
      },
      {
        'term': 'العدد العشري (Float)',
        'meaning': 'العدد العشري هو رقم يحتوي على فاصلة عشرية.',
        'example': 'x = 3.14',
        'explanation': 'القيمة 3.14 عدد عشري.'
      },
      {
        'term': 'العامل (Operator)',
        'meaning': 'العامل رمز يُستخدم لإجراء عملية مثل الجمع أو المقارنة.',
        'example': 'a + b',
        'explanation': '+ عامل للجمع.'
      },
      {
        'term': 'المقارنة (Comparison)',
        'meaning': 'المقارنة تُستخدم لاختبار علاقة بين قيمتين.',
        'example': 'a == b',
        'explanation': '== تعني: هل القيمتان متساويتان؟'
      },
      {
        'term': 'القيمة المنطقية (Boolean)',
        'meaning': 'قيمة منطقية إمّا True أو False.',
        'example': 'is_ok = True',
        'explanation': 'تُستخدم للتحكم بالشروط.'
      },
      {
        'term': 'طباعة (Print)',
        'meaning': 'طباعة تعني عرض شيء على الشاشة.',
        'example': 'print(123)',
        'explanation': 'تُظهر 123 على الشاشة.'
      },
      {
        'term': 'المعاملات (Parameters)',
        'meaning': 'المعاملات قيم نمرّرها للدالة عند استدعائها.',
        'example': 'def add(a, b):',
        'explanation': 'a و b معاملان للدالة add.'
      },
    ];

    final batch = db.batch();
    for (final row in data) {
      batch.insert('dictionary', row);
    }
    await batch.commit(noResult: true);
  }

  // =========================
  // جلب جميع المصطلحات
  // =========================
  static Future<List<Map<String, dynamic>>> getAllTerms() async {
    final db = await instance;
    return db.query(
      'dictionary',
      columns: ['id', 'term', 'meaning', 'example', 'explanation'],
      orderBy: 'term ASC',
      limit: 500,
    );
  }

  // =========================
  // بحث بالجملة
  // =========================
  static Future<List<Map<String, dynamic>>> searchTerms(String q) async {
    final db = await instance;
    final query = q.trim();
    if (query.isEmpty) return getAllTerms();

    final lower = query.toLowerCase();
    final like = '%$lower%';

    return db.query(
      'dictionary',
      columns: ['id', 'term', 'meaning', 'example', 'explanation'],
      where: '''
        LOWER(term) LIKE ?
        OR LOWER(meaning) LIKE ?
        OR LOWER(COALESCE(example, '')) LIKE ?
        OR LOWER(COALESCE(explanation, '')) LIKE ?
      ''',
      whereArgs: [like, like, like, like],
      orderBy: 'term ASC',
      limit: 200,
    );
  }

  // =========================
  // ✅ اقتراحات أثناء الكتابة (Autocomplete)
  // يرجّع فقط term
  // =========================
  static Future<List<String>> suggestTerms(String q) async {
    final db = await instance;
    final query = q.trim();
    if (query.isEmpty) return [];

    final lower = query.toLowerCase();
    final like = '$lower%'; // يبدأ بـ

    final rows = await db.query(
      'dictionary',
      columns: ['term'],
      where: 'LOWER(term) LIKE ?',
      whereArgs: [like],
      orderBy: 'term ASC',
      limit: 8,
    );

    return rows.map((e) => e['term'].toString()).toList();
  }

  // =========================
  // إضافة مصطلح
  // =========================
  static Future<int> insertTerm({
    required String term,
    required String meaning,
    String? example,
    String? explanation,
  }) async {
    final db = await instance;
    return db.insert('dictionary', {
      'term': term.trim(),
      'meaning': meaning.trim(),
      'example': (example ?? '').trim(),
      'explanation': (explanation ?? '').trim(),
    });
  }

  // حذف قاعدة البيانات (إذا احتجتي)
  static Future<void> resetDatabase() async {
    final dbPath = await getDatabasesPath();
    final path = join(dbPath, _dbName);
    await deleteDatabase(path);
    _db = null;
  }
}
