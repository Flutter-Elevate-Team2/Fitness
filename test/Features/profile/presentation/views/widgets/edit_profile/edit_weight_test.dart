import 'package:fitness_app/Features/profile/presentation/views/widgets/edit_profile/edit_weight.dart';
import 'package:fitness_app/Features/profile/presentation/views/widgets/edit_profile/edit_weight_step.dart';
import 'package:fitness_app/core/l10n/app_localizations.dart';
import 'package:fitness_app/core/widget/shared_scaffold.dart';
import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('EditWeightScreen Widget Tests', () {
    testWidgets('renders EditWeightScreen and its children correctly', (
      WidgetTester tester,
    ) async {
      int currentWeight = 65;

      await tester.pumpWidget(
        MaterialApp(
          localizationsDelegates: const [
            AppLocalizations.delegate,
            GlobalMaterialLocalizations.delegate,
            GlobalWidgetsLocalizations.delegate,
            GlobalCupertinoLocalizations.delegate,
          ],
          supportedLocales: const [Locale('en')],
          home: EditWeightScreen(
            initialWeight: currentWeight,
            onWeightChanged: (value) {
              currentWeight = value;
            },
            onStepComplete: () {},
            onBackButtonPressed: () {},
          ),
        ),
      );

      await tester.pumpAndSettle();

      expect(find.byType(SharedScaffold), findsOneWidget);

      expect(find.byType(EditWeightStep), findsOneWidget);
    });

    testWidgets('triggers onWeightChanged callback correctly', (
      WidgetTester tester,
    ) async {
      int currentWeight = 65;

      await tester.pumpWidget(
        MaterialApp(
          localizationsDelegates: const [
            AppLocalizations.delegate,
            GlobalMaterialLocalizations.delegate,
            GlobalWidgetsLocalizations.delegate,
            GlobalCupertinoLocalizations.delegate,
          ],
          supportedLocales: const [Locale('en')],
          home: EditWeightScreen(
            initialWeight: currentWeight,
            onWeightChanged: (value) {
              currentWeight = value;
            },
            onStepComplete: () {},
            onBackButtonPressed: () {},
          ),
        ),
      );

      await tester.pumpAndSettle();

      final editWeightStep = tester.widget<EditWeightStep>(
        find.byType(EditWeightStep),
      );

      editWeightStep.onWeightChanged(90);
      await tester.pump();

      expect(currentWeight, 90);
    });

    testWidgets('triggers onStepComplete and onBackButtonPressed callbacks', (
      WidgetTester tester,
    ) async {
      bool stepCompleteCalled = false;
      bool backButtonCalled = false;

      await tester.pumpWidget(
        MaterialApp(
          localizationsDelegates: const [
            AppLocalizations.delegate,
            GlobalMaterialLocalizations.delegate,
            GlobalWidgetsLocalizations.delegate,
            GlobalCupertinoLocalizations.delegate,
          ],
          supportedLocales: const [Locale('en')],
          home: EditWeightScreen(
            initialWeight: 65,
            onWeightChanged: (_) {},
            onStepComplete: () {
              stepCompleteCalled = true;
            },
            onBackButtonPressed: () {
              backButtonCalled = true;
            },
          ),
        ),
      );

      await tester.pumpAndSettle();

      final editWeightStep = tester.widget<EditWeightStep>(
        find.byType(EditWeightStep),
      );

      editWeightStep.onNextStep();
      editWeightStep.onBackButtonPressed();
      await tester.pump();

      expect(stepCompleteCalled, isTrue);
      expect(backButtonCalled, isTrue);
    });
  });
}
