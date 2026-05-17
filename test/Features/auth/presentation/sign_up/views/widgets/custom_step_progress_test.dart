import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:fitness_app/Features/auth/presentation/sign_up/views/widgets/custom_step_progress.dart';
import 'package:fitness_app/core/theming/app_colors.dart';

void main() {
  group('CustomStepProgress', () {
    testWidgets('displays current step and total steps text',
        (WidgetTester tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: CustomStepProgress(currentStep: 3, totalSteps: 6),
          ),
        ),
      );

      expect(find.text('3/6'), findsOneWidget);
    });

    testWidgets('renders CircularProgressIndicator with correct value',
        (WidgetTester tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: CustomStepProgress(currentStep: 2, totalSteps: 6),
          ),
        ),
      );

      final indicator = tester.widget<CircularProgressIndicator>(
        find.byType(CircularProgressIndicator),
      );
      expect(indicator.value, closeTo(2 / 6, 0.001));
      expect(indicator.color, AppColors.primary);
    });

    testWidgets('defaults totalSteps to 6', (WidgetTester tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: CustomStepProgress(currentStep: 1),
          ),
        ),
      );

      expect(find.text('1/6'), findsOneWidget);
    });

    testWidgets('step 0 shows 0% progress', (WidgetTester tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: CustomStepProgress(currentStep: 0, totalSteps: 6),
          ),
        ),
      );

      final indicator = tester.widget<CircularProgressIndicator>(
        find.byType(CircularProgressIndicator),
      );
      expect(indicator.value, 0.0);
    });

    testWidgets('full progress shows 100%', (WidgetTester tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: CustomStepProgress(currentStep: 6, totalSteps: 6),
          ),
        ),
      );

      final indicator = tester.widget<CircularProgressIndicator>(
        find.byType(CircularProgressIndicator),
      );
      expect(indicator.value, 1.0);
    });
  });
}
