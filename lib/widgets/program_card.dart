import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../models/program.dart';
import '../providers/program_provider.dart';
import '../utils/theme.dart';

class ProgramCard extends StatelessWidget {
  final Program program;
  final VoidCallback onTap;

  const ProgramCard({super.key, required this.program, required this.onTap});

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<ProgramProvider>();
    final left = provider.spotsLeft(program);

    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: const EdgeInsets.only(bottom: 12),
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: AppColors.border),
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
                    style: const TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.w700,
                      color: AppColors.navy,
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    program.tagline,
                    style: const TextStyle(fontSize: 12, color: AppColors.muted),
                  ),
                  const SizedBox(height: 6),
                  Row(
                    children: [
                      const Icon(Icons.calendar_today_outlined,
                          size: 12, color: AppColors.muted),
                      const SizedBox(width: 4),
                      Text(program.date,
                          style: const TextStyle(
                              fontSize: 12, color: AppColors.muted)),
                      const Spacer(),
                      Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 8, vertical: 2),
                        decoration: BoxDecoration(
                          color: left > 0
                              ? const Color(0xFFDCFCE7)
                              : const Color(0xFFFEE2E2),
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: Text(
                          left > 0 ? '$left spots left' : 'Full',
                          style: TextStyle(
                            fontSize: 11,
                            fontWeight: FontWeight.w600,
                            color: left > 0
                                ? const Color(0xFF15803D)
                                : const Color(0xFFB91C1C),
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
    );
  }
}
