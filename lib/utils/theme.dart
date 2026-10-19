import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class AppColors {
  static const indigo = Color(0xFF4F46E5);
  static const navy = Color(0xFF1E1B4B);
  static const teal = Color(0xFF14B8A6);
  static const lavender = Color(0xFFC4B5FD);
  static const background = Color(0xFFF7F7FB);
  static const muted = Color(0xFF6B7280);
  static const border = Color(0xFFE5E7EB);
  static const successBackground = Color(0xFFDCFCE7);
  static const dateAccent = Color(0xFF64748B);
}

/// App-wide theme. Font: Inter (matches the CampusFlow design system).
/// [useGoogleFonts] is false only in automated tests (no network access).
ThemeData buildTheme({bool useGoogleFonts = true}) {
  final base = ThemeData(
    useMaterial3: true,
    colorScheme: ColorScheme.fromSeed(seedColor: AppColors.indigo),
    scaffoldBackgroundColor: AppColors.background,
    appBarTheme: const AppBarTheme(
      backgroundColor: AppColors.background,
      foregroundColor: AppColors.navy,
      elevation: 0,
      centerTitle: false,
    ),
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        backgroundColor: AppColors.indigo,
        foregroundColor: Colors.white,
        minimumSize: const Size.fromHeight(52),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        textStyle: const TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
      ),
    ),
    inputDecorationTheme: InputDecorationTheme(
      filled: true,
      fillColor: Colors.white,
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: const BorderSide(color: AppColors.border),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: const BorderSide(color: AppColors.border),
      ),
    ),
  );

  if (!useGoogleFonts) return base;
  return base.copyWith(textTheme: GoogleFonts.interTextTheme(base.textTheme));
}
