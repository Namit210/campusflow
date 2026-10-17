import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../models/program.dart';
import '../providers/program_provider.dart';
import '../utils/theme.dart';
import 'registration_confirmation_screen.dart';

class ProgramDetailsScreen extends StatelessWidget {
  final Program program;
  const ProgramDetailsScreen({super.key, required this.program});

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<ProgramProvider>();
    final registered = provider.isRegistered(program.id);
    final left = provider.spotsLeft(program);
    final full = left <= 0 && !registered;

    return Scaffold(
      body: ListView(
        padding: EdgeInsets.zero,
        children: [
          // Banner
          Container(
            height: 220,
            color: program.color,
            child: SafeArea(
              child: Stack(
                children: [
                  Align(
                    alignment: Alignment.center,
                    child: Icon(program.icon, size: 80, color: Colors.white),
                  ),
                  Positioned(
                    left: 8,
                    top: 8,
                    child: IconButton(
                      icon: const Icon(Icons.arrow_back, color: Colors.white),
                      onPressed: () => Navigator.pop(context),
                    ),
                  ),
                  Positioned(
                    right: 8,
                    top: 8,
                    child: IconButton(
                      icon: const Icon(Icons.bookmark_border,
                          color: Colors.white),
                      onPressed: () {},
                    ),
                  ),
                ],
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Chip(
                  label: Text(program.category),
                  backgroundColor: AppColors.lavender,
                  side: BorderSide.none,
                ),
                const SizedBox(height: 8),
                Text(program.title,
                    style: const TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.w800,
                        color: AppColors.navy)),
                const SizedBox(height: 16),
                _InfoRow(
                    icon: Icons.calendar_today_outlined,
                    text: '${program.date} · ${program.time}'),
                _InfoRow(
                    icon: Icons.location_on_outlined, text: program.location),
                _InfoRow(
                    icon: Icons.people_outline,
                    text:
                        '${provider.seatsTaken(program)} / ${program.capacity} registered'),
                const SizedBox(height: 20),
                const Text('About',
                    style:
                        TextStyle(fontSize: 18, fontWeight: FontWeight.w700)),
                const SizedBox(height: 6),
                Text(program.about,
                    style: const TextStyle(
                        color: AppColors.muted, height: 1.5)),
                const SizedBox(height: 20),
                const Text("What you'll learn",
                    style:
                        TextStyle(fontSize: 18, fontWeight: FontWeight.w700)),
                const SizedBox(height: 6),
                ...program.learnPoints.map(
                  (p) => Padding(
                    padding: const EdgeInsets.symmetric(vertical: 4),
                    child: Row(
                      children: [
                        const Icon(Icons.check_circle,
                            size: 18, color: AppColors.teal),
                        const SizedBox(width: 8),
                        Expanded(child: Text(p)),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
      bottomNavigationBar: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: ElevatedButton(
            onPressed: (registered || full)
                ? null
                : () {
                    provider.register(program);
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) =>
                            RegistrationConfirmationScreen(program: program),
                      ),
                    );
                  },
            child: Text(registered
                ? 'Registered ✓'
                : full
                    ? 'Event full'
                    : 'Register'),
          ),
        ),
      ),
    );
  }
}

class _InfoRow extends StatelessWidget {
  final IconData icon;
  final String text;
  const _InfoRow({required this.icon, required this.text});

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
