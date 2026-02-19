import 'package:shared_preferences/shared_preferences.dart';

class SessionService {
  static const String _kUserId = 'userId';
  static const String _kUserName = 'userName';

  Future<void> saveSession({
    required String userId,
    required String userName,
  }) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_kUserId, userId);
    await prefs.setString(_kUserName, userName);
    await prefs.reload();
  }

  Future<SessionData?> getSession() async {
    final prefs = await SharedPreferences.getInstance();
    final userId = prefs.getString(_kUserId);
    final userName = prefs.getString(_kUserName);

    if (userId == null || userId.trim().isEmpty) return null;

    return SessionData(
      userId: userId.trim(),
      userName: (userName ?? '').trim(),
    );
  }

  Future<void> clearSession() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_kUserId);
    await prefs.remove(_kUserName);
  }
}

class SessionData {
  final String userId;
  final String userName;

  const SessionData({
    required this.userId,
    required this.userName,
  });
}
