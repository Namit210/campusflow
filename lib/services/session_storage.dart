import 'package:shared_preferences/shared_preferences.dart';

class StoredSession {
  final String? token;
  final String name;
  final String email;
  const StoredSession({this.token, required this.name, required this.email});
}

/// Keeps the user signed in between app launches.
abstract class SessionStorage {
  Future<StoredSession?> read();
  Future<void> save(
      {String? token, required String name, required String email});
  Future<void> clear();
}

/// Used in tests (nothing is written to disk).
class MemorySessionStorage implements SessionStorage {
  StoredSession? _session;

  @override
  Future<StoredSession?> read() async => _session;

  @override
  Future<void> save(
      {String? token, required String name, required String email}) async {
    _session = StoredSession(token: token, name: name, email: email);
  }

  @override
  Future<void> clear() async => _session = null;
}

class SharedPrefsSessionStorage implements SessionStorage {
  static const _tokenKey = 'session_token';
  static const _nameKey = 'session_name';
  static const _emailKey = 'session_email';

  @override
  Future<StoredSession?> read() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final email = prefs.getString(_emailKey);
      if (email == null) return null;
      return StoredSession(
        token: prefs.getString(_tokenKey),
        name: prefs.getString(_nameKey) ?? 'Learner',
        email: email,
      );
    } catch (_) {
      return null;
    }
  }

  @override
  Future<void> save(
      {String? token, required String name, required String email}) async {
    final prefs = await SharedPreferences.getInstance();
    if (token != null) {
      await prefs.setString(_tokenKey, token);
    } else {
      await prefs.remove(_tokenKey);
    }
    await prefs.setString(_nameKey, name);
    await prefs.setString(_emailKey, email);
  }

  @override
  Future<void> clear() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_tokenKey);
    await prefs.remove(_nameKey);
    await prefs.remove(_emailKey);
  }
}
