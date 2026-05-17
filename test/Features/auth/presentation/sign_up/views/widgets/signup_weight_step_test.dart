import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:fitness_app/Features/auth/presentation/sign_up/views/widgets/signup_weight_step.dart';
import 'package:fitness_app/Features/auth/presentation/sign_up/views/widgets/horizontal_number_picker.dart';
import 'package:fitness_app/Features/auth/presentation/sign_up/views/widgets/custom_step_progress.dart';
import 'package:fitness_app/core/l10n/app_localizations.dart';

void main() {
  group('SignupWeightStep', () {
    Widget buildWidget({
      int selectedWeight = 70,
      int currentStep = 3,
      ValueChanged<int>? onWeightChanged,
      VoidCallback? onNextStep,
      VoidCallback? onBackButtonPressed,
    }) {
      return MaterialApp(
        localizationsDelegates: AppLocalizations.localizationsDelegates,
        supportedLocales: AppLocalizations.supportedLocales,
        locale: const Locale('en'),
        home: SignupWeightStep(
          selectedWeight: selectedWeight,
          currentStep: currentStep,
          onWeightChanged: onWeightChanged ?? (_) {},
          onNextStep: onNextStep ?? () {},
          onBackButtonPressed: onBackButtonPressed ?? () {},
        ),
      );
    }

    testWidgets('displays the title text', (WidgetTester tester) async {
      await tester.pumpWidget(buildWidget());
      await tester.pumpAndSettle();

      expect(find.text('WHAT IS YOUR WEIGHT ?'), findsOneWidget);
    });

    testWidgets('displays subtitle', (WidgetTester tester) async {
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

    testWidgets('displays Kg unit label', (WidgetTester tester) async {
      await tester.pumpWidget(buildWidget());
      await tester.pumpAndSettle();

      expect(find.text('Kg'), findsOneWidget);
    });

    testWidgets('displays step indicator', (WidgetTester tester) async {
      await tester.pumpWidget(buildWidget(currentStep: 4));
      await tester.pumpAndSettle();

      expect(find.byType(CustomStepProgress), findsOneWidget);
    });

    testWidgets('displays "Done" button', (WidgetTester tester) async {
      await tester.pumpWidget(buildWidget());
      await tester.pumpAndSettle();

      expect(find.text('Done'), findsOneWidget);
    });

    testWidgets('calls onNextStep when Done button is pressed',
        (WidgetTester tester) async {
      bool pressed = false;

      await tester.pumpWidget(buildWidget(onNextStep: () => pressed = true));
      await tester.pumpAndSettle();

      await tester.tap(find.text('Done'));
      await tester.pumpAndSettle();

      expect(pressed, isTrue);
    });
  });
}
