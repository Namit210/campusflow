import 'package:flutter/material.dart';

import '../models/program.dart';
import '../utils/context_colors.dart';
import '../utils/theme.dart';
import 'notifications_screen.dart';

class RegistrationConfirmationScreen extends StatelessWidget {
  final Program program;
  const RegistrationConfirmationScreen({super.key, required this.program});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            children: [
              const Spacer(),
              const CircleAvatar(
                radius: 44,
                backgroundColor: AppColors.teal,
                child: Icon(Icons.check, color: Colors.white, size: 52),
              ),
              const SizedBox(height: 24),
              Text(
                'Registration confirmed',
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.w800,
                  color: context.textPrimary,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                "You're all set for ${program.title}.",
                textAlign: TextAlign.center,
                style: TextStyle(color: context.textMuted),
              ),
              const SizedBox(height: 24),
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: context.surface,
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(color: context.borderColor),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _Row(Icons.calendar_today_outlined,
                        '${program.date} · ${program.time}'),
                    _Row(Icons.location_on_outlined, program.location),
                  ],
                ),
              ),
              const Spacer(),
              ElevatedButton(
                onPressed: () =>
                    Navigator.popUntil(context, (route) => route.isFirst),
                child: const Text('Back to programs'),
              ),
              const SizedBox(height: 8),
              TextButton(
                onPressed: () => Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (_) => const NotificationsScreen()),
                ),
                child: const Text('View notifications'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _Row extends StatelessWidget {
  final IconData icon;
  final String text;
  const _Row(this.icon, this.text);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        children: [
          Icon(icon, size: 18, color: AppColors.indigo),
          const SizedBox(width: 10),
          Expanded(child: Text(text)),
        ],
      ),
    );
  }
}
