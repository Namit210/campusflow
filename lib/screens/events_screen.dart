import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../models/program.dart';
import '../providers/program_provider.dart';
import '../utils/context_colors.dart';
import '../widgets/program_card.dart';
import '../widgets/state_views.dart';
import 'program_details_screen.dart';

/// Shows the events the learner registered for, then all upcoming events.
class EventsScreen extends StatelessWidget {
  const EventsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<ProgramProvider>();

    if (provider.isLoading) {
      return Scaffold(
        appBar: AppBar(title: const Text('Events')),
        body: const LoadingView(),
      );
    }
    if (provider.error != null) {
      return Scaffold(
        appBar: AppBar(title: const Text('Events')),
        body: ErrorView(
          message: provider.error!,
          onRetry: provider.loadPrograms,
        ),
      );
    }

    void open(Program program) => Navigator.push(
          context,
          MaterialPageRoute(
              builder: (_) => ProgramDetailsScreen(program: program)),
        );

    final registered = provider.registeredPrograms;
    final upcoming = provider.upcomingPrograms;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Events',
            style: TextStyle(fontWeight: FontWeight.w800)),
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          const _Heading('My registrations'),
          if (registered.isEmpty)
            Padding(
              padding: const EdgeInsets.only(bottom: 20),
              child: Text(
                "You haven't registered for anything yet. Pick an event below to get started.",
                style: TextStyle(color: context.textMuted),
              ),
            )
          else
            ...registered.map(
              (p) => ProgramCard(program: p, onTap: () => open(p)),
            ),
          const SizedBox(height: 8),
          const _Heading('Upcoming events'),
          ...upcoming.map(
            (p) => ProgramCard(program: p, onTap: () => open(p)),
          ),
        ],
      ),
    );
  }
}

class _Heading extends StatelessWidget {
  final String text;
  const _Heading(this.text);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: Text(
        text,
        style: TextStyle(
          fontSize: 18,
          fontWeight: FontWeight.w700,
          color: context.textPrimary,
        ),
      ),
    );
  }
}
