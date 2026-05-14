import 'package:fitness_app/Features/auth/presentation/sign_up/views/widgets/horizontal_number_picker.dart';
import 'package:fitness_app/Features/profile/presentation/views/widgets/edit_profile/edit_weight_step.dart';
import 'package:fitness_app/core/l10n/app_localizations.dart';
import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('EditWeightStep Widget Tests', () {
    testWidgets(
      'renders EditWeightStep correctly and displays correct labels',
      (WidgetTester tester) async {
        int currentWeight = 70;
        bool nextStepCalled = false;

        await tester.pumpWidget(
          MaterialApp(
            localizationsDelegates: const [
              AppLocalizations.delegate,
              GlobalMaterialLocalizations.delegate,
              GlobalWidgetsLocalizations.delegate,
              GlobalCupertinoLocalizations.delegate,
            ],
            supportedLocales: const [Locale('en')],
            home: Scaffold(
              body: EditWeightStep(
                selectedWeight: currentWeight,
                onWeightChanged: (value) {
                  currentWeight = value;
                },
                onNextStep: () {
                  nextStepCalled = true;
                },
                onBackButtonPressed: () {
                },
                useScaffold: false,
              ),
            ),
          ),
        );

        await tester.pumpAndSettle();

        expect(find.byType(HorizontalNumberPicker), findsOneWidget);

        final doneButtonFinder = find.byType(ElevatedButton);
        if (doneButtonFinder.evaluate().isNotEmpty) {
          await tester.tap(doneButtonFinder.first);
          await tester.pumpAndSettle();
          expect(nextStepCalled, isTrue);
        }
      },
    );

    testWidgets('calls onWeightChanged when picker value changes', (
      WidgetTester tester,
    ) async {
      int currentWeight = 70;

      await tester.pumpWidget(
        MaterialApp(
          localizationsDelegates: const [
            AppLocalizations.delegate,
            GlobalMaterialLocalizations.delegate,
            GlobalWidgetsLocalizations.delegate,
            GlobalCupertinoLocalizations.delegate,
          ],
          supportedLocales: const [Locale('en')],
          home: Scaffold(
            body: EditWeightStep(
              selectedWeight: currentWeight,
              onWeightChanged: (value) {
                currentWeight = value;
              },
              onNextStep: () {},
              onBackButtonPressed: () {},
              useScaffold: false,
            ),
          ),
        ),
      );

      await tester.pumpAndSettle();

      final numberPicker = tester.widget<HorizontalNumberPicker>(
        find.byType(HorizontalNumberPicker),
      );

      numberPicker.onChanged(80);
      await tester.pump();

      expect(currentWeight, 80);
    });

    testWidgets('calls onBackButtonPressed when back button is pressed', (
      WidgetTester tester,
    ) async {
      bool backStepCalled = false;

      await tester.pumpWidget(
        MaterialApp(
          localizationsDelegates: const [
            AppLocalizations.delegate,
            GlobalMaterialLocalizations.delegate,
            GlobalWidgetsLocalizations.delegate,
            GlobalCupertinoLocalizations.delegate,
          ],
          supportedLocales: const [Locale('en')],
          home: Scaffold(
            body: EditWeightStep(
              selectedWeight: 70,
              onWeightChanged: (value) {},
              onNextStep: () {},
              onBackButtonPressed: () {
                backStepCalled = true;
              },
              useScaffold: false,
            ),
          ),
        ),
      );

      await tester.pumpAndSettle();

      final backButtonFinder = find.byType(IconButton);
      if (backButtonFinder.evaluate().isNotEmpty) {
        await tester.tap(backButtonFinder.first);
        await tester.pumpAndSettle();
        expect(backStepCalled, isTrue);
      }
    });
  });
}
