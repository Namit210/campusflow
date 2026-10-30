import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart' show rootBundle;

import '../config/api_config.dart';
import '../models/feedback_entry.dart';
import '../models/program.dart';
import 'api_client.dart';

/// Loads programs from the backend (when USE_API=true) or from the local
/// JSON file. If the backend cannot be reached, the local JSON is used so the
/// app still works.
class ProgramService {
  final Future<String> Function() _loader;
  final ApiClient? _api;

  /// Small delay so the loading indicator is visible in demos.
  final Duration delay;

  /// True when the last load came from the local JSON file.
  bool usedLocalData = true;

  ProgramService({
    Future<String> Function()? loader,
    ApiClient? api,
    this.delay = const Duration(milliseconds: 800),
  })  : _loader = loader ?? _defaultLoader,
        _api = api;

  static Future<String> _defaultLoader() =>
      rootBundle.loadString('assets/data/programs.json');

  Future<List<Program>> fetchPrograms() async {
    if (delay > Duration.zero) {
      await Future.delayed(delay);
    }
    final api = _api;
    if (ApiConfig.useApi && api != null) {
      try {
        final data = await api.get(ApiConfig.programsPath);
        final programs = _parse(_extractList(data));
        if (programs.isNotEmpty) {
          usedLocalData = false;
          return programs;
        }
      } catch (e) {
        debugPrint('API programs failed, using local data: $e');
      }
    }
    usedLocalData = true;
    return _parse(json.decode(await _loader()));
  }

  List<Program> _parse(dynamic list) {
    if (list is! List) {
      throw const FormatException('Expected a JSON list of programs');
    }
    return list
        .map((e) => Program.fromJson(Map<String, dynamic>.from(e as Map)))
        .toList();
  }

  dynamic _extractList(dynamic data) {
    if (data is List) return data;
    if (data is Map) {
      for (final key in const ['programs', 'data', 'items', 'results']) {
        if (data[key] is List) return data[key];
      }
    }
    throw const FormatException('Unexpected programs response');
  }

  /// Sends a registration to the backend (does nothing in demo mode).
  Future<void> submitRegistration(String programId) async {
    final api = _api;
    if (!ApiConfig.useApi || api == null) return;
    await api.post(ApiConfig.registrationsPath, {'programId': programId});
  }

  /// Sends feedback to the backend (does nothing in demo mode).
  Future<void> submitFeedback(FeedbackEntry entry) async {
    final api = _api;
    if (!ApiConfig.useApi || api == null) return;
    await api.post(ApiConfig.feedbackPath, {
      'programId': entry.programId,
      'rating': entry.rating,
      'category': entry.category,
      'email': entry.email,
      'comment': entry.comment,
    });
  }
}
