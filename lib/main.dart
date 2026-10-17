import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'providers/program_provider.dart';
import 'screens/login_screen.dart';
import 'utils/theme.dart';

void main() {
  runApp(
    ChangeNotifierProvider(
      create: (_) => ProgramProvider(),
      child: const CampusFlowApp(useGoogleFonts: true),
    ),
  );
}

class CampusFlowApp extends StatelessWidget {
  final bool useGoogleFonts;
  const CampusFlowApp({super.key, required this.useGoogleFonts  });

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'CampusFlow',
      debugShowCheckedModeBanner: false,
      theme: buildTheme(useGoogleFonts: useGoogleFonts),
      home: const LoginScreen(),
    );
  }
}
