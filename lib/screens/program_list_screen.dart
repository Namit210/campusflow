import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/program_provider.dart';
import '../utils/context_colors.dart';
import '../utils/theme.dart';
import '../widgets/program_card.dart';
import '../widgets/state_views.dart';
import 'program_details_screen.dart';

class ProgramListScreen extends StatefulWidget {
  const ProgramListScreen({super.key});

  @override
  State<ProgramListScreen> createState() => _ProgramListScreenState();
}

class _ProgramListScreenState extends State<ProgramListScreen> {
  final _searchCtrl = TextEditingController();

  @override
  void dispose() {
    _searchCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<ProgramProvider>();

    final title = AppBar(
      title: const Text('Programs',
          style: TextStyle(fontWeight: FontWeight.w800)),
    );

    // Loading state
    if (provider.isLoading) {
      return Scaffold(appBar: title, body: const LoadingView());
    }
    // Error state
    if (provider.error != null) {
      return Scaffold(
        appBar: title,
        body: ErrorView(
          message: provider.error!,
          onRetry: provider.loadPrograms,
        ),
      );
    }

    final programs = provider.filteredPrograms;

    return Scaffold(
      appBar: title,
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 4, 16, 8),
            child: TextField(
              controller: _searchCtrl,
              onChanged: (value) {
                provider.setQuery(value);
                setState(() {});
              },
              decoration: InputDecoration(
                hintText: 'Search programs...',
                prefixIcon: const Icon(Icons.search),
                suffixIcon: _searchCtrl.text.isEmpty
                    ? null
                    : IconButton(
                        tooltip: 'Clear search',
                        icon: const Icon(Icons.close),
                        onPressed: () {
                          _searchCtrl.clear();
                          provider.setQuery('');
                          setState(() {});
                        },
                      ),
                contentPadding: const EdgeInsets.symmetric(vertical: 0),
              ),
            ),
          ),
          SizedBox(
            height: 44,
            child: ListView.separated(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              scrollDirection: Axis.horizontal,
              itemCount: provider.categories.length,
              separatorBuilder: (_, _) => const SizedBox(width: 8),
              itemBuilder: (context, i) {
                final c = provider.categories[i];
                final selected = c == provider.selectedCategory;
                return ChoiceChip(
                  label: Text(c),
                  selected: selected,
                  selectedColor: AppColors.indigo,
                  backgroundColor: context.surface,
                  side: BorderSide(color: context.borderColor),
                  labelStyle: TextStyle(
                    color: selected ? Colors.white : context.textPrimary,
                  ),
                  showCheckmark: false,
                  onSelected: (_) => provider.setCategory(c),
                );
              },
            ),
          ),
          const SizedBox(height: 8),
          Expanded(
            child: programs.isEmpty
                ? _EmptyState(
                    onClear: () {
                      _searchCtrl.clear();
                      provider.clearFilters();
                      setState(() {});
                    },
                  )
                : ListView.builder(
                    padding: const EdgeInsets.fromLTRB(16, 8, 16, 16),
                    itemCount: programs.length,
                    itemBuilder: (context, i) => ProgramCard(
                      program: programs[i],
                      onTap: () => Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) =>
                              ProgramDetailsScreen(program: programs[i]),
                        ),
                      ),
                    ),
                  ),
          ),
        ],
      ),
    );
  }
}

class _EmptyState extends StatelessWidget {
  final VoidCallback onClear;
  const _EmptyState({required this.onClear});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(Icons.search_off, size: 56, color: context.textMuted),
            const SizedBox(height: 12),
            Text(
              'No programs found',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w700,
                color: context.textPrimary,
              ),
            ),
            const SizedBox(height: 6),
            Text(
              'Try a different search or category.',
              style: TextStyle(color: context.textMuted),
            ),
            const SizedBox(height: 16),
            OutlinedButton(
              onPressed: onClear,
              child: const Text('Clear filters'),
            ),
          ],
        ),
      ),
    );
  }
}
