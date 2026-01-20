import 'package:cloud_firestore/cloud_firestore.dart';

class AuthService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  /// إنشاء حساب جديد و تخزينه بفايرستور
  Future<void> signUp({
    required String name,
    required String password,
    required int age,
  }) async {
    try {
      await _firestore.collection('users').add({
        'name': name,
        'password': password,
        'age': age,
        'createdAt': DateTime.now(),
      });
    } catch (e) {
      throw Exception('خطاء أثناء إنشاء الحساب: $e');
    }
  }

  /// تسجيل الدخول (بس نفحص اذا موجود بالسجلات)
  Future<bool> login({
    required String name,
    required String password,
  }) async {
    try {
      final snapshot = await _firestore
          .collection('users')
          .where('name', isEqualTo: name)
          .where('password', isEqualTo: password)
          .get();

      if (snapshot.docs.isNotEmpty) {
        // موجود بالـ DB
        return true;
      } else {
        // مَكُو هيج اسم/باسورد
        return false;
      }
    } catch (e) {
      throw Exception('خطاء أثناء تسجيل الدخول: $e');
    }
  }
}
