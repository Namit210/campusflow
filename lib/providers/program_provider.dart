import 'package:flutter/material.dart';

import '../models/app_notification.dart';
import '../models/program.dart';

class ProgramProvider extends ChangeNotifier {
  // Sample data (replace with API calls to the Express backend later).
  final List<Program> _programs = const [
    Program(
      id: '1',
      title: 'Design Thinking Workshop',
      tagline: 'Build better solutions, together.',
      category: 'Workshop',
      date: 'Oct 15, 2026',
      time: '10:00 AM - 1:00 PM',
      location: 'Main Auditorium',
      capacity: 200,
      registered: 142,
      about:
          'A hands-on workshop where you learn to empathise with users, define problems and prototype ideas quickly in teams.',
      learnPoints: [
        'Empathy mapping',
        'Problem framing',
        'Rapid prototyping',
        'Presenting ideas',
      ],
      icon: Icons.lightbulb_outline,
      color: Color(0xFF4F46E5),
    ),
    Program(
      id: '2',
      title: 'Campus Innovation Day',
      tagline: 'Ideas. People. Impact.',
      category: 'Seminar',
      date: 'Oct 18, 2026',
      time: '9:00 AM - 5:00 PM',
      location: 'Innovation Center',
      capacity: 500,
      registered: 320,
      about:
          'A full-day event featuring student demos, guest talks and networking with industry mentors.',
      learnPoints: [
        'Live project demos',
        'Talks from industry mentors',
        'Networking tips',
      ],
      icon: Icons.rocket_launch_outlined,
      color: Color(0xFF7C3AED),
    ),
    Program(
      id: '3',
      title: 'Career Skills Bootcamp',
      tagline: 'Build skills for your future.',
      category: 'Career',
      date: 'Oct 22, 2026',
      time: '2:00 PM - 5:00 PM',
      location: 'Online',
      capacity: 150,
      registered: 87,
      about:
          'Practical sessions on resumes, interviews and professional communication to get you job-ready.',
      learnPoints: [
        'Writing a strong resume',
        'Interview practice',
        'LinkedIn basics',
      ],
      icon: Icons.work_outline,
      color: Color(0xFF14B8A6),
    ),
    Program(
      id: '4',
      title: 'Tech & Product Meet',
      tagline: 'Connect. Learn. Build.',
      category: 'Seminar',
      date: 'Oct 26, 2026',
      time: '4:00 PM - 7:00 PM',
      location: 'Student Center',
      capacity: 100,
      registered: 64,
      about:
          'Meet product managers and engineers, and learn how digital products go from idea to launch.',
      learnPoints: [
        'Product lifecycle',
        'Working with developers',
        'Career paths in tech',
      ],
      icon: Icons.devices_outlined,
      color: Color(0xFF2563EB),
    ),
    Program(
      id: '5',
      title: 'Wellness and Mindfulness',
      tagline: 'A healthier you, a brighter future.',
      category: 'Workshop',
      date: 'Oct 30, 2026',
      time: '10:00 AM - 12:00 PM',
      location: 'Wellness Center',
      capacity: 80,
      registered: 48,
      about:
          'Learn simple stress-management and mindfulness techniques you can use during exams and daily life.',
      learnPoints: [
        'Breathing techniques',
        'Time and stress management',
        'Building healthy routines',
      ],
      icon: Icons.spa_outlined,
      color: Color(0xFFEC4899),
    ),
  ];

  final List<String> categories = const ['All', 'Workshop', 'Seminar', 'Career'];

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
  String _selectedCategory = 'All';
  String _query = '';

  List<Program> get allPrograms => _programs;
  String get selectedCategory => _selectedCategory;

  List<Program> get filteredPrograms {
    return _programs.where((p) {
      final matchesCategory =
          _selectedCategory == 'All' || p.category == _selectedCategory;
      final matchesQuery =
          p.title.toLowerCase().contains(_query.toLowerCase());
      return matchesCategory && matchesQuery;
    }).toList();
  }

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
