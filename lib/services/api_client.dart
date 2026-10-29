import 'dart:convert';

import 'package:http/http.dart' as http;

/// Custom exception thrown by ApiClient when network or HTTP error occurs.
class ApiException implements Exception {
  final int statusCode;
  final String message;
  final dynamic data;

  const ApiException({
    required this.statusCode,
    required this.message,
    this.data,
  });

  @override
  String toString() => 'ApiException($statusCode): $message';
}

/// Centralized HTTP client managing baseUrl, token header injection,
/// timeouts, and error handling.
class ApiClient {
  static final ApiClient instance = ApiClient._internal();
  factory ApiClient() => instance;
  ApiClient._internal();

  /// Production base URL deployed on Render.
  static const String productionBaseUrl =
      'https://campusflow-nq50.onrender.com';

  /// Default timeout for HTTP requests (30s to allow for Render service cold starts).
  static const Duration requestTimeout = Duration(seconds: 30);

  /// Default API base URL pointing to the deployed Render service everywhere.
  /// Can be overridden at compile-time via `--dart-define=API_BASE_URL=url`.
  static String get defaultBaseUrl {
    const fromEnv = String.fromEnvironment('API_BASE_URL');
    if (fromEnv.isNotEmpty) return fromEnv;
    return productionBaseUrl;
  }

  String _baseUrl = defaultBaseUrl;
  String? _authToken;

  String get baseUrl => _baseUrl;
  String? get authToken => _authToken;

  void setBaseUrl(String url) {
    _baseUrl = url.endsWith('/') ? url.substring(0, url.length - 1) : url;
  }

  void setAuthToken(String? token) {
    _authToken = token;
  }

  Map<String, String> _buildHeaders([Map<String, String>? extra]) {
    final headers = <String, String>{
      'Content-Type': 'application/json',
      'Accept': 'application/json',
    };
    if (_authToken != null && _authToken!.isNotEmpty) {
      headers['Authorization'] = 'Bearer $_authToken';
    }
    if (extra != null) {
      headers.addAll(extra);
    }
    return headers;
  }

  Uri _buildUri(String path, [Map<String, dynamic>? queryParams]) {
    final cleanPath = path.startsWith('/') ? path : '/$path';
    final fullUrl = '$_baseUrl$cleanPath';
    final uri = Uri.parse(fullUrl);

    if (queryParams != null && queryParams.isNotEmpty) {
      final stringParams = queryParams.map(
        (key, value) => MapEntry(key, value.toString()),
      );
      return uri.replace(queryParameters: stringParams);
    }
    return uri;
  }

  /// Sends a GET request
  Future<dynamic> get(String path, {Map<String, dynamic>? queryParams}) async {
    try {
      final uri = _buildUri(path, queryParams);
      final response = await http
          .get(uri, headers: _buildHeaders())
          .timeout(requestTimeout);
      return _handleResponse(response);
    } catch (e) {
      _handleError(e);
    }
  }

  /// Sends a POST request
  Future<dynamic> post(String path, {dynamic body}) async {
    try {
      final uri = _buildUri(path);
      final encodedBody = body != null ? jsonEncode(body) : null;
      final response = await http
          .post(uri, headers: _buildHeaders(), body: encodedBody)
          .timeout(requestTimeout);
      return _handleResponse(response);
    } catch (e) {
      _handleError(e);
    }
  }

  /// Sends a PUT request
  Future<dynamic> put(String path, {dynamic body}) async {
    try {
      final uri = _buildUri(path);
      final encodedBody = body != null ? jsonEncode(body) : null;
      final response = await http
          .put(uri, headers: _buildHeaders(), body: encodedBody)
          .timeout(requestTimeout);
      return _handleResponse(response);
    } catch (e) {
      _handleError(e);
    }
  }

  /// Sends a PATCH request
  Future<dynamic> patch(String path, {dynamic body}) async {
    try {
      final uri = _buildUri(path);
      final encodedBody = body != null ? jsonEncode(body) : null;
      final response = await http
          .patch(uri, headers: _buildHeaders(), body: encodedBody)
          .timeout(requestTimeout);
      return _handleResponse(response);
    } catch (e) {
      _handleError(e);
    }
  }

  /// Sends a DELETE request
  Future<dynamic> delete(String path) async {
    try {
      final uri = _buildUri(path);
      final response = await http
          .delete(uri, headers: _buildHeaders())
          .timeout(requestTimeout);
      return _handleResponse(response);
    } catch (e) {
      _handleError(e);
    }
  }

  dynamic _handleResponse(http.Response response) {
    dynamic decoded;
    if (response.body.isNotEmpty) {
      try {
        decoded = jsonDecode(response.body);
      } catch (_) {
        decoded = response.body;
      }
    }

    if (response.statusCode >= 200 && response.statusCode < 300) {
      return decoded;
    }

    String message = 'Request failed with status ${response.statusCode}';
    if (decoded is Map && decoded['message'] != null) {
      message = decoded['message'].toString();
    }

    throw ApiException(
      statusCode: response.statusCode,
      message: message,
      data: decoded,
    );
  }

  Never _handleError(dynamic error) {
    if (error is ApiException) {
      throw error;
    }
    throw ApiException(
      statusCode: 0,
      message: 'Unable to connect to server. Check your network connection.',
    );
  }
}
