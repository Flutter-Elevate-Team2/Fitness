import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:fitness_app/Features/auth/presentation/sign_up/views/widgets/signup_age_step.dart';
import 'package:fitness_app/Features/auth/presentation/sign_up/views/widgets/horizontal_number_picker.dart';
import 'package:fitness_app/Features/auth/presentation/sign_up/views/widgets/custom_step_progress.dart';
import 'package:fitness_app/core/l10n/app_localizations.dart';

void main() {
  group('SignupAgeStep', () {
    Widget buildWidget({
      int selectedAge = 25,
      int currentStep = 2,
      ValueChanged<int>? onAgeChanged,
      VoidCallback? onNextStep,
      VoidCallback? onBackButtonPressed,
    }) {
      return MaterialApp(
        localizationsDelegates: AppLocalizations.localizationsDelegates,
        supportedLocales: AppLocalizations.supportedLocales,
        locale: const Locale('en'),
        home: SignupAgeStep(
          selectedAge: selectedAge,
          currentStep: currentStep,
          onAgeChanged: onAgeChanged ?? (_) {},
          onNextStep: onNextStep ?? () {},
          onBackButtonPressed: onBackButtonPressed ?? () {},
        ),
      );
    }

    testWidgets('displays the title text', (WidgetTester tester) async {
      await tester.pumpWidget(buildWidget());
      await tester.pumpAndSettle();

      // English l10n: 'HOW OLD ARE YOU ?'
      expect(find.text('HOW OLD ARE YOU ?'), findsOneWidget);
    });

    testWidgets('displays subtitle text', (WidgetTester tester) async {
      await tester.pumpWidget(buildWidget());
      await tester.pumpAndSettle();

      expect(
        find.text('This Helps Us Create Your Personalized Plan'),
        findsOneWidget,
      );
    });

    testWidgets('displays the HorizontalNumberPicker',
        (WidgetTester tester) async {
      await tester.pumpWidget(buildWidget());
      await tester.pumpAndSettle();

      expect(find.byType(HorizontalNumberPicker), findsOneWidget);
    });

    testWidgets('displays Year unit label', (WidgetTester tester) async {
      await tester.pumpWidget(buildWidget());
      await tester.pumpAndSettle();

      expect(find.text('Year'), findsOneWidget);
    });

    testWidgets('displays step indicator', (WidgetTester tester) async {
      await tester.pumpWidget(buildWidget(currentStep: 3));
      await tester.pumpAndSettle();

      expect(find.byType(CustomStepProgress), findsOneWidget);
    });

    testWidgets('displays "Next" button', (WidgetTester tester) async {
      await tester.pumpWidget(buildWidget());
      await tester.pumpAndSettle();

      expect(find.text('Next'), findsOneWidget);
    });

    testWidgets('calls onNextStep when Next button is pressed',
        (WidgetTester tester) async {
      bool pressed = false;

      await tester.pumpWidget(buildWidget(onNextStep: () => pressed = true));
      await tester.pumpAndSettle();

      await tester.tap(find.text('Next'));
      await tester.pumpAndSettle();

      expect(pressed, isTrue);
    });
  });
}
