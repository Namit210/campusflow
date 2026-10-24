import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import 'theme.dart';

const _darkBg = Color(0xFF0F1020);
const _darkSurface = Color(0xFF1B1D33);
const _darkBorder = Color(0xFF2E3050);
const _indigoHover = Color(0xFF4338CA);
const _indigoPressed = Color(0xFF3730A3);

/// Light theme = your existing buildTheme() plus hover/press effects.
ThemeData buildLightTheme({bool useGoogleFonts = true}) =>
    _withInteractions(buildTheme(useGoogleFonts: useGoogleFonts));

/// Dark theme with the same shapes and brand colours.
ThemeData buildDarkTheme({bool useGoogleFonts = true}) {
  final scheme = ColorScheme.fromSeed(
    seedColor: AppColors.indigo,
    brightness: Brightness.dark,
  ).copyWith(surface: _darkSurface, primary: const Color(0xFF818CF8));

  final base = ThemeData(
    useMaterial3: true,
    brightness: Brightness.dark,
    colorScheme: scheme,
    scaffoldBackgroundColor: _darkBg,
    cardColor: _darkSurface,
    dividerColor: _darkBorder,
    appBarTheme: const AppBarTheme(
      backgroundColor: _darkBg,
      foregroundColor: Color(0xFFF3F4F6),
      elevation: 0,
      centerTitle: false,
      surfaceTintColor: Colors.transparent,
    ),
    navigationBarTheme: NavigationBarThemeData(
      backgroundColor: _darkSurface,
      surfaceTintColor: Colors.transparent,
      indicatorColor: AppColors.indigo.withValues(alpha: 0.35),
    ),
    chipTheme: ChipThemeData(
      backgroundColor: _darkSurface,
      side: const BorderSide(color: _darkBorder),
    ),
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        minimumSize: const Size.fromHeight(52),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        textStyle: const TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
      ),
    ),
    inputDecorationTheme: InputDecorationTheme(
      filled: true,
      fillColor: _darkSurface,
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: const BorderSide(color: _darkBorder),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: const BorderSide(color: _darkBorder),
      ),
    ),
  );

  final themed = useGoogleFonts
      ? base.copyWith(textTheme: GoogleFonts.interTextTheme(base.textTheme))
      : base;
  return _withInteractions(themed);
}

/// Adds hover, press and disabled states to every button type.
/// (Hover is visible on Chrome/desktop; on phones the press state shows.)
ThemeData _withInteractions(ThemeData base) {
  final dark = base.brightness == Brightness.dark;

  final hoverOverlay = WidgetStateProperty.resolveWith<Color?>((states) {
    if (states.contains(WidgetState.pressed)) {
      return AppColors.indigo.withValues(alpha: 0.18);
    }
    if (states.contains(WidgetState.hovered)) {
      return AppColors.indigo.withValues(alpha: 0.10);
    }
    if (states.contains(WidgetState.focused)) {
      return AppColors.indigo.withValues(alpha: 0.14);
    }
    return null;
  });

  final primary = ButtonStyle(
    backgroundColor: WidgetStateProperty.resolveWith<Color?>((states) {
      if (states.contains(WidgetState.disabled)) {
        return dark ? const Color(0xFF3A3D5C) : const Color(0xFFD1D5DB);
      }
      if (states.contains(WidgetState.pressed)) return _indigoPressed;
      if (states.contains(WidgetState.hovered)) return _indigoHover;
      return AppColors.indigo;
    }),
    foregroundColor: WidgetStateProperty.resolveWith<Color?>((states) =>
        states.contains(WidgetState.disabled)
            ? const Color(0xFF9CA3AF)
            : Colors.white),
    elevation: WidgetStateProperty.resolveWith<double?>(
        (states) => states.contains(WidgetState.hovered) ? 4 : 0),
    shadowColor:
        WidgetStatePropertyAll(AppColors.indigo.withValues(alpha: 0.45)),
    animationDuration: const Duration(milliseconds: 150),
  );

  final outlined = ButtonStyle(
    overlayColor: hoverOverlay,
    side: WidgetStateProperty.resolveWith<BorderSide?>((states) {
      final hovered = states.contains(WidgetState.hovered);
      return BorderSide(
        color: hovered
            ? AppColors.indigo
            : (dark ? _darkBorder : AppColors.border),
        width: hovered ? 1.6 : 1,
      );
    }),
  );

  return base.copyWith(
    hoverColor: AppColors.indigo.withValues(alpha: 0.08),
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: (base.elevatedButtonTheme.style ?? const ButtonStyle())
          .merge(primary),
    ),
    outlinedButtonTheme: OutlinedButtonThemeData(
      style: (base.outlinedButtonTheme.style ?? const ButtonStyle())
          .merge(outlined),
    ),
    textButtonTheme: TextButtonThemeData(
      style: (base.textButtonTheme.style ?? const ButtonStyle())
          .merge(ButtonStyle(overlayColor: hoverOverlay)),
    ),
    iconButtonTheme: IconButtonThemeData(
      style: (base.iconButtonTheme.style ?? const ButtonStyle())
          .merge(ButtonStyle(overlayColor: hoverOverlay)),
    ),
  );
}
