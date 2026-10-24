import 'dart:convert';

import 'package:flutter/services.dart' show rootBundle;

import '../models/program.dart';

/// Loads programs from a local JSON file (acts as a mock API).
/// Later this class can call the real Express backend instead,
/// and no screen has to change.
class ProgramService {
  final Future<String> Function() _loader;

  /// Small delay so the loading indicator is visible in demos.
  final Duration delay;

  ProgramService({
    Future<String> Function()? loader,
    this.delay = const Duration(milliseconds: 800),
  }) : _loader = loader ?? _defaultLoader;

  static Future<String> _defaultLoader() =>
      rootBundle.loadString('assets/data/programs.json');

  Future<List<Program>> fetchPrograms() async {
    if (delay > Duration.zero) {
      await Future.delayed(delay);
    }
    final raw = await _loader();
    final decoded = json.decode(raw);
    if (decoded is! List) {
      throw const FormatException('Expected a JSON list of programs');
    }
    return decoded
        .map((e) => Program.fromJson(e as Map<String, dynamic>))
        .toList();
  }
}
