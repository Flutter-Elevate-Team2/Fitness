import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:fitness_app/Features/auth/presentation/sign_up/views/screens/activity_screen.dart';
import 'package:fitness_app/Features/auth/presentation/sign_up/views/widgets/custom_selection_tile.dart';
import 'package:fitness_app/Features/auth/presentation/sign_up/views/widgets/custom_step_progress.dart';
import 'package:fitness_app/core/l10n/app_localizations.dart';

void main() {
  group('ActivityScreen', () {
    Widget buildWidget({
      int currentStep = 6,
      ValueChanged<String>? onNextStep,
      VoidCallback? onBackButtonPressed,
    }) {
      return MaterialApp(
        localizationsDelegates: AppLocalizations.localizationsDelegates,
        supportedLocales: AppLocalizations.supportedLocales,
        locale: const Locale('en'),
        home: ActivityScreen(
          currentStep: currentStep,
          onNextStep: onNextStep ?? (_) {},
          onBackButtonPressed: onBackButtonPressed ?? () {},
        ),
      );
    }

    testWidgets('displays the title text', (WidgetTester tester) async {
      await tester.pumpWidget(buildWidget());
      await tester.pumpAndSettle();

      expect(
        find.text('YOUR REGULAR PHYSICAL ACTIVITY LEVEL ?'),
        findsOneWidget,
      );
    });

    testWidgets('displays subtitle text', (WidgetTester tester) async {
      await tester.pumpWidget(buildWidget());
      await tester.pumpAndSettle();

      expect(
        find.text('This Helps Us Create Your Personalized Plan'),
        findsOneWidget,
      );
    });

    testWidgets('displays five activity options as CustomSelectionTiles',
        (WidgetTester tester) async {
      await tester.pumpWidget(buildWidget());
      await tester.pumpAndSettle();

      expect(find.byType(CustomSelectionTile), findsNWidgets(5));
    });

    testWidgets('displays all activity labels', (WidgetTester tester) async {
      await tester.pumpWidget(buildWidget());
      await tester.pumpAndSettle();

      expect(find.text('Rookie'), findsOneWidget);
      expect(find.text('Beginner'), findsOneWidget);
      expect(find.text('Intermediate'), findsOneWidget);
      expect(find.text('Advance'), findsOneWidget);
      expect(find.text('True Beast'), findsOneWidget);
    });

    testWidgets('displays step indicator', (WidgetTester tester) async {
      await tester.pumpWidget(buildWidget(currentStep: 6));
      await tester.pumpAndSettle();

      expect(find.byType(CustomStepProgress), findsOneWidget);
    });

    testWidgets('Next button is disabled when no activity is selected',
        (WidgetTester tester) async {
      String? selected;

      await tester.pumpWidget(
        buildWidget(onNextStep: (a) => selected = a),
      );
      final nextButton = find.text('Next');
      await tester.ensureVisible(nextButton);
      await tester.pumpAndSettle();
      await tester.tap(nextButton);
      await tester.pumpAndSettle();

      expect(selected, isNull);
    });

    testWidgets(
        'selecting an activity then pressing Next calls onNextStep with API key',
        (WidgetTester tester) async {
      String? selected;

      await tester.pumpWidget(
        buildWidget(onNextStep: (a) => selected = a),
      );
      await tester.pumpAndSettle();

      // Tap Rookie (index 0 → level1)
      await tester.tap(find.text('Rookie'));
      await tester.pumpAndSettle();

      final nextButton = find.text('Next');
      await tester.ensureVisible(nextButton);
      await tester.pumpAndSettle();
      await tester.tap(nextButton);
      await tester.pumpAndSettle();

      expect(selected, 'level1');
    });

    testWidgets('selecting Intermediate maps to level3',
        (WidgetTester tester) async {
      String? selected;

      await tester.pumpWidget(
        buildWidget(onNextStep: (a) => selected = a),
      );
      await tester.pumpAndSettle();

      await tester.tap(find.text('Intermediate'));
      await tester.pumpAndSettle();

      final nextButton = find.text('Next');
      await tester.ensureVisible(nextButton);
      await tester.pumpAndSettle();
      await tester.tap(nextButton);
      await tester.pumpAndSettle();

      expect(selected, 'level3');
    });

    testWidgets('tapping a selected activity deselects it',
        (WidgetTester tester) async {
      String? selected;

      await tester.pumpWidget(
        buildWidget(onNextStep: (a) => selected = a),
      );
      await tester.pumpAndSettle();

      // Select
      await tester.tap(find.text('Beginner'));
      await tester.pumpAndSettle();

      // Deselect
      await tester.tap(find.text('Beginner'));
      await tester.pumpAndSettle();

      final nextButton = find.text('Next');
      await tester.ensureVisible(nextButton);
      await tester.pumpAndSettle();
      await tester.tap(nextButton);
      await tester.pumpAndSettle();

      expect(selected, isNull);
    });
  });
}
