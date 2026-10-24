import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../models/program.dart';
import '../providers/program_provider.dart';
import '../utils/context_colors.dart';
import '../utils/theme.dart';
import 'hover_card.dart';

class ProgramCard extends StatelessWidget {
  final Program program;
  final VoidCallback onTap;

  const ProgramCard({super.key, required this.program, required this.onTap});

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<ProgramProvider>();
    final left = provider.spotsLeft(program);
    final hasSpots = left > 0;
    final dark = context.isDark;

    // Badge colours that stay readable in both light and dark mode.
    final badgeBackground = hasSpots
        ? (dark ? const Color(0xFF14532D) : AppColors.successBackground)
        : (dark ? const Color(0xFF4C1D1D) : const Color(0xFFFEE2E2));
    final badgeText = hasSpots
        ? (dark ? const Color(0xFF86EFAC) : const Color(0xFF15803D))
        : (dark ? const Color(0xFFFCA5A5) : const Color(0xFFB91C1C));

    return HoverCard(
      child: GestureDetector(
        onTap: onTap,
        child: Container(
          margin: const EdgeInsets.only(bottom: 12),
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: context.surface,
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: context.borderColor),
          ),
          child: Row(
            children: [
              Container(
                width: 64,
                height: 64,
                decoration: BoxDecoration(
                  color: program.color,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Icon(program.icon, color: Colors.white, size: 30),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      program.title,
                      style: TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.w700,
                        color: context.accent,
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      program.tagline,
                      style: TextStyle(
                        fontSize: 12,
                        color: context.textMuted,
                      ),
                    ),
                    const SizedBox(height: 6),
                    Row(
                      children: [
                        Icon(
                          Icons.calendar_today_outlined,
                          size: 12,
                          color: context.textMuted,
                        ),
                        const SizedBox(width: 4),
                        Expanded(
                          child: Text(
                            program.date,
                            overflow: TextOverflow.ellipsis,
                            style: TextStyle(
                              fontSize: 12,
                              color: context.textMuted,
                            ),
                          ),
                        ),
                        const SizedBox(width: 8),
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 8,
                            vertical: 2,
                          ),
                          decoration: BoxDecoration(
                            color: badgeBackground,
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: Text(
                            hasSpots ? '$left spots left' : 'Full',
                            style: TextStyle(
                              fontSize: 11,
                              fontWeight: FontWeight.w600,
                              color: badgeText,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}