// Run with: flutter test
// If your package name is not "campusflow", change it in the imports
// (see the "name:" line in pubspec.yaml).
import 'dart:io';

import 'package:campusflow/main.dart';
import 'package:campusflow/models/program.dart';
import 'package:campusflow/providers/program_provider.dart';
import 'package:campusflow/providers/theme_provider.dart';
import 'package:campusflow/widgets/hover_card.dart';
import 'package:campusflow/screens/feedback_screen.dart';
import 'package:campusflow/services/program_service.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:provider/provider.dart';

/// Reads the same JSON file the app uses, with no delay, so tests are fast.
ProgramService testService() => ProgramService(
      delay: Duration.zero,
      loader: () async =>
          File('assets/data/programs.json').readAsStringSync(),
    );

Widget buildApp() => MultiProvider(
      providers: [
        ChangeNotifierProvider(
            create: (_) => ProgramProvider(service: testService())),
        ChangeNotifierProvider(create: (_) => ThemeProvider()),
      ],
      child: const CampusFlowApp(useGoogleFonts: false),
    );

Future<void> login(WidgetTester tester) async {
  await tester.enterText(find.byType(TextFormField).at(0), 'alex@test.com');
  await tester.enterText(find.byType(TextFormField).at(1), '123456');
  await tester.tap(find.text('Log in'));
  await tester.pumpAndSettle();
}

void phoneSize(WidgetTester tester) {
  tester.view.physicalSize = const Size(1170, 2532);
  tester.view.devicePixelRatio = 3.0;
  addTearDown(tester.view.reset);

  // Tests draw text with the "Ahem" font (every letter is a wide square),
  // so rows can falsely report "RenderFlex overflowed". Real devices use
  // Inter and are fine, so we ignore only those overflow messages here.
  final original = FlutterError.onError;
  FlutterError.onError = (details) {
    if (details.exceptionAsString().contains('overflowed')) return;
    original?.call(details);
  };
  addTearDown(() => FlutterError.onError = original);
}

void main() {
  group('Data loading (JSON)', () {
    test('service loads 5 programs from programs.json', () async {
      final programs = await testService().fetchPrograms();
      expect(programs.length, 5);
      expect(programs.first.title, 'Design Thinking Workshop');
    });

    test('Program.fromJson tolerates missing fields', () {
      final p = Program.fromJson(const {'id': 'x', 'title': 'Only Title'});
      expect(p.title, 'Only Title');
      expect(p.learnPoints, isEmpty);
      expect(p.fee, 'Free');
    });

    test('provider exposes an error when loading fails', () async {
      final provider = ProgramProvider(
        service: ProgramService(
          delay: Duration.zero,
          loader: () async => throw Exception('network down'),
        ),
      );
      await provider.loadPrograms();
      expect(provider.error, isNotNull);
      expect(provider.isLoading, isFalse);
      expect(provider.allPrograms, isEmpty);
    });
  });

  group('App flow', () {
    testWidgets('Login shows validation errors when empty', (tester) async {
      phoneSize(tester);
      await tester.pumpWidget(buildApp());
      await tester.tap(find.text('Log in'));
      await tester.pump();
      expect(find.text('Please enter your email'), findsOneWidget);
    });

    testWidgets('Login leads to Home with data from JSON', (tester) async {
      phoneSize(tester);
      await tester.pumpWidget(buildApp());
      await login(tester);
      expect(find.text('Upcoming Events'), findsOneWidget);
    });

    testWidgets('Programs -> Details -> Register -> Confirmation',
        (tester) async {
      phoneSize(tester);
      await tester.pumpWidget(buildApp());
      await login(tester);

      await tester.tap(find.descendant(
          of: find.byType(NavigationBar), matching: find.text('Programs')));
      await tester.pumpAndSettle();

      await tester.tap(find.text('Design Thinking Workshop'));
      await tester.pumpAndSettle();
      expect(find.text('Register'), findsOneWidget);

      await tester.tap(find.text('Register'));
      await tester.pumpAndSettle();
      expect(find.text('Registration confirmed'), findsOneWidget);
    });

    testWidgets('Home bell opens Notifications with 3 unread', (tester) async {
      phoneSize(tester);
      await tester.pumpWidget(buildApp());
      await login(tester);

      await tester.tap(find.byIcon(Icons.notifications_outlined));
      await tester.pumpAndSettle();
      expect(find.text('Unread (3)'), findsOneWidget);
    });
  });

  group('Feedback form', () {
    Widget feedbackApp() {
      final program = Program.fromJson(const {'id': 't1', 'title': 'Test Program'});
      return ChangeNotifierProvider(
        create: (_) => ProgramProvider(service: testService()),
        child: MaterialApp(
          home: Builder(
            builder: (ctx) => Scaffold(
              body: Center(
                child: ElevatedButton(
                  onPressed: () => Navigator.push(
                    ctx,
                    MaterialPageRoute(
                        builder: (_) => FeedbackScreen(program: program)),
                  ),
                  child: const Text('open'),
                ),
              ),
            ),
          ),
        ),
      );
    }

    testWidgets('shows validation errors when submitted empty', (tester) async {
      phoneSize(tester);
      await tester.pumpWidget(feedbackApp());
      await tester.tap(find.text('open'));
      await tester.pumpAndSettle();

      await tester.ensureVisible(find.text('Submit feedback'));
      await tester.tap(find.text('Submit feedback'));
      await tester.pumpAndSettle();

      expect(find.text('Please select a rating'), findsOneWidget);
      expect(find.text('Please choose a category'), findsOneWidget);
      expect(find.text('Please enter your email'), findsOneWidget);
      expect(find.text('Please enter your feedback'), findsOneWidget);
    });

    testWidgets('rejects a short comment', (tester) async {
      phoneSize(tester);
      await tester.pumpWidget(feedbackApp());
      await tester.tap(find.text('open'));
      await tester.pumpAndSettle();

      await tester.enterText(find.byType(TextFormField).at(1), 'short');
      await tester.ensureVisible(find.text('Submit feedback'));
      await tester.tap(find.text('Submit feedback'));
      await tester.pumpAndSettle();

      expect(find.text('Please write at least 10 characters'), findsOneWidget);
    });

    testWidgets('valid form is saved and shows thank-you message',
        (tester) async {
      phoneSize(tester);
      await tester.pumpWidget(feedbackApp());
      await tester.tap(find.text('open'));
      await tester.pumpAndSettle();

      await tester.tap(find.byIcon(Icons.star_border).at(3)); // 4 stars
      await tester.pump();
      await tester.tap(find.byType(DropdownButtonFormField<String>));
      await tester.pumpAndSettle();
      await tester.tap(find.text('Content').last);
      await tester.pumpAndSettle();
      await tester.enterText(find.byType(TextFormField).at(0), 'alex@test.com');
      await tester.enterText(
          find.byType(TextFormField).at(1), 'Great session, very practical.');

      await tester.ensureVisible(find.text('Submit feedback'));
      await tester.tap(find.text('Submit feedback'));
      await tester.pumpAndSettle();

      expect(find.text('Thank you for your feedback!'), findsOneWidget);
      final provider = Provider.of<ProgramProvider>(
          tester.element(find.text('open')),
          listen: false);
      expect(provider.feedbackEntries.length, 1);
      expect(provider.feedbackEntries.first.rating, 4);
    });
  });

  group('Theme and hover', () {
    test('ThemeProvider toggles between light and dark', () {
      final theme = ThemeProvider();
      expect(theme.mode, ThemeMode.light);
      theme.toggle();
      expect(theme.mode, ThemeMode.dark);
      expect(theme.isDark, isTrue);
      theme.toggle();
      expect(theme.mode, ThemeMode.light);
    });

    testWidgets('HoverCard grows when the mouse hovers over it',
        (tester) async {
      await tester.pumpWidget(const MaterialApp(
        home: Center(child: HoverCard(child: Text('card'))),
      ));
      final gesture =
          await tester.createGesture(kind: PointerDeviceKind.mouse);
      await gesture.addPointer(location: Offset.zero);
      addTearDown(gesture.removePointer);
      await tester.pump();

      await gesture.moveTo(tester.getCenter(find.text('card')));
      await tester.pumpAndSettle();

      final scale = tester.widget<AnimatedScale>(find.byType(AnimatedScale)).scale;
      expect(scale, greaterThan(1.0));
    });
  });
}
