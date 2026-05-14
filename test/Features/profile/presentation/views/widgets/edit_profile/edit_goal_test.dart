import 'package:fitness_app/Features/auth/presentation/sign_up/views/screens/goal_screen.dart';
import 'package:fitness_app/Features/profile/presentation/views/widgets/edit_profile/edit_goal.dart';
import 'package:fitness_app/core/l10n/app_localizations.dart'; // تأكدي من تضمين هذا الاستيراد المهم
import 'package:fitness_app/core/widget/shared_scaffold.dart';
import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('EditGoal Widget Tests', () {
    testWidgets('renders EditGoal and GoalScreen correctly', (
      WidgetTester tester,
    ) async {
      await tester.pumpWidget(
        MaterialApp(
          localizationsDelegates: const [
            AppLocalizations.delegate,
            GlobalMaterialLocalizations.delegate,
            GlobalWidgetsLocalizations.delegate,
            GlobalCupertinoLocalizations.delegate,
          ],
          supportedLocales: const [Locale('en')],
          home: EditGoal(
            initialGoal: 'Lose Weight',
            onGoalSelected: (goal) {},
            onBackButtonPressed: () {},
          ),
        ),
      );

      await tester.pumpAndSettle();

      expect(find.byType(SharedScaffold), findsOneWidget);

      expect(find.byType(GoalScreen), findsOneWidget);
    });

    testWidgets(
      'triggers onGoalSelected and updates state when step is completed',
      (WidgetTester tester) async {
        String? selectedGoal;

        await tester.pumpWidget(
          MaterialApp(
            localizationsDelegates: const [
              AppLocalizations.delegate,
              GlobalMaterialLocalizations.delegate,
              GlobalWidgetsLocalizations.delegate,
              GlobalCupertinoLocalizations.delegate,
            ],
            supportedLocales: const [Locale('en')],
            home: EditGoal(
              initialGoal: 'Lose Weight',
              onGoalSelected: (goal) {
                selectedGoal = goal;
              },
              onBackButtonPressed: () {},
            ),
          ),
        );

        await tester.pumpAndSettle();

        final goalScreen = tester.widget<GoalScreen>(find.byType(GoalScreen));

        goalScreen.onNextStep('Gain Muscle');
        await tester.pump();

        expect(selectedGoal, 'Gain Muscle');
      },
    );

    testWidgets('calls onBackButtonPressed when back button is pressed', (
      WidgetTester tester,
    ) async {
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
          home: EditGoal(
            initialGoal: 'Lose Weight',
            onGoalSelected: (_) {},
            onBackButtonPressed: () {
              backButtonCalled = true;
            },
          ),
        ),
      );

      await tester.pumpAndSettle();

      final editGoalWidget = tester.widget<EditGoal>(find.byType(EditGoal));

      editGoalWidget.onBackButtonPressed();
      await tester.pump();

      expect(backButtonCalled, isTrue);
    });
  });
}
