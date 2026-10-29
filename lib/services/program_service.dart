import 'dart:convert';
import 'package:flutter/services.dart' show rootBundle;

import '../models/feedback_entry.dart';
import '../models/program.dart';
import '../models/user_registration.dart';
import 'api_client.dart';

/// Handles fetching and updating programs, event registrations, and feedback.
/// Prioritizes calling the real backend Express API, while providing a seamless
/// local asset fallback for offline reliability.
class ProgramService {
  final ApiClient _api;
  final Future<String> Function() _loader;

  /// Optional delay used in UI previews or unit tests.
  final Duration delay;

  ProgramService({
    ApiClient? api,
    Future<String> Function()? loader,
    this.delay = Duration.zero,
  })  : _api = api ?? ApiClient.instance,
        _loader = loader ?? _defaultLoader;

  static Future<String> _defaultLoader() =>
      rootBundle.loadString('assets/data/programs.json');

  /// Fetches programs from the backend API, falling back to local JSON if offline.
  Future<List<Program>> fetchPrograms({
    String? category,
    String? query,
  }) async {
    if (delay > Duration.zero) {
      await Future.delayed(delay);
    }

    // Try live API first
    try {
      final queryParams = <String, dynamic>{};
      if (category != null && category != 'All') queryParams['category'] = category;
      if (query != null && query.isNotEmpty) queryParams['q'] = query;

      final dynamic response = await _api.get('/programs', queryParams: queryParams);
      if (response is List) {
        return response
            .map((e) => Program.fromJson(e as Map<String, dynamic>))
            .toList();
      }
    } catch (_) {
      // If network fails, gracefully proceed to offline asset cache
    }

    // Offline asset fallback
    final raw = await _loader();
    final decoded = json.decode(raw);
    if (decoded is! List) {
      throw const FormatException('Expected a JSON list of programs');
    }

    var list = decoded
        .map((e) => Program.fromJson(e as Map<String, dynamic>))
        .toList();

    if (category != null && category != 'All') {
      list = list.where((p) => p.category == category).toList();
    }
    if (query != null && query.isNotEmpty) {
      list = list
          .where((p) => p.title.toLowerCase().contains(query.toLowerCase()))
          .toList();
    }

    return list;
  }

  /// Fetches a single program by its ID.
  Future<Program> fetchProgramById(String id) async {
    try {
      final response = await _api.get('/programs/$id');
      return Program.fromJson(response as Map<String, dynamic>);
    } catch (_) {
      final all = await fetchPrograms();
      return all.firstWhere((p) => p.id == id);
    }
  }

  /// Registers the current user for a program via the backend.
  Future<Program> registerForProgram(String id) async {
    final response = await _api.post('/programs/$id/register');
    final programData = response['program'] as Map<String, dynamic>?;
    if (programData != null) {
      return Program.fromJson(programData);
    }
    return fetchProgramById(id);
  }

  /// Cancels a user's registration for a program.
  Future<Program?> cancelRegistration(String id) async {
    final response = await _api.delete('/programs/$id/register');
    final programData = response['program'] as Map<String, dynamic>?;
    if (programData != null) {
      return Program.fromJson(programData);
    }
    return null;
  }

  /// Fetches the list of programs registered by the authenticated user.
  Future<List<String>> fetchMyRegisteredProgramIds() async {
    final list = await fetchMyRegistrations();
    return list.map((r) => r.programId).toList();
  }

  /// Fetches detailed user registrations including module progress and status.
  Future<List<UserRegistration>> fetchMyRegistrations() async {
    try {
      final dynamic response = await _api.get('/registrations');
      if (response is List) {
        return response
            .map((item) =>
                UserRegistration.fromJson(item as Map<String, dynamic>))
            .toList();
      }
    } catch (_) {
      // Non-critical: return empty list if offline or unauthorized
    }
    return [];
  }

  /// Toggles a module's completed state for an enrolled program.
  Future<UserRegistration> toggleModuleCompletion(
    String programId,
    int moduleIndex,
  ) async {
    final dynamic response = await _api.patch(
      '/registrations/$programId/modules/$moduleIndex/toggle',
    );
    if (response is Map<String, dynamic> && response['registration'] != null) {
      return UserRegistration.fromJson(
        response['registration'] as Map<String, dynamic>,
      );
    }
    throw const FormatException('Unexpected response when toggling module');
  }

  /// Submits user feedback for a program.
  Future<FeedbackEntry> submitFeedback(FeedbackEntry entry) async {
    final response = await _api.post(
      '/programs/${entry.programId}/feedback',
      body: entry.toJson(),
    );
    final feedbackData = response['feedback'] as Map<String, dynamic>?;
    if (feedbackData != null) {
      return FeedbackEntry.fromJson(feedbackData);
    }
    return entry;
  }
}
