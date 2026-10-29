// Run with: flutter test
// Note: replace "campusflow" below if your Flutter package name is different
// (see the "name:" line in pubspec.yaml).
import 'package:campusflow/main.dart';
import 'package:campusflow/models/program.dart';
import 'package:campusflow/providers/auth_provider.dart';
import 'package:campusflow/providers/program_provider.dart';
import 'package:campusflow/providers/theme_provider.dart';
import 'package:campusflow/services/program_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:provider/provider.dart';

List<Program> testPrograms = [];

Widget buildApp() => MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => AuthProvider()),
        ChangeNotifierProvider(
          create: (_) => ProgramProvider(
            service: ProgramService(delay: Duration.zero),
            initialPrograms: testPrograms,
          ),
          lazy: false,
        ),
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

void main() {
  setUpAll(() async {
    testPrograms = await ProgramService(delay: Duration.zero).fetchPrograms();
  });
  void phoneSize(WidgetTester tester) {
    tester.view.physicalSize = const Size(1170, 2532);
    tester.view.devicePixelRatio = 3.0;
  }

  testWidgets('Login shows validation errors when empty', (tester) async {
    phoneSize(tester);
    await tester.pumpWidget(buildApp());
    await tester.tap(find.text('Log in'));
    await tester.pump();
    expect(find.text('Please enter your email'), findsOneWidget);
    await tester.pumpAndSettle();
  });

  testWidgets('Login leads to Home', (tester) async {
    phoneSize(tester);
    await tester.pumpWidget(buildApp());
    await login(tester);
    expect(find.text('Upcoming Events'), findsOneWidget);
    expect(find.text('Good morning, Alex 👋'), findsOneWidget);
  });

  testWidgets('Full flow: Programs -> Details -> Register -> Confirmation',
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
}
