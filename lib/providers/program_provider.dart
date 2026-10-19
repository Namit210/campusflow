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
      imageUrl:
          'https://images.unsplash.com/photo-1556761175-b413da4baf72?w=1200',
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
      whatYouWillDo: [
        'Work in teams to understand real user needs',
        'Turn observations into clear problem statements',
        'Build and test a low-fidelity prototype',
      ],
      recommendation:
          'Recommended for students who enjoy solving open-ended problems.',
      duration: '1 day',
      fee: 'Free',
      supportedBy: 'Campus Innovation Lab',
      startsInDays: 0,
      learningPath: [
        'Discover user needs',
        'Define the challenge',
        'Prototype and present',
      ],
      lastDateToApply: 'Oct 14, 2026',
      startDate: 'Oct 15, 2026',
      endDate: 'Oct 15, 2026',
      completionRewards: ['Certificate of completion', 'Innovation Lab badge'],
      eligibility: [
        'Open to all enrolled students',
        'No prior experience required',
      ],
      icon: Icons.lightbulb_outline,
      color: Color(0xFFCF491D),
      progress: 47,
      institution: 'Saint Louis University',
      institutionShort: 'SLU',
      nextSubmission: 'Nov 5, 2026, 15:00',
    ),
    Program(
      id: '2',
      title: 'Campus Innovation Day',
      tagline: 'Ideas. People. Impact.',
      imageUrl:
          'https://images.unsplash.com/photo-1497366754035-f200968a6e72?w=1200',
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
      whatYouWillDo: [
        'Explore student projects and live demos',
        'Ask questions during expert talks',
        'Meet mentors and build your campus network',
      ],
      recommendation:
          'A great fit if you want inspiration and connections across campus.',
      duration: '1 day',
      fee: 'Free',
      supportedBy: 'Office of Student Innovation',
      startsInDays: 1,
      learningPath: [
        'Explore',
        'Learn from experts',
        'Connect and collaborate',
      ],
      lastDateToApply: 'Oct 17, 2026',
      startDate: 'Oct 18, 2026',
      endDate: 'Oct 18, 2026',
      completionRewards: ['Participation certificate', 'Networking badge'],
      eligibility: ['Open to all students and recent graduates'],
      icon: Icons.rocket_launch_outlined,
      color: Color(0xFF7C3AED),
      progress: 25,
      institution: 'Rochester Institute of Technology',
      institutionShort: 'RIT',
      nextSubmission: 'Dec 31, 2026, 23:59',
    ),
    Program(
      id: '3',
      title: 'Career Skills Bootcamp',
      tagline: 'Build skills for your future.',
      imageUrl:
          'https://images.unsplash.com/photo-1521737711867-e3b97375f902?w=1200',
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
      whatYouWillDo: [
        'Create a focused, achievement-led resume',
        'Practice interview questions with feedback',
        'Improve your professional online presence',
      ],
      recommendation:
          'Recommended for students preparing for internships or placements.',
      duration: '3 hours',
      fee: 'Free',
      supportedBy: 'Career Development Cell',
      startsInDays: 5,
      learningPath: [
        'Position your strengths',
        'Practice your story',
        'Plan your next step',
      ],
      lastDateToApply: 'Oct 21, 2026',
      startDate: 'Oct 22, 2026',
      endDate: 'Oct 22, 2026',
      completionRewards: [
        'Career readiness certificate',
        'Resume review voucher',
      ],
      eligibility: ['Open to undergraduate and postgraduate students'],
      icon: Icons.work_outline,
      color: Color(0xFF14B8A6),
      progress: 11,
      institution: 'Saint Louis University',
      institutionShort: 'SLU',
      nextSubmission: 'Dec 31, 2026, 23:59',
    ),
    Program(
      id: '4',
      title: 'Tech & Product Meet',
      tagline: 'Connect. Learn. Build.',
      imageUrl:
          'https://images.unsplash.com/photo-1517245386807-bb43f82c33c4?w=1200',
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
      whatYouWillDo: [
        'Learn how teams take products from idea to launch',
        'Hear practical stories from product leaders',
        'Ask questions about careers in technology',
      ],
      recommendation:
          'Ideal for curious builders exploring product and engineering careers.',
      duration: '3 hours',
      fee: 'Free',
      supportedBy: 'Tech Community Club',
      startsInDays: 9,
      learningPath: ['Ideas and users', 'Build and ship', 'Grow your career'],
      lastDateToApply: 'Oct 25, 2026',
      startDate: 'Oct 26, 2026',
      endDate: 'Oct 26, 2026',
      completionRewards: ['Community certificate', 'Tech Connect badge'],
      eligibility: ['Open to all students interested in technology'],
      icon: Icons.devices_outlined,
      color: Color(0xFF2563EB),
    ),
    Program(
      id: '5',
      title: 'Wellness and Mindfulness',
      tagline: 'A healthier you, a brighter future.',
      imageUrl:
          'https://images.unsplash.com/photo-1506126613408-62a2a3c0b9e8?w=1200',
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
      whatYouWillDo: [
        'Practice guided breathing and mindfulness',
        'Build a realistic routine for busy weeks',
        'Learn tools for managing academic stress',
      ],
      recommendation:
          'Recommended for anyone looking for practical ways to reset and recharge.',
      duration: '2 hours',
      fee: 'Free',
      supportedBy: 'Student Wellness Center',
      startsInDays: 13,
      learningPath: ['Pause', 'Practice', 'Create a healthy routine'],
      lastDateToApply: 'Oct 29, 2026',
      startDate: 'Oct 30, 2026',
      endDate: 'Oct 30, 2026',
      completionRewards: [
        'Wellness participation certificate',
        'Mindful Campus badge',
      ],
      eligibility: ['Open to all students and staff'],
      icon: Icons.spa_outlined,
      color: Color(0xFFEC4899),
    ),
  ];

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
