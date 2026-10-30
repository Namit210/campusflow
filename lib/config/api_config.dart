import 'package:flutter/foundation.dart';

/// Central place for backend settings.
///
/// Run against the real backend with:
///   flutter run -d chrome --dart-define=USE_API=true --dart-define=API_URL=https://your-app.onrender.com
///
/// Without these flags the app runs in demo mode (local JSON + demo login).
class ApiConfig {
  ApiConfig._();

  static const bool useApi = bool.fromEnvironment('USE_API');

  static const String _rawUrl =
      String.fromEnvironment('API_URL', defaultValue: 'http://localhost:5000');

  /// Base URL. The Android emulator reaches your computer at 10.0.2.2.
  static String get baseUrl {
    var url = _rawUrl;
    if (!kIsWeb && defaultTargetPlatform == TargetPlatform.android) {
      url = url
          .replaceFirst('localhost', '10.0.2.2')
          .replaceFirst('127.0.0.1', '10.0.2.2');
    }
    return url.endsWith('/') ? url.substring(0, url.length - 1) : url;
  }

  // ---- Endpoint paths: change these if your backend uses different routes
  // (see backend/openapi.yaml). ----
  static const String loginPath = '/api/auth/login';
  static const String signupPath = '/api/auth/signup';
  static const String programsPath = '/api/programs';
  static const String registrationsPath = '/api/registrations';
  static const String feedbackPath = '/api/feedback';

  /// Render's free plan can take up to a minute to wake up.
  static const Duration timeout = Duration(seconds: 45);
}
