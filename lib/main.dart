import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'providers/program_provider.dart';
import 'screens/login_screen.dart';
import 'utils/theme.dart';

void main() {
  runApp(
    ChangeNotifierProvider(
      create: (_) => ProgramProvider(),
      child: const CampusFlowApp(),
    ),
  );
}

class CampusFlowApp extends StatelessWidget {
  const CampusFlowApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'CampusFlow',
      debugShowCheckedModeBanner: false,
      theme: buildTheme(useGoogleFonts: true),
      home: const LoginScreen(),
    );
  }
}
