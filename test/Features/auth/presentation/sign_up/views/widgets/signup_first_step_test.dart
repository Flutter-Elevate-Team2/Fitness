import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:fitness_app/Features/auth/presentation/sign_up/views/widgets/signup_first_step.dart';
import 'package:fitness_app/Features/auth/presentation/sign_up/views/widgets/social_login_row.dart';
import 'package:fitness_app/core/widget/pill_text_form_field.dart';
import 'package:fitness_app/core/l10n/app_localizations.dart';

void main() {
  group('SignupFirstStep', () {
    late TextEditingController firstNameCtrl;
    late TextEditingController lastNameCtrl;
    late TextEditingController emailCtrl;
    late TextEditingController passwordCtrl;

    setUp(() {
      firstNameCtrl = TextEditingController();
      lastNameCtrl = TextEditingController();
      emailCtrl = TextEditingController();
      passwordCtrl = TextEditingController();
    });

    tearDown(() {
      firstNameCtrl.dispose();
      lastNameCtrl.dispose();
      emailCtrl.dispose();
      passwordCtrl.dispose();
    });

    Widget buildWidget({VoidCallback? onNextStep}) {
      return MaterialApp(
        localizationsDelegates: AppLocalizations.localizationsDelegates,
        supportedLocales: AppLocalizations.supportedLocales,
        locale: const Locale('en'),
        home: SignupFirstStep(
          firstNameController: firstNameCtrl,
          lastNameController: lastNameCtrl,
          emailController: emailCtrl,
          passwordController: passwordCtrl,
          onNextStep: onNextStep ?? () {},
        ),
      );
    }

    testWidgets('displays greeting texts', (WidgetTester tester) async {
      await tester.pumpWidget(buildWidget());
      await tester.pumpAndSettle();

      expect(find.text('Hey There'), findsOneWidget);
      expect(find.text('CREATE AN ACCOUNT'), findsOneWidget);
    });

    testWidgets('displays Register heading inside the form',
        (WidgetTester tester) async {
      await tester.pumpWidget(buildWidget());
      await tester.pumpAndSettle();

      // The "Register" text appears inside formBody as a heading
      expect(find.text('Register'), findsAtLeast(1));
    });

    testWidgets('displays four PillTextFormFields',
        (WidgetTester tester) async {
      await tester.pumpWidget(buildWidget());
      await tester.pumpAndSettle();

      expect(find.byType(PillTextFormField), findsNWidgets(4));
    });

    testWidgets('displays hint texts for all fields',
        (WidgetTester tester) async {
      await tester.pumpWidget(buildWidget());
      await tester.pumpAndSettle();

      expect(find.text('First Name'), findsOneWidget);
      expect(find.text('Last Name'), findsOneWidget);
      expect(find.text('Email'), findsOneWidget);
      expect(find.text('Password'), findsOneWidget);
    });

    testWidgets('displays SocialLoginRow', (WidgetTester tester) async {
      await tester.pumpWidget(buildWidget());
      await tester.pumpAndSettle();

      expect(find.byType(SocialLoginRow), findsOneWidget);
    });

    testWidgets('displays "Already Have An Account?" and Login link',
        (WidgetTester tester) async {
      await tester.pumpWidget(buildWidget());
      await tester.pumpAndSettle();

      expect(find.text('Already Have An Account?'), findsOneWidget);
      expect(find.text('Login'), findsOneWidget);
    });

    testWidgets('does NOT call onNextStep when form is empty (validation fails)',
        (WidgetTester tester) async {
      bool called = false;

      await tester.pumpWidget(buildWidget(onNextStep: () => called = true));
      await tester.pumpAndSettle();

      // Tap the Register button (the main CTA)
      final registerButtons = find.text('Register');
      // The first 'Register' is the heading, we need the button
      await tester.ensureVisible(registerButtons.last);
      await tester.pumpAndSettle();
      await tester.tap(registerButtons.last);
      await tester.pumpAndSettle();

      // Validation should fail because all fields are empty
      expect(called, isFalse);
    });

    testWidgets('typing in fields updates controllers',
        (WidgetTester tester) async {
      await tester.pumpWidget(buildWidget());
      await tester.pumpAndSettle();

      // Enter text into the first name field
      final firstNameField = find.byType(TextFormField).first;
      await tester.enterText(firstNameField, 'Ahmed');
      expect(firstNameCtrl.text, 'Ahmed');
    });
  });
}
