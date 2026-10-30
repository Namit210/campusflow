import 'package:flutter/material.dart';

import '../utils/context_colors.dart';
import '../utils/theme.dart';

class LoadingView extends StatelessWidget {
  const LoadingView({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          CircularProgressIndicator(color: AppColors.indigo),
          SizedBox(height: 16),
          Text('Loading programs...',
              style: TextStyle(color: context.textMuted)),
        ],
      ),
    );
  }
}

class ErrorView extends StatelessWidget {
  final String message;
  final VoidCallback onRetry;

  const ErrorView({super.key, required this.message, required this.onRetry});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(Icons.error_outline, size: 56, color: Colors.redAccent),
            SizedBox(height: 12),
            Text('Something went wrong',
                style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w700,
                    color: context.textPrimary)),
            SizedBox(height: 6),
            Text(message,
                textAlign: TextAlign.center,
                style: TextStyle(color: context.textMuted)),
            SizedBox(height: 20),
            ElevatedButton.icon(
              onPressed: onRetry,
              icon: Icon(Icons.refresh),
              label: Text('Retry'),
              style: ElevatedButton.styleFrom(
                  minimumSize: Size(140, 48)),
            ),
          ],
        ),
      ),
    );
  }
}
