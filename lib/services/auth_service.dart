import '../models/user.dart';
import 'api_client.dart';

class AuthService {
  final ApiClient _api;

  AuthService({ApiClient? api}) : _api = api ?? ApiClient.instance;

  /// Register a new account.
  /// Returns a map with user, token (if provided), and backend message.
  Future<Map<String, dynamic>> signup({
    required String name,
    required String email,
    required String password,
  }) async {
    final response = await _api.post('/auth/signup', body: {
      'name': name.trim(),
      'email': email.trim(),
      'password': password,
    });

    final user = User.fromJson(response['user'] as Map<String, dynamic>);
    final token = response['token']?.toString();
    final message = response['message']?.toString() ?? 'Account created';

    if (token != null) {
      _api.setAuthToken(token);
    }

    return {
      'user': user,
      'token': token,
      'message': message,
    };
  }

  /// Log in with email and password.
  /// Returns authenticated user and JWT token.
  Future<Map<String, dynamic>> login({
    required String email,
    required String password,
  }) async {
    final response = await _api.post('/auth/login', body: {
      'email': email.trim(),
      'password': password,
    });

    final token = response['token']?.toString() ?? '';
    final user = User.fromJson(response['user'] as Map<String, dynamic>);

    _api.setAuthToken(token);

    return {
      'user': user,
      'token': token,
    };
  }

  /// Fetch the current user profile from the server.
  Future<User> getMe() async {
    final response = await _api.get('/auth/me');
    return User.fromJson(response['user'] as Map<String, dynamic>);
  }

  /// Update user profile details.
  Future<User> updateMe({String? name, String? email}) async {
    final body = <String, dynamic>{};
    if (name != null) body['name'] = name.trim();
    if (email != null) body['email'] = email.trim();

    final response = await _api.put('/auth/me', body: body);
    return User.fromJson(response['user'] as Map<String, dynamic>);
  }

  /// Log out locally by clearing the active token.
  void logout() {
    _api.setAuthToken(null);
  }
}
