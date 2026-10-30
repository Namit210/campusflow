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

/// Small wrapper around `http` that adds JSON headers, the login token,
/// a timeout and friendly error messages.
class ApiClient {
  final String baseUrl;
  final http.Client _http;
  String? token;

  ApiClient({String? baseUrl, http.Client? client})
      : baseUrl = baseUrl ?? ApiConfig.baseUrl,
        _http = client ?? http.Client();

  Uri _uri(String path) => Uri.parse('$baseUrl$path');

  Map<String, String> get _headers => {
        'Content-Type': 'application/json',
        'Accept': 'application/json',
        if (token != null) 'Authorization': 'Bearer $token',
      };

  Future<dynamic> get(String path) =>
      _send(() => _http.get(_uri(path), headers: _headers));

  Future<dynamic> post(String path, Map<String, dynamic> body) => _send(
      () => _http.post(_uri(path), headers: _headers, body: jsonEncode(body)));

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
