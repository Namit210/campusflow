import 'package:flutter/material.dart';

import '../models/app_notification.dart';
import '../models/feedback_entry.dart';
import '../models/program.dart';
import '../services/program_service.dart';

class ProgramProvider extends ChangeNotifier {
  final ProgramService _service;

  ProgramProvider({ProgramService? service})
      : _service = service ?? ProgramService() {
    loadPrograms();
  }

  // ---------------------------------------------------------------------
  // Programs (loaded from assets/data/programs.json)
  // ---------------------------------------------------------------------
  List<Program> _programs = [];
  bool _isLoading = true;
  String? _error;
  bool _disposed = false;

  bool get isLoading => _isLoading;
  String? get error => _error;

  /// Loads the programs. Used on start-up and by the Retry button.
  Future<void> loadPrograms() async {
    _isLoading = true;
    _error = null;
    _safeNotify();
    try {
      _programs = await _service.fetchPrograms();
    } catch (e) {
      _error = 'We could not load the programs. Please try again.';
    }
    _isLoading = false;
    _safeNotify();
  }

  void _safeNotify() {
    if (!_disposed) notifyListeners();
  }

  @override
  void dispose() {
    _disposed = true;
    super.dispose();
  }

  final List<String> categories = const [
    'All',
    'Workshop',
    'Seminar',
    'Career',
  ];

  final List<AppNotification> _notifications = [
    AppNotification(
      id: 'n1',
      title: 'Event Registration Confirmed',
      message: 'You are registered for Design Thinking Workshop on Oct 15, 2026.',
      timeAgo: '2h ago',
      icon: Icons.event_available_outlined,
    ),
    AppNotification(
      id: 'n2',
      title: 'New Announcement',
      message: "Campus Innovation Day is next week. Don't forget to register!",
      timeAgo: '5h ago',
      icon: Icons.campaign_outlined,
    ),
    AppNotification(
      id: 'n3',
      title: 'Feedback Request',
      message: "We'd love to hear your thoughts about the Career Skills Bootcamp.",
      timeAgo: '1d ago',
      icon: Icons.rate_review_outlined,
    ),
    AppNotification(
      id: 'n4',
      title: 'Event Reminder',
      message: 'Tech & Product Meet is tomorrow at 4:00 PM.',
      timeAgo: '1d ago',
      icon: Icons.notifications_active_outlined,
      read: true,
    ),
    AppNotification(
      id: 'n5',
      title: 'Program Update',
      message: 'New resources were added to the AI & Future Skills program.',
      timeAgo: '2d ago',
      icon: Icons.menu_book_outlined,
      read: true,
    ),
  ];

  final Set<String> _registeredIds = {};
  final List<FeedbackEntry> _feedback = [];
  String _selectedCategory = 'All';
  String _query = '';

  List<Program> get allPrograms => _programs;
  String get selectedCategory => _selectedCategory;

  List<Program> get filteredPrograms {
    return _programs.where((p) {
      final matchesCategory =
          _selectedCategory == 'All' || p.category == _selectedCategory;
      final matchesQuery = p.title.toLowerCase().contains(_query.toLowerCase());
      return matchesCategory && matchesQuery;
    }).toList();
  }

  // ---------------------------------------------------------------------
  // Feedback
  // ---------------------------------------------------------------------
  List<FeedbackEntry> get feedbackEntries => List.unmodifiable(_feedback);

  void addFeedback(FeedbackEntry entry) {
    _feedback.add(entry);
    notifyListeners();
  }

  // ---------------------------------------------------------------------
  // Notifications
  // ---------------------------------------------------------------------
  List<AppNotification> get notifications => List.unmodifiable(_notifications);

  int get unreadCount => _notifications.where((n) => !n.read).length;

  void markRead(String id) {
    for (final n in _notifications) {
      if (n.id == id && !n.read) {
        n.read = true;
        notifyListeners();
      }
    }
  }

  void markAllRead() {
    for (final n in _notifications) {
      n.read = true;
    }
    notifyListeners();
  }

  // ---------------------------------------------------------------------
  // Registration
  // ---------------------------------------------------------------------
  int get registeredCount => _registeredIds.length;

  bool isRegistered(String id) => _registeredIds.contains(id);

  int seatsTaken(Program p) => p.registered + (isRegistered(p.id) ? 1 : 0);

  int spotsLeft(Program p) => p.capacity - seatsTaken(p);

  void setCategory(String category) {
    _selectedCategory = category;
    notifyListeners();
  }

  void setQuery(String query) {
    _query = query;
    notifyListeners();
  }

  void register(Program p) {
    if (!isRegistered(p.id) && spotsLeft(p) > 0) {
      _registeredIds.add(p.id);
      _notifications.insert(
        0,
        AppNotification(
          id: 'reg_${p.id}',
          title: 'Event Registration Confirmed',
          message: 'You are registered for ${p.title} on ${p.date}.',
          timeAgo: 'Just now',
          icon: Icons.event_available_outlined,
        ),
      );
      notifyListeners();
    }
  }
}
