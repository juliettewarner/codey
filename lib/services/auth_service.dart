import 'package:cloud_firestore/cloud_firestore.dart';

class AuthService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // =========================
  // إنشاء حساب (يسمح بتكرار الاسم)
  // =========================
  Future<String> signUp({
    required String name,
    required String password,
    required int age,
  }) async {
    // ❌ شلنا منع تكرار الاسم

    final docRef = await _firestore.collection('users').add({
      'name': name,          // ✅ يتكرر عادي
      'password': password,
      'age': age,
      'points': 0,
      'level': 0,
      'createdAt': FieldValue.serverTimestamp(),
      'avatarId': '',
      'rewards': {
        'lv0_q1': false,
        'lv0_ex1': false,
        'lv1_q1': false,
        'lv1_ex1': false,
      }
    });

    return docRef.id; // ✅ ID مختلف لكل مستخدم
  }

  // =========================
  // تسجيل دخول (اسم + باسورد)
  // =========================
  Future<String?> login({
    required String name,
    required String password,
  }) async {
    final q = await _firestore
        .collection('users')
        .where('name', isEqualTo: name)
        .where('password', isEqualTo: password)
        .limit(1)
        .get();

    if (q.docs.isEmpty) return null;
    return q.docs.first.id;
  }

  // =========================
  // ستريم بيانات المستخدم
  // =========================
  Stream<DocumentSnapshot<Map<String, dynamic>>> userStream({
    required String userId,
  }) {
    return _firestore.collection('users').doc(userId).snapshots();
  }

  // =========================
  // تحديث بيانات المستخدم
  // =========================
  Future<void> updateUser({
    required String userId,
    required Map<String, dynamic> data,
  }) async {
    final docRef = _firestore.collection('users').doc(userId);
    await docRef.set(data, SetOptions(merge: true));
  }

  // =========================
  // حساب المستوى
  // =========================
  int _calcLevel(int points) {
    if (points >= 15) return 3;
    if (points >= 10) return 2;
    if (points >= 5) return 1;
    return 0;
  }

  // =========================
  // نقاط مرة وحدة فقط
  // =========================
  Future<bool> awardPointsOnce({
    required String userId,
    required String rewardKey,
    required int points,
  }) async {
    final docRef = _firestore.collection('users').doc(userId);

    return _firestore.runTransaction<bool>((tx) async {
      final snap = await tx.get(docRef);
      if (!snap.exists) throw Exception('User not found');

      final data = snap.data()!;
      final rewards = Map<String, dynamic>.from(data['rewards'] ?? {});
      if (rewards[rewardKey] == true) return false;

      final currentPoints = (data['points'] ?? 0) as int;
      final newPoints = currentPoints + points;

      rewards[rewardKey] = true;

      tx.update(docRef, {
        'points': newPoints,
        'level': _calcLevel(newPoints),
        'rewards': rewards,
      });

      return true;
    });
  }
}
