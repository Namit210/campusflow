import 'package:flutter/material.dart';

class Program {
  final String id;
  final String title;
  final String tagline;
  final String imageUrl;
  final String category; // Workshop, Seminar, Career
  final String date;
  final String time;
  final String location;
  final int capacity;
  final int registered;
  final String about;
  final List<String> learnPoints;
  final List<String> whatYouWillDo;
  final String recommendation;
  final String duration;
  final String fee;
  final String supportedBy;
  final int startsInDays;
  final List<String> learningPath;
  final String lastDateToApply;
  final String startDate;
  final String endDate;
  final List<String> completionRewards;
  final List<String> eligibility;
  final IconData icon;
  final Color color;
  final int progress;
  final String institution;
  final String institutionShort;
  final String nextSubmission;

  const Program({
    required this.id,
    required this.title,
    required this.tagline,
    required this.imageUrl,
    required this.category,
    required this.date,
    required this.time,
    required this.location,
    required this.capacity,
    required this.registered,
    required this.about,
    required this.learnPoints,
    required this.whatYouWillDo,
    required this.recommendation,
    required this.duration,
    required this.fee,
    required this.supportedBy,
    required this.startsInDays,
    required this.learningPath,
    required this.lastDateToApply,
    required this.startDate,
    required this.endDate,
    required this.completionRewards,
    required this.eligibility,
    required this.icon,
    required this.color,
    this.progress = 0,
    this.institution = 'CampusFlow',
    this.institutionShort = 'CF',
    this.nextSubmission = '',
  });

  // JSON uses a short name for the icon and a "#RRGGBB" string for the colour.
  static const Map<String, IconData> _icons = {
    'lightbulb': Icons.lightbulb_outline,
    'rocket': Icons.rocket_launch_outlined,
    'work': Icons.work_outline,
    'devices': Icons.devices_outlined,
    'spa': Icons.spa_outlined,
  };

  static const Map<String, IconData> _categoryIcons = {
    'Workshop': Icons.lightbulb_outline,
    'Seminar': Icons.rocket_launch_outlined,
    'Career': Icons.work_outline,
  };

  static const Map<String, Color> _categoryColors = {
    'Workshop': Color(0xFFCF491D),
    'Seminar': Color(0xFF7C3AED),
    'Career': Color(0xFF14B8A6),
  };

  static Color _parseColor(String? hex) {
    if (hex == null || !hex.startsWith('#') || hex.length != 7) {
      return const Color(0xFF4F46E5);
    }
    return Color(int.tryParse('FF${hex.substring(1)}', radix: 16) ?? 0xFF4F46E5);
  }

  /// Builds a Program from one JSON object. Missing fields fall back to
  /// safe defaults so one bad record cannot crash the app.
  factory Program.fromJson(Map<String, dynamic> json) {
    String str(String key, [String fallback = '']) =>
        json[key]?.toString() ?? fallback;
    int integer(String key, [int fallback = 0]) =>
        (json[key] as num?)?.toInt() ?? fallback;
    List<String> list(String key) =>
        (json[key] as List<dynamic>? ?? const []).map((e) => e.toString()).toList();

    return Program(
      id: str('id', str('_id')),
      title: str('title', str('name')),
      tagline: str('tagline'),
      imageUrl: str('imageUrl', str('image')),
      category: str('category', 'Workshop'),
      date: str('date', str('startDate')),
      time: str('time'),
      location: str('location'),
      capacity: integer('capacity'),
      registered: integer('registered', integer('registeredCount')),
      about: str('about', str('description')),
      learnPoints: list('learnPoints'),
      whatYouWillDo: list('whatYouWillDo'),
      recommendation: str('recommendation'),
      duration: str('duration'),
      fee: str('fee', 'Free'),
      supportedBy: str('supportedBy'),
      startsInDays: integer('startsInDays'),
      learningPath: list('learningPath'),
      lastDateToApply: str('lastDateToApply'),
      startDate: str('startDate'),
      endDate: str('endDate'),
      completionRewards: list('completionRewards'),
      eligibility: list('eligibility'),
      icon: _icons[str('icon')] ??
          _categoryIcons[str('category', 'Workshop')] ??
          Icons.school_outlined,
      color: json['color'] is String
          ? _parseColor(json['color'] as String)
          : (_categoryColors[str('category', 'Workshop')] ??
              const Color(0xFF4F46E5)),
      progress: integer('progress'),
      institution: str('institution', 'CampusFlow'),
      institutionShort: str('institutionShort', 'CF'),
      nextSubmission: str('nextSubmission'),
    );
  }
}
