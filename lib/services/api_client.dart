import 'dart:async';
import 'dart:convert';

import 'package:http/http.dart' as http;

import '../config/api_config.dart';

class ApiException implements Exception {
  final String message;
  final int? statusCode;
  const ApiException(this.message, [this.statusCode]);

  @override
  String toString() => message;
}

/// Small wrapper around `http`: JSON headers, login token, timeout and
/// friendly error messages. Supports GET, POST, PATCH and DELETE.
class ApiClient {
  /// Default backend address (the deployed Render service).
  static String get defaultBaseUrl => ApiConfig.baseUrl;

  /// Shared instance used by services and providers.
  static final ApiClient instance = ApiClient();

  String _baseUrl;
  final http.Client _http;
  /// Login token sent with every request.
  String? token;

  ApiClient({String? baseUrl, http.Client? client})
      : _baseUrl = _trimSlash(baseUrl ?? ApiConfig.baseUrl),
        _http = client ?? http.Client();

  static String _trimSlash(String url) =>
      url.endsWith('/') ? url.substring(0, url.length - 1) : url;

  String get baseUrl => _baseUrl;
  void setBaseUrl(String url) => _baseUrl = _trimSlash(url);

  String? get authToken => token;
  void setAuthToken(String? value) => token = value;

  Uri _uri(String path) {
    var p = path.startsWith('/') ? path : '/$path';
    final prefix = ApiConfig.apiPrefix;
    if (prefix.isNotEmpty && !p.startsWith(prefix)) p = '$prefix$p';
    return Uri.parse('$_baseUrl$p');
  }

  Map<String, String> get _headers => {
        'Content-Type': 'application/json',
        'Accept': 'application/json',
        if (token != null) 'Authorization': 'Bearer $token',
      };

  Future<dynamic> get(String path) =>
      _send(() => _http.get(_uri(path), headers: _headers));

  Future<dynamic> post(String path, {Object? body}) => _send(() => _http.post(
        _uri(path),
        headers: _headers,
        body: body == null ? null : jsonEncode(body),
      ));

  Future<dynamic> patch(String path, {Object? body}) => _send(() => _http.patch(
        _uri(path),
        headers: _headers,
        body: body == null ? null : jsonEncode(body),
      ));

  Future<dynamic> delete(String path) =>
      _send(() => _http.delete(_uri(path), headers: _headers));

  Future<dynamic> _send(Future<http.Response> Function() request) async {
    try {
      final res = await request().timeout(ApiConfig.timeout);
      final dynamic decoded = res.body.isEmpty ? null : jsonDecode(res.body);
      if (res.statusCode >= 200 && res.statusCode < 300) return decoded;
      throw ApiException(
        _messageFrom(decoded) ?? 'Request failed (${res.statusCode}).',
        res.statusCode,
      );
    } on ApiException {
      rethrow;
    } on TimeoutException {
      throw const ApiException(
          'The server took too long to respond. Please try again.');
    } on http.ClientException {
      throw const ApiException(
          'Cannot reach the server. Check your internet connection.');
    } on FormatException {
      throw const ApiException('The server sent an unexpected response.');
    }
  }

  static String? _messageFrom(dynamic body) {
    if (body is Map) {
      final m = body['message'] ?? body['error'] ?? body['msg'];
      if (m != null) return m.toString();
    }
    return null;
  }
}
