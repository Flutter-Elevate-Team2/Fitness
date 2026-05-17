import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:fitness_app/Features/auth/presentation/sign_up/views/screens/goal_screen.dart';
import 'package:fitness_app/Features/auth/presentation/sign_up/views/widgets/custom_selection_tile.dart';
import 'package:fitness_app/Features/auth/presentation/sign_up/views/widgets/custom_step_progress.dart';
import 'package:fitness_app/core/l10n/app_localizations.dart';

void main() {
  group('GoalScreen', () {
    Widget buildWidget({
      int currentStep = 5,
      ValueChanged<String>? onNextStep,
      VoidCallback? onBackButtonPressed,
    }) {
      return MaterialApp(
        localizationsDelegates: AppLocalizations.localizationsDelegates,
        supportedLocales: AppLocalizations.supportedLocales,
        locale: const Locale('en'),
        home: GoalScreen(
          currentStep: currentStep,
          onNextStep: onNextStep ?? (_) {},
          onBackButtonPressed: onBackButtonPressed ?? () {},
        ),
      );
    }

    testWidgets('displays the title text', (WidgetTester tester) async {
      await tester.pumpWidget(buildWidget());
      await tester.pumpAndSettle();

      expect(find.text('WHAT IS YOUR GOAL ?'), findsOneWidget);
    });

    testWidgets('displays subtitle text', (WidgetTester tester) async {
      await tester.pumpWidget(buildWidget());
      await tester.pumpAndSettle();

      expect(
        find.text('This Helps Us Create Your Personalized Plan'),
        findsOneWidget,
      );
    });

    testWidgets('displays five goal options as CustomSelectionTiles',
        (WidgetTester tester) async {
      await tester.pumpWidget(buildWidget());
      await tester.pumpAndSettle();

      expect(find.byType(CustomSelectionTile), findsNWidgets(5));
    });

    testWidgets('displays all goal labels', (WidgetTester tester) async {
      await tester.pumpWidget(buildWidget());
      await tester.pumpAndSettle();

      expect(find.text('Gain Weight'), findsOneWidget);
      expect(find.text('Lose Weight'), findsOneWidget);
      expect(find.text('Get Fitter'), findsOneWidget);
      expect(find.text('Gain More Flexible'), findsOneWidget);
      expect(find.text('Learn The Basic'), findsOneWidget);
    });

    testWidgets('displays step indicator', (WidgetTester tester) async {
      await tester.pumpWidget(buildWidget(currentStep: 5));
      await tester.pumpAndSettle();

      expect(find.byType(CustomStepProgress), findsOneWidget);
    });

    testWidgets('Next button is disabled when no goal is selected',
        (WidgetTester tester) async {
      String? selectedGoal;

      await tester.pumpWidget(
        buildWidget(onNextStep: (g) => selectedGoal = g),
      );
      await tester.pumpAndSettle();

      final nextButton = find.text('Next');
      await tester.ensureVisible(nextButton);
      await tester.pumpAndSettle();
      await tester.tap(nextButton);
      await tester.pumpAndSettle();

      // Button is disabled so callback should not fire
      expect(selectedGoal, isNull);
    });

    testWidgets('selecting a goal then pressing Next calls onNextStep',
        (WidgetTester tester) async {
      String? selectedGoal;

      await tester.pumpWidget(
        buildWidget(onNextStep: (g) => selectedGoal = g),
      );
      await tester.pumpAndSettle();

      // Tap the first goal: "Gain Weight"
      await tester.tap(find.text('Gain Weight'));
      await tester.pumpAndSettle();

      // Now tap Next
      final nextButton = find.text('Next');
      await tester.ensureVisible(nextButton);
      await tester.pumpAndSettle();
      await tester.tap(nextButton);
      await tester.pumpAndSettle();

      expect(selectedGoal, 'gain_weight');
    });

    testWidgets('tapping a selected goal deselects it',
        (WidgetTester tester) async {
      String? selectedGoal;

      await tester.pumpWidget(
        buildWidget(onNextStep: (g) => selectedGoal = g),
      );
      await tester.pumpAndSettle();

      // Select "Lose Weight"
      await tester.tap(find.text('Lose Weight'));
      await tester.pumpAndSettle();

      // Deselect by tapping again
      await tester.tap(find.text('Lose Weight'));
      await tester.pumpAndSettle();

      // Now Next should be disabled again
      final nextButton = find.text('Next');
      await tester.ensureVisible(nextButton);
      await tester.pumpAndSettle();
      await tester.tap(nextButton);
      await tester.pumpAndSettle();

      expect(selectedGoal, isNull);
    });
  });
}
