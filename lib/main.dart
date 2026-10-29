import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'providers/auth_provider.dart';
import 'providers/program_provider.dart';
import 'providers/theme_provider.dart';
import 'screens/login_screen.dart';
import 'utils/app_theme.dart';

void main() {
  runApp(
    MultiProvider(
      providers: [
        // Authentication session & logged in user profile
        ChangeNotifierProvider(create: (_) => AuthProvider()),
        // Programs, registrations, notifications and feedback.
        ChangeNotifierProvider(create: (_) => ProgramProvider(), lazy: false),
        // Light / dark mode.
        ChangeNotifierProvider(create: (_) => ThemeProvider()),
      ],
      child: const CampusFlowApp(),
    ),
  );
}

/// Root widget: sets the app title, the light and dark themes and the first screen.
class CampusFlowApp extends StatelessWidget {
  /// Set to false in tests, where Google Fonts cannot be downloaded.
  final bool useGoogleFonts;

  const CampusFlowApp({super.key, this.useGoogleFonts = true});

  @override
  Widget build(BuildContext context) {
    // Rebuild only when the user switches between light and dark mode.
    final themeMode = context.select<ThemeProvider, ThemeMode>((t) => t.mode);

    return MaterialApp(
      title: 'CampusFlow',
      debugShowCheckedModeBanner: false,
      theme: buildLightTheme(useGoogleFonts: useGoogleFonts),
      darkTheme: buildDarkTheme(useGoogleFonts: useGoogleFonts),
      themeMode: themeMode,
      home: const LoginScreen(),
    );
  }
}
