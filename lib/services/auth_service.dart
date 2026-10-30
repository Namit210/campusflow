import '../config/api_config.dart';
import 'api_client.dart';

class AuthUser {
  final String name;
  final String email;
  const AuthUser({required this.name, required this.email});
}

class AuthResult {
  final AuthUser user;
  final String? token;
  const AuthResult(this.user, this.token);
}

abstract class AuthService {
  Future<AuthResult> login(String email, String password);
  Future<AuthResult> signup(String name, String email, String password);
}

String _nameFromEmail(String email) {
  final local = email.split('@').first;
  if (local.isEmpty) return 'Learner';
  return local[0].toUpperCase() + local.substring(1);
}

/// Demo mode: accepts any valid email and a password of 6+ characters.
class MockAuthService implements AuthService {
  final Duration delay;
  const MockAuthService({this.delay = const Duration(milliseconds: 600)});

  Future<void> _wait() async {
    if (delay > Duration.zero) await Future.delayed(delay);
  }

  @override
  Future<AuthResult> login(String email, String password) async {
    await _wait();
    if (!email.contains('@') || password.length < 6) {
      throw const ApiException('Invalid email or password.');
    }
    return AuthResult(
        AuthUser(name: _nameFromEmail(email), email: email), 'demo-token');
  }

  @override
  Future<AuthResult> signup(String name, String email, String password) async {
    await _wait();
    if (name.trim().isEmpty || !email.contains('@') || password.length < 6) {
      throw const ApiException('Please check your details and try again.');
    }
    return AuthResult(AuthUser(name: name.trim(), email: email), 'demo-token');
  }
}

/// Talks to the Node/Express backend.
class ApiAuthService implements AuthService {
  final ApiClient _client;
  ApiAuthService(this._client);

  @override
  Future<AuthResult> login(String email, String password) async {
    final data = await _client
        .post(ApiConfig.loginPath, {'email': email, 'password': password});
    return _parse(data, email: email);
  }

  @override
  Future<AuthResult> signup(String name, String email, String password) async {
    final data = await _client.post(ApiConfig.signupPath,
        {'name': name, 'email': email, 'password': password});
    final result = _parse(data, email: email, name: name);
    // Some backends return only a message after signup: log in to get a token.
    if (result.token != null) return result;
    return login(email, password);
  }

  Map<String, dynamic> _asMap(dynamic v) =>
      v is Map ? Map<String, dynamic>.from(v) : <String, dynamic>{};

  AuthResult _parse(dynamic data, {required String email, String? name}) {
    final root = _asMap(data);
    final inner = _asMap(root['data']);
    var userMap = _asMap(root['user']);
    if (userMap.isEmpty) userMap = _asMap(inner['user']);
    if (userMap.isEmpty) userMap = inner;

    final token =
        (root['token'] ?? root['accessToken'] ?? inner['token'] ?? inner['accessToken'])
            ?.toString();
    final userEmail = (userMap['email'] ?? root['email'] ?? email).toString();
    var userName =
        (userMap['name'] ?? userMap['fullName'] ?? root['name'] ?? name)
            ?.toString();
    if (userName == null || userName.isEmpty) {
      userName = _nameFromEmail(userEmail);
    }
    return AuthResult(AuthUser(name: userName, email: userEmail), token);
  }
}
