import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:fitness_app/Features/auth/presentation/sign_up/views/widgets/signup_gender_step.dart';
import 'package:fitness_app/Features/auth/presentation/sign_up/views/widgets/gender_selection_button.dart';
import 'package:fitness_app/Features/auth/presentation/sign_up/views/widgets/custom_step_progress.dart';
import 'package:fitness_app/core/l10n/app_localizations.dart';

void main() {
  group('SignupGenderStep', () {
    Widget buildWidget({
      String? selectedGender,
      int currentStep = 1,
      ValueChanged<String>? onGenderSelected,
      VoidCallback? onNextStep,
      VoidCallback? onBackButtonPressed,
    }) {
      return MaterialApp(
        localizationsDelegates: AppLocalizations.localizationsDelegates,
        supportedLocales: AppLocalizations.supportedLocales,
        locale: const Locale('en'),
        home: SignupGenderStep(
          selectedGender: selectedGender,
          currentStep: currentStep,
          onGenderSelected: onGenderSelected ?? (_) {},
          onNextStep: onNextStep ?? () {},
          onBackButtonPressed: onBackButtonPressed ?? () {},
        ),
      );
    }

    testWidgets('displays the title text', (WidgetTester tester) async {
      await tester.pumpWidget(buildWidget());
      await tester.pumpAndSettle();

      expect(find.text('TELL US ABOUT YOURSELF!'), findsOneWidget);
    });

    testWidgets('displays subtitle text', (WidgetTester tester) async {
      await tester.pumpWidget(buildWidget());
      await tester.pumpAndSettle();

      expect(find.text('We Need To Know Your Gender'), findsOneWidget);
    });

    testWidgets('displays two GenderSelectionButtons',
        (WidgetTester tester) async {
      await tester.pumpWidget(buildWidget());
      await tester.pumpAndSettle();

      expect(find.byType(GenderSelectionButton), findsNWidgets(2));
    });

    testWidgets('displays Male and Female labels',
        (WidgetTester tester) async {
      await tester.pumpWidget(buildWidget());
      await tester.pumpAndSettle();

      expect(find.text('Male'), findsOneWidget);
      expect(find.text('Female'), findsOneWidget);
    });

    testWidgets('displays step indicator', (WidgetTester tester) async {
      await tester.pumpWidget(buildWidget(currentStep: 1));
      await tester.pumpAndSettle();

      expect(find.byType(CustomStepProgress), findsOneWidget);
    });

    testWidgets('calls onGenderSelected with "male" when Male is tapped',
        (WidgetTester tester) async {
      String? selected;

      await tester.pumpWidget(
        buildWidget(onGenderSelected: (g) => selected = g),
      );
      await tester.pumpAndSettle();

      await tester.tap(find.text('Male'));
      expect(selected, 'male');
    });

    testWidgets('calls onGenderSelected with "female" when Female is tapped',
        (WidgetTester tester) async {
      String? selected;

      await tester.pumpWidget(
        buildWidget(onGenderSelected: (g) => selected = g),
      );
      await tester.pumpAndSettle();

      await tester.tap(find.text('Female'));
      expect(selected, 'female');
    });

    testWidgets('Next button is disabled when no gender is selected',
        (WidgetTester tester) async {
      bool pressed = false;

      await tester.pumpWidget(
        buildWidget(
          selectedGender: null,
          onNextStep: () => pressed = true,
        ),
      );
      await tester.pumpAndSettle();

      final nextButton = find.text('Next');
      await tester.ensureVisible(nextButton);
      await tester.pumpAndSettle();
      await tester.tap(nextButton);
      await tester.pumpAndSettle();

      // onPressed is null so callback should NOT fire
      expect(pressed, isFalse);
    });

    testWidgets('Next button is enabled when a gender is selected',
        (WidgetTester tester) async {
      bool pressed = false;

      await tester.pumpWidget(
        buildWidget(
          selectedGender: 'male',
          onNextStep: () => pressed = true,
        ),
      );
      await tester.pumpAndSettle();

      final nextButton = find.text('Next');
      await tester.ensureVisible(nextButton);
      await tester.pumpAndSettle();
      await tester.tap(nextButton);
      await tester.pumpAndSettle();

      expect(pressed, isTrue);
    });
  });
}
