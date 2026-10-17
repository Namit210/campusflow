import 'package:flutter/material.dart';

class AppNotification {
  final String id;
  final String title;
  final String message;
  final String timeAgo;
  final IconData icon;
  bool read;

  AppNotification({
    required this.id,
    required this.title,
    required this.message,
    required this.timeAgo,
    required this.icon,
    this.read = false,
  });
}
