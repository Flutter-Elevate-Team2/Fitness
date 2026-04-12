import 'package:fitness_app/Features/auth/presentation/login/views/widgets/login_form.dart';
import 'package:fitness_app/Features/auth/presentation/login/views/widgets/email_field.dart';
import 'package:fitness_app/Features/auth/presentation/login/views/widgets/password_field.dart';
import 'package:fitness_app/core/l10n/app_localizations.dart';
import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  late TextEditingController emailController;
  late TextEditingController passwordController;

  setUp(() {
    emailController = TextEditingController();
    passwordController = TextEditingController();
  });

  tearDown(() {
    emailController.dispose();
    passwordController.dispose();
  });

  Widget createTestableWidget() {
    return MaterialApp(
      localizationsDelegates: const [
        AppLocalizations.delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      supportedLocales: const [Locale('en')],
      home: Scaffold(
        body: LoginForm(
          emailController: emailController,
          passwordController: passwordController,
        ),
      ),
    );
  }

  group('LoginForm Widget Tests', () {
    testWidgets('should render all UI components correctly', (tester) async {
      await tester.pumpWidget(createTestableWidget());

      expect(find.text('Login'), findsOneWidget);
      expect(find.text('Or'), findsOneWidget);
      expect(find.byType(TextButton), findsOneWidget);

      expect(find.byType(EmailField), findsOneWidget);
      expect(find.byType(PasswordField), findsOneWidget);

      expect(find.byIcon(Icons.facebook), findsOneWidget);
      expect(find.byIcon(Icons.g_mobiledata), findsOneWidget);
      expect(find.byIcon(Icons.apple), findsOneWidget);
    });

    testWidgets('should update controllers when text is entered in fields', (
      tester,
    ) async {
      await tester.pumpWidget(createTestableWidget());

      await tester.enterText(find.byType(EmailField), 'test@example.com');
      expect(emailController.text, 'test@example.com');

      await tester.enterText(find.byType(PasswordField), 'Password123');
      expect(passwordController.text, 'Password123');
    });

    testWidgets('social icons should be interactable (GestureDetector check)', (
      tester,
    ) async {
      await tester.pumpWidget(createTestableWidget());

      final socialIcons = find.byType(GestureDetector);

      expect(socialIcons, findsAtLeastNWidgets(3));

      await tester.tap(find.byIcon(Icons.facebook));
      await tester.tap(find.byIcon(Icons.g_mobiledata));
      await tester.tap(find.byIcon(Icons.apple));
      await tester.pump();
    });
  });
}
