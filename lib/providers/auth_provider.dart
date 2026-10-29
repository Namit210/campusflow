import 'package:flutter/material.dart';

import '../models/user.dart';
import '../services/api_client.dart';
import '../services/auth_service.dart';

class AuthProvider extends ChangeNotifier {
  final AuthService _authService;

  User? _currentUser;
  String? _token;
  bool _isLoading = false;
  String? _error;

  AuthProvider({AuthService? authService})
      : _authService = authService ?? AuthService();

  User? get user => _currentUser;
  String? get token => _token;
  bool get isAuthenticated => _token != null && _currentUser != null;
  bool get isLoading => _isLoading;
  String? get error => _error;

  void clearError() {
    _error = null;
    notifyListeners();
  }

  /// Authenticate with email & password.
  Future<bool> login({
    required String email,
    required String password,
  }) async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      final result = await _authService.login(email: email, password: password);
      _currentUser = result['user'] as User;
      _token = result['token'] as String;
      _isLoading = false;
      notifyListeners();
      return true;
    } on ApiException catch (e) {
      _error = e.message;
      _isLoading = false;
      notifyListeners();
      return false;
    } catch (_) {
      _error = 'Unable to connect to server. Please check your network.';
      _isLoading = false;
      notifyListeners();
      return false;
    }
  }

  /// Create a new account with name, email, and password.
  Future<bool> signup({
    required String name,
    required String email,
    required String password,
  }) async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      final result = await _authService.signup(
        name: name,
        email: email,
        password: password,
      );
      _currentUser = result['user'] as User;
      _token = result['token'] as String?;
      _isLoading = false;
      notifyListeners();
      return true;
    } on ApiException catch (e) {
      _error = e.message;
      _isLoading = false;
      notifyListeners();
      return false;
    } catch (_) {
      _error = 'Unable to connect to server. Please check your network.';
      _isLoading = false;
      notifyListeners();
      return false;
    }
  }

  /// Fetch user profile from the server using the current session.
  Future<void> loadProfile() async {
    if (_token == null) return;
    try {
      _currentUser = await _authService.getMe();
      notifyListeners();
    } catch (_) {
      // Session may have expired
    }
  }

  /// Update the current user profile.
  Future<bool> updateProfile({String? name, String? email}) async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      _currentUser = await _authService.updateMe(name: name, email: email);
      _isLoading = false;
      notifyListeners();
      return true;
    } on ApiException catch (e) {
      _error = e.message;
      _isLoading = false;
      notifyListeners();
      return false;
    } catch (_) {
      _error = 'Failed to update profile';
      _isLoading = false;
      notifyListeners();
      return false;
    }
  }

  /// Log out and clear stored session.
  void logout() {
    _authService.logout();
    _currentUser = null;
    _token = null;
    _error = null;
    notifyListeners();
  }
}
