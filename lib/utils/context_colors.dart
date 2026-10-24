import 'package:flutter/material.dart';

import 'theme.dart';

/// Colours that change with light/dark mode.
/// Use `context.surface` instead of `Colors.white` for cards,
/// `context.textPrimary` instead of `AppColors.navy`, and so on.
extension AppContextColors on BuildContext {
  bool get isDark => Theme.of(this).brightness == Brightness.dark;

  /// Card / container background.
  Color get surface => isDark ? const Color(0xFF1B1D33) : Colors.white;

  /// Headings and strong text.
  Color get textPrimary => isDark ? const Color(0xFFF3F4F6) : AppColors.navy;

  /// Secondary text.
  Color get textMuted => isDark ? const Color(0xFF9CA3AF) : AppColors.muted;

  /// Card borders and dividers.
  Color get borderColor => isDark ? const Color(0xFF2E3050) : AppColors.border;

  /// Highlight colour for titles and links.
  Color get accent => isDark ? const Color(0xFFA5B4FC) : AppColors.indigo;

  /// Soft tinted background (callouts).
  Color get tint => isDark ? const Color(0xFF26294A) : const Color(0xFFEEF2FF);
}
