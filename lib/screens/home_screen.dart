import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/program_provider.dart';
import '../utils/theme.dart';
import '../widgets/program_card.dart';
import 'notifications_screen.dart';
import 'program_details_screen.dart';

class HomeScreen extends StatelessWidget {
  final VoidCallback onSeeAll;
  const HomeScreen({super.key, required this.onSeeAll});

  static const _announcements = [
    ('Campus Innovation Day is next week', 'Oct 10, 2026'),
    ('New Program: AI & Future Skills', 'Oct 8, 2026'),
    ('Campus office hours update', 'Oct 6, 2026'),
  ];

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<ProgramProvider>();
    final upcoming = provider.allPrograms.take(3).toList();

    return Scaffold(
      appBar: AppBar(
        title: const Text('CampusFlow',
            style: TextStyle(fontWeight: FontWeight.w800)),
        actions: [
          IconButton(icon: const Icon(Icons.search), onPressed: onSeeAll),
          Stack(
            alignment: Alignment.center,
            children: [
              IconButton(
                icon: const Icon(Icons.notifications_outlined),
                onPressed: () => Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (_) => const NotificationsScreen()),
                ),
              ),
              if (provider.unreadCount > 0)
                Positioned(
                  right: 8,
                  top: 8,
                  child: IgnorePointer(
                    child: Container(
                      padding: const EdgeInsets.all(5),
                      decoration: const BoxDecoration(
                          color: AppColors.indigo, shape: BoxShape.circle),
                      child: Text('${provider.unreadCount}',
                          style: const TextStyle(
                              color: Colors.white, fontSize: 9)),
                    ),
                  ),
                ),
            ],
          ),
          const SizedBox(width: 4),
        ],
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          const Text('Good morning, Alex 👋',
              style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.w800,
                  color: AppColors.navy)),
          const SizedBox(height: 4),
          const Text("Here's what's happening across your campus.",
              style: TextStyle(color: AppColors.muted)),
          const SizedBox(height: 16),
          Row(
            children: [
              _StatCard(
                  icon: Icons.menu_book_outlined,
                  label: 'Programs',
                  value: '${provider.allPrograms.length}'),
              const SizedBox(width: 10),
              const _StatCard(
                  icon: Icons.event_outlined, label: 'Events', value: '8'),
              const SizedBox(width: 10),
              _StatCard(
                  icon: Icons.how_to_reg_outlined,
                  label: 'Registered',
                  value: '${provider.registeredCount}'),
            ],
          ),
          const SizedBox(height: 24),
          Row(
            children: [
              const Text('Upcoming Events',
                  style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w700,
                      color: AppColors.navy)),
              const Spacer(),
              TextButton(onPressed: onSeeAll, child: const Text('View all')),
            ],
          ),
          ...upcoming.map(
            (p) => ProgramCard(
              program: p,
              onTap: () => Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (_) => ProgramDetailsScreen(program: p)),
              ),
            ),
          ),
          const SizedBox(height: 12),
          const Text('Announcements',
              style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w700,
                  color: AppColors.navy)),
          const SizedBox(height: 8),
          ..._announcements.map(
            (a) => Container(
              margin: const EdgeInsets.only(bottom: 8),
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: AppColors.border),
              ),
              child: Row(
                children: [
                  const Icon(Icons.campaign_outlined, color: AppColors.indigo),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(a.$1,
                            style:
                                const TextStyle(fontWeight: FontWeight.w600)),
                        Text(a.$2,
                            style: const TextStyle(
                                fontSize: 12, color: AppColors.muted)),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _StatCard extends StatelessWidget {
  final IconData icon;
  final String label;
  final String value;
  const _StatCard(
      {required this.icon, required this.label, required this.value});

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(14),
          border: Border.all(color: AppColors.border),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Icon(icon, color: AppColors.indigo, size: 22),
            const SizedBox(height: 8),
            Text(value,
                style: const TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.w800,
                    color: AppColors.navy)),
            Text(label,
                style: const TextStyle(fontSize: 12, color: AppColors.muted)),
          ],
        ),
      ),
    );
  }
}
