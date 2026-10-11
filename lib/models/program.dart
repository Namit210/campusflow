import 'package:flutter/material.dart';

class Program {
  final String id;
  final String title;
  final String tagline;
  final String category; // Workshop, Seminar, Career
  final String date;
  final String time;
  final String location;
  final int capacity;
  final int registered;
  final String about;
  final List<String> learnPoints;
  final IconData icon;
  final Color color;

  const Program({
    required this.id,
    required this.title,
    required this.tagline,
    required this.category,
    required this.date,
    required this.time,
    required this.location,
    required this.capacity,
    required this.registered,
    required this.about,
    required this.learnPoints,
    required this.icon,
    required this.color,
  });
}
