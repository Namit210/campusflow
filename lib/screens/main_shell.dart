import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/auth_provider.dart';
import '../providers/program_provider.dart';
import '../utils/theme.dart';
import 'home_screen.dart';
import 'login_screen.dart';
import 'my_programs_screen.dart';
import 'program_list_screen.dart';
import '../utils/context_colors.dart';

/// Holds the bottom navigation: Home · Programs · My Learning · Profile
class MainShell extends StatefulWidget {
  const MainShell({super.key});

  @override
  State<MainShell> createState() => _MainShellState();
}

class _MainShellState extends State<MainShell> {
  int _index = 0;

  @override
  Widget build(BuildContext context) {
    final pages = [
      HomeScreen(onSeeAll: () => setState(() => _index = 1)),
      const ProgramListScreen(),
      MyProgramsScreen(onExplore: () => setState(() => _index = 1)),
      const _ProfileScreen(),
    ];

    return Scaffold(
      body: IndexedStack(index: _index, children: pages),
      bottomNavigationBar: NavigationBar(
        selectedIndex: _index,
        backgroundColor: context.surface,
        indicatorColor: context.isDark ? AppColors.indigo.withValues(alpha: 0.48) : AppColors.lavender,
        indicatorShape: const StadiumBorder(),
        elevation: 2,
        labelTextStyle: const WidgetStatePropertyAll(
          TextStyle(fontSize: 12, fontWeight: FontWeight.w600),
        ),
        onDestinationSelected: (i) => setState(() => _index = i),
        destinations: const [
          NavigationDestination(
            icon: Icon(Icons.home_outlined),
            selectedIcon: Icon(Icons.home),
            label: 'Home',
          ),
          NavigationDestination(
            icon: Icon(Icons.menu_book_outlined),
            selectedIcon: Icon(Icons.menu_book),
            label: 'Programs',
          ),
          NavigationDestination(
            icon: Icon(Icons.school_outlined),
            selectedIcon: Icon(Icons.school),
            label: 'My Learning',
          ),
          NavigationDestination(
            icon: Icon(Icons.person_outline),
            selectedIcon: Icon(Icons.person),
            label: 'Profile',
          ),
        ],
      ),
    );
  }
}

class _ProfileScreen extends StatelessWidget {
  const _ProfileScreen();

  @override
  Widget build(BuildContext context) {
    final auth = context.watch<AuthProvider?>();
    final provider = context.watch<ProgramProvider>();

    final user = auth?.user;
    final name = (user != null && user.name.isNotEmpty) ? user.name : 'Alex Learner';
    final email = (user != null && user.email.isNotEmpty) ? user.email : 'learner@campusflow.edu';
    final initial = name.trim().isNotEmpty ? name.trim()[0].toUpperCase() : 'A';

    return Scaffold(
      appBar: AppBar(title: const Text('Profile')),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            const SizedBox(height: 12),
            CircleAvatar(
              radius: 44,
              backgroundColor: AppColors.navy,
              child: Text(
                initial,
                style: const TextStyle(fontSize: 36, color: Colors.white),
              ),
            ),
            const SizedBox(height: 12),
            Text(
              name,
              style: const TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.w700,
                color: AppColors.navy,
              ),
            ),
            Text(email, style: const TextStyle(color: AppColors.muted)),
            const SizedBox(height: 24),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 16),
              decoration: BoxDecoration(
                color: context.surface,
                borderRadius: BorderRadius.circular(14),
                border: Border.all(color: context.borderColor),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  _StatItem(
                    label: 'Enrolled',
                    value: '${provider.registeredCount}',
                    color: context.textPrimary,
                  ),
                  Container(
                    width: 1,
                    height: 36,
                    color: context.borderColor,
                  ),
                  _StatItem(
                    label: 'Ongoing',
                    value: '${provider.ongoingCount}',
                    color: AppColors.indigo,
                  ),
                  Container(
                    width: 1,
                    height: 36,
                    color: context.borderColor,
                  ),
                  _StatItem(
                    label: 'Completed',
                    value: '${provider.completedCount}',
                    color: const Color(0xFF059669),
                  ),
                ],
              ),
            ),
            const Spacer(),
            OutlinedButton.icon(
              style: OutlinedButton.styleFrom(
                minimumSize: const Size.fromHeight(50),
              ),
              icon: const Icon(Icons.logout),
              label: const Text('Log out'),
              onPressed: () {
                auth?.logout();
                Navigator.pushAndRemoveUntil(
                  context,
                  MaterialPageRoute(builder: (_) => const LoginScreen()),
                  (route) => false,
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}

class _StatItem extends StatelessWidget {
  final String label;
  final String value;
  final Color color;

  const _StatItem({
    required this.label,
    required this.value,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(
          value,
          style: TextStyle(
            fontSize: 22,
            fontWeight: FontWeight.w800,
            color: color,
          ),
        ),
        Text(
          label,
          style: TextStyle(color: context.textMuted, fontSize: 13),
        ),
      ],
    );
  }
}
