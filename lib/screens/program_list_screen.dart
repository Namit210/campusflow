import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/program_provider.dart';
import '../utils/theme.dart';
import '../widgets/program_card.dart';
import 'program_details_screen.dart';

class ProgramListScreen extends StatelessWidget {
  const ProgramListScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<ProgramProvider>();
    final programs = provider.filteredPrograms;

    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Programs',
          style: TextStyle(fontWeight: FontWeight.w800),
        ),
      ),
      body: Column(
        children: [
          Center(
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 760),
              child: Padding(
                padding: const EdgeInsets.fromLTRB(16, 8, 16, 8),
                child: TextField(
                  onChanged: provider.setQuery,
                  decoration: const InputDecoration(
                    hintText: 'Search programs...',
                    prefixIcon: Icon(Icons.search),
                  ),
                ),
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
                  labelStyle: TextStyle(
                    color: selected ? Colors.white : AppColors.navy,
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
                ? const Center(
                    child: Text(
                      'No programs found',
                      style: TextStyle(color: AppColors.muted),
                    ),
                  )
                : ListView.builder(
                    padding: const EdgeInsets.fromLTRB(16, 8, 16, 16),
                    itemCount: programs.length,
                    itemBuilder: (context, i) {
                      return Center(
                        child: ConstrainedBox(
                          constraints: const BoxConstraints(maxWidth: 760),
                          child: ProgramCard(
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
                      );
                    },
                  ),
          ),
        ],
      ),
    );
  }
}
