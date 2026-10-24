import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/theme_provider.dart';

/// Sun/moon button. Put it in an AppBar's `actions`.
class ThemeToggleButton extends StatelessWidget {
  const ThemeToggleButton({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = context.watch<ThemeProvider>();
    return IconButton(
      tooltip: theme.isDark ? 'Switch to light mode' : 'Switch to dark mode',
      onPressed: theme.toggle,
      icon: AnimatedSwitcher(
        duration: const Duration(milliseconds: 200),
        child: Icon(
          theme.isDark ? Icons.light_mode_outlined : Icons.dark_mode_outlined,
          key: ValueKey(theme.isDark),
        ),
      ),
    );
  }
}
