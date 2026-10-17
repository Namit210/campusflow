import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../models/program.dart';
import '../providers/program_provider.dart';
import '../utils/theme.dart';

class ProgramDetailsScreen extends StatelessWidget {
  final Program program;
  const ProgramDetailsScreen({super.key, required this.program});

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<ProgramProvider>();
    final registered = provider.isRegistered(program.id);
    final left = provider.spotsLeft(program);
    final full = left <= 0 && !registered;

    return Scaffold(
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            expandedHeight: 245,
            pinned: true,
            foregroundColor: Colors.white,
            backgroundColor: program.color,
            actions: [
              IconButton(
                tooltip: 'Save program',
                icon: const Icon(Icons.bookmark_border),
                onPressed: () {},
              ),
            ],
            flexibleSpace: FlexibleSpaceBar(
              background: Stack(
                fit: StackFit.expand,
                children: [
                  Image.network(
                    program.imageUrl,
                    fit: BoxFit.cover,
                    errorBuilder: (_, __, ___) => Container(
                      color: program.color,
                      child: Icon(program.icon, size: 84, color: Colors.white),
                    ),
                  ),
                  DecoratedBox(
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                        colors: [
                          Colors.black.withValues(alpha: 0.05),
                          Colors.black.withValues(alpha: 0.62),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          SliverPadding(
            padding: const EdgeInsets.fromLTRB(20, 20, 20, 110),
            sliver: SliverList(
              delegate: SliverChildListDelegate([
                Chip(
                  label: Text(program.category),
                  backgroundColor: AppColors.lavender,
                  side: BorderSide.none,
                ),
                const SizedBox(height: 10),
                Text(
                  program.title,
                  style: const TextStyle(
                    fontSize: 27,
                    height: 1.15,
                    fontWeight: FontWeight.w800,
                    color: AppColors.navy,
                  ),
                ),
                const SizedBox(height: 6),
                Text(
                  program.tagline,
                  style: const TextStyle(fontSize: 16, color: AppColors.muted),
                ),
                const SizedBox(height: 18),
                Text(program.about, style: _bodyStyle),
                const SizedBox(height: 24),
                _Section(
                  title: 'Program at a glance',
                  child: Wrap(
                    spacing: 10,
                    runSpacing: 10,
                    children: [
                      _Fact(icon: Icons.schedule, label: program.duration),
                      _Fact(icon: Icons.payments_outlined, label: program.fee),
                      _Fact(
                        icon: Icons.location_on_outlined,
                        label: program.location,
                      ),
                    ],
                  ),
                ),
                _Section(
                  title: 'What you will do',
                  child: _BulletList(program.whatYouWillDo),
                ),
                _Section(
                  title: 'Recommendation',
                  child: _Callout(
                    icon: Icons.thumb_up_alt_outlined,
                    text: program.recommendation,
                  ),
                ),
                _Section(
                  title: 'Supported by',
                  child: _Callout(
                    icon: Icons.school_outlined,
                    text: program.supportedBy,
                  ),
                ),
                _Section(
                  title: 'Learning Path',
                  child: Column(
                    children: [
                      for (var i = 0; i < program.learningPath.length; i++)
                        _PathItem(
                          number: i + 1,
                          title: 'Module ${i + 1}',
                          description: program.learningPath[i],
                          isLast: i == program.learningPath.length - 1,
                        ),
                    ],
                  ),
                ),
                _Section(
                  title: 'Upcoming cohort dates',
                  child: _DateTable(
                    lastDateToApply: program.lastDateToApply,
                    startDate: program.startDate,
                    endDate: program.endDate,
                  ),
                ),
                _Section(
                  title: 'Rewards for completion',
                  child: _BulletList(
                    program.completionRewards,
                    icon: Icons.stars,
                  ),
                ),
                _Section(
                  title: 'Eligibility',
                  child: _BulletList(
                    program.eligibility,
                    icon: Icons.verified_user_outlined,
                  ),
                ),
                _Section(
                  title: 'Your rewards',
                  child: Card(
                    elevation: 0,
                    color: const Color(0xFFFFF7ED),
                    child: Padding(
                      padding: const EdgeInsets.all(16),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            'Everything you earn in one place',
                            style: TextStyle(fontWeight: FontWeight.w700),
                          ),
                          const SizedBox(height: 10),
                          ...program.completionRewards.map(
                            (reward) => Padding(
                              padding: const EdgeInsets.symmetric(vertical: 4),
                              child: Row(
                                children: [
                                  const Icon(
                                    Icons.workspace_premium,
                                    size: 19,
                                    color: Color(0xFFD97706),
                                  ),
                                  const SizedBox(width: 8),
                                  Expanded(child: Text(reward)),
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ]),
            ),
          ),
        ],
      ),
      bottomNavigationBar: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Row(
            children: [
              if (!registered && !full) ...[
                Expanded(
                  child: Text(
                    program.startsInDays == 0
                        ? 'Starts today'
                        : 'Starts in ${program.startsInDays} ${program.startsInDays == 1 ? 'day' : 'days'}',
                    style: const TextStyle(
                      color: AppColors.indigo,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ),
                const SizedBox(width: 12),
              ],
              Expanded(
                flex: 2,
                child: ElevatedButton(
                  onPressed: (registered || full)
                      ? null
                      : () {
                          provider.register(program);
                          showDialog(
                            context: context,
                            builder: (ctx) => AlertDialog(
                              icon: const Icon(
                                Icons.check_circle,
                                color: AppColors.teal,
                                size: 48,
                              ),
                              title: const Text('Application submitted'),
                              content: Text(
                                "You're registered for ${program.title}.",
                              ),
                              actions: [
                                TextButton(
                                  onPressed: () => Navigator.pop(ctx),
                                  child: const Text('Done'),
                                ),
                              ],
                            ),
                          );
                        },
                  child: Text(
                    registered
                        ? 'Applied ✓'
                        : full
                        ? 'Cohort full'
                        : 'Apply now',
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

const _bodyStyle = TextStyle(color: AppColors.muted, height: 1.5);

class _Section extends StatelessWidget {
  final String title;
  final Widget child;
  const _Section({required this.title, required this.child});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 26),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: const TextStyle(fontSize: 19, fontWeight: FontWeight.w700),
          ),
          const SizedBox(height: 10),
          child,
        ],
      ),
    );
  }
}

class _Fact extends StatelessWidget {
  final IconData icon;
  final String label;
  const _Fact({required this.icon, required this.label});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppColors.border),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 18, color: AppColors.indigo),
          const SizedBox(width: 7),
          Text(label),
        ],
      ),
    );
  }
}

class _BulletList extends StatelessWidget {
  final List<String> items;
  final IconData icon;
  const _BulletList(this.items, {this.icon = Icons.check_circle});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: items
          .map(
            (item) => Padding(
              padding: const EdgeInsets.symmetric(vertical: 5),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Icon(icon, size: 19, color: AppColors.teal),
                  const SizedBox(width: 9),
                  Expanded(child: Text(item, style: _bodyStyle)),
                ],
              ),
            ),
          )
          .toList(),
    );
  }
}

class _Callout extends StatelessWidget {
  final IconData icon;
  final String text;
  const _Callout({required this.icon, required this.text});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: const Color(0xFFEEF2FF),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        children: [
          Icon(icon, color: AppColors.indigo),
          const SizedBox(width: 10),
          Expanded(child: Text(text, style: _bodyStyle)),
        ],
      ),
    );
  }
}

class _PathItem extends StatelessWidget {
  final int number;
  final String title;
  final String description;
  final bool isLast;
  const _PathItem({
    required this.number,
    required this.title,
    required this.description,
    required this.isLast,
  });

  @override
  Widget build(BuildContext context) {
    return IntrinsicHeight(
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Column(
            children: [
              CircleAvatar(
                radius: 15,
                backgroundColor: AppColors.indigo,
                child: Text(
                  '$number',
                  style: const TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
              if (!isLast)
                Expanded(child: Container(width: 2, color: AppColors.lavender)),
            ],
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.only(bottom: 18),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: const TextStyle(fontWeight: FontWeight.w700),
                  ),
                  const SizedBox(height: 3),
                  Text(description, style: _bodyStyle),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _DateTable extends StatelessWidget {
  final String lastDateToApply;
  final String startDate;
  final String endDate;
  const _DateTable({
    required this.lastDateToApply,
    required this.startDate,
    required this.endDate,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppColors.border),
      ),
      child: Column(
        children: [
          _DateRow(label: 'Last date to apply', value: lastDateToApply),
          _DateRow(label: 'Start date', value: startDate),
          _DateRow(label: 'End date', value: endDate),
        ],
      ),
    );
  }
}

class _DateRow extends StatelessWidget {
  final String label;
  final String value;
  const _DateRow({required this.label, required this.value});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
      child: Row(
        children: [
          Expanded(child: Text(label, style: _bodyStyle)),
          Text(value, style: const TextStyle(fontWeight: FontWeight.w700)),
        ],
      ),
    );
  }
}
