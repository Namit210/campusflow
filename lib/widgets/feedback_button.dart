import 'package:flutter/material.dart';

import '../models/program.dart';
import '../screens/feedback_screen.dart';
import '../utils/theme.dart';

/// Drop this anywhere on the Program Details screen.
class FeedbackButton extends StatelessWidget {
  final Program program;
  const FeedbackButton({super.key, required this.program});

  @override
  Widget build(BuildContext context) {
    return OutlinedButton.icon(
      onPressed: () => Navigator.push(
        context,
        MaterialPageRoute(builder: (_) => FeedbackScreen(program: program)),
      ),
      icon: const Icon(Icons.rate_review_outlined),
      label: const Text('Give feedback'),
      style: OutlinedButton.styleFrom(
        foregroundColor: AppColors.indigo,
        minimumSize: const Size.fromHeight(48),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      ),
    );
  }
}
