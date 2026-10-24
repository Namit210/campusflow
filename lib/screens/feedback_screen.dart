import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../models/feedback_entry.dart';
import '../models/program.dart';
import '../providers/program_provider.dart';
import '../utils/theme.dart';

class FeedbackScreen extends StatefulWidget {
  final Program program;
  const FeedbackScreen({super.key, required this.program});

  @override
  State<FeedbackScreen> createState() => _FeedbackScreenState();
}

class _FeedbackScreenState extends State<FeedbackScreen> {
  static const _categories = [
    'Content',
    'Speaker / Instructor',
    'Venue / Platform',
    'Organisation',
    'Other',
  ];

  final _formKey = GlobalKey<FormState>();
  final _emailCtrl = TextEditingController();
  final _commentCtrl = TextEditingController();
  int _rating = 0;
  String? _category;
  bool _ratingError = false;

  @override
  void dispose() {
    _emailCtrl.dispose();
    _commentCtrl.dispose();
    super.dispose();
  }

  void _submit() {
    final fieldsValid = _formKey.currentState!.validate();
    setState(() => _ratingError = _rating == 0);
    if (!fieldsValid || _rating == 0) return;

    context.read<ProgramProvider>().addFeedback(
          FeedbackEntry(
            programId: widget.program.id,
            rating: _rating,
            category: _category!,
            email: _emailCtrl.text.trim(),
            comment: _commentCtrl.text.trim(),
            submittedAt: DateTime.now(),
          ),
        );

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Thank you for your feedback!')),
    );
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Feedback',
            style: TextStyle(fontWeight: FontWeight.w800)),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(widget.program.title,
                  style: const TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.w800,
                      color: AppColors.navy)),
              const SizedBox(height: 4),
              const Text('How was your experience?',
                  style: TextStyle(color: AppColors.muted)),
              const SizedBox(height: 16),
              Row(
                children: List.generate(5, (i) {
                  final filled = i < _rating;
                  return IconButton(
                    padding: EdgeInsets.zero,
                    iconSize: 38,
                    onPressed: () => setState(() {
                      _rating = i + 1;
                      _ratingError = false;
                    }),
                    icon: Icon(
                      filled ? Icons.star : Icons.star_border,
                      color: filled ? Colors.amber : AppColors.muted,
                    ),
                  );
                }),
              ),
              if (_ratingError)
                const Padding(
                  padding: EdgeInsets.only(top: 4),
                  child: Text('Please select a rating',
                      style: TextStyle(color: Colors.red, fontSize: 12)),
                ),
              const SizedBox(height: 16),
              DropdownButtonFormField<String>(
                decoration: const InputDecoration(labelText: 'What is this about?'),
                items: _categories
                    .map((c) => DropdownMenuItem(value: c, child: Text(c)))
                    .toList(),
                onChanged: (v) => setState(() => _category = v),
                validator: (v) => v == null ? 'Please choose a category' : null,
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _emailCtrl,
                keyboardType: TextInputType.emailAddress,
                decoration: const InputDecoration(
                  labelText: 'Email',
                  prefixIcon: Icon(Icons.mail_outline),
                ),
                validator: (v) {
                  final value = v?.trim() ?? '';
                  if (value.isEmpty) return 'Please enter your email';
                  final ok = RegExp(r'^[^@\s]+@[^@\s]+\.[^@\s]+$').hasMatch(value);
                  return ok ? null : 'Enter a valid email address';
                },
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _commentCtrl,
                maxLines: 4,
                maxLength: 300,
                decoration: const InputDecoration(
                  labelText: 'Your feedback',
                  alignLabelWithHint: true,
                ),
                validator: (v) {
                  final value = v?.trim() ?? '';
                  if (value.isEmpty) return 'Please enter your feedback';
                  if (value.length < 10) {
                    return 'Please write at least 10 characters';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 12),
              ElevatedButton(
                onPressed: _submit,
                child: const Text('Submit feedback'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
