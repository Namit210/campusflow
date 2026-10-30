import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/auth_provider.dart';
import 'login_screen.dart';
import 'main_shell.dart';

/// Shows Login or the main app depending on whether the user is signed in.
/// Logging in or out switches screens automatically.
class AuthGate extends StatelessWidget {
  const AuthGate({super.key});

  @override
  Widget build(BuildContext context) {
    final auth = context.watch<AuthProvider>();
    if (auth.isInitializing) {
      return const Scaffold(body: Center(child: CircularProgressIndicator()));
    }
    return auth.isLoggedIn ? const MainShell() : const LoginScreen();
  }
}
