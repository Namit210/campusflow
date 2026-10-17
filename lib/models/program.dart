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
  });
}
