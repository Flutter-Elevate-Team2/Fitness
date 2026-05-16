import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:fitness_app/Features/auth/presentation/sign_up/views/widgets/signup_height_step.dart';
import 'package:fitness_app/Features/auth/presentation/sign_up/views/widgets/horizontal_number_picker.dart';
import 'package:fitness_app/Features/auth/presentation/sign_up/views/widgets/custom_step_progress.dart';
import 'package:fitness_app/core/l10n/app_localizations.dart';

void main() {
  group('SignupHeightStep', () {
    Widget buildWidget({
      int selectedHeight = 170,
      int currentStep = 4,
      ValueChanged<int>? onHeightChanged,
      VoidCallback? onNextStep,
      VoidCallback? onBackButtonPressed,
    }) {
      return MaterialApp(
        localizationsDelegates: AppLocalizations.localizationsDelegates,
        supportedLocales: AppLocalizations.supportedLocales,
        locale: const Locale('en'),
        home: SignupHeightStep(
          selectedHeight: selectedHeight,
          currentStep: currentStep,
          onHeightChanged: onHeightChanged ?? (_) {},
          onNextStep: onNextStep ?? () {},
          onBackButtonPressed: onBackButtonPressed ?? () {},
        ),
      );
    }

    testWidgets('displays the title text', (WidgetTester tester) async {
      await tester.pumpWidget(buildWidget());
      await tester.pumpAndSettle();

      expect(find.text('WHAT IS YOUR HEIGHT ?'), findsOneWidget);
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

    testWidgets('displays CM unit label', (WidgetTester tester) async {
      await tester.pumpWidget(buildWidget());
      await tester.pumpAndSettle();

      expect(find.text('CM'), findsOneWidget);
    });

    testWidgets('displays step indicator', (WidgetTester tester) async {
      await tester.pumpWidget(buildWidget(currentStep: 5));
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
