import 'package:fitness_app/Features/auth/presentation/sign_up/views/screens/activity_screen.dart';
import 'package:fitness_app/Features/profile/presentation/views/widgets/edit_profile/edit_activity.dart'; // تأكدي من تعديل المسار ليطابق مكان الملف لديك
import 'package:fitness_app/core/l10n/app_localizations.dart';
import 'package:fitness_app/core/widget/shared_scaffold.dart';
import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('EditActivity Widget Tests', () {
    testWidgets('renders EditActivity and ActivityScreen correctly', (
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
          home: EditActivity(
            initialActivity: 'Lightly Active',
            onActivitySelected: (activity) {},
            onBackButtonPressed: () {},
          ),
        ),
      );

      await tester.pumpAndSettle();

      expect(find.byType(SharedScaffold), findsOneWidget);

      expect(find.byType(ActivityScreen), findsOneWidget);
    });

    testWidgets('triggers onActivitySelected when next step is completed', (
      WidgetTester tester,
    ) async {
      String? selectedActivity;

      await tester.pumpWidget(
        MaterialApp(
          localizationsDelegates: const [
            AppLocalizations.delegate,
            GlobalMaterialLocalizations.delegate,
            GlobalWidgetsLocalizations.delegate,
            GlobalCupertinoLocalizations.delegate,
          ],
          supportedLocales: const [Locale('en')],
          home: EditActivity(
            initialActivity: 'Lightly Active',
            onActivitySelected: (activity) {
              selectedActivity = activity;
            },
            onBackButtonPressed: () {},
          ),
        ),
      );

      await tester.pumpAndSettle();

      final activityScreenFinder = find.byType(ActivityScreen);
      expect(activityScreenFinder, findsOneWidget);

      final activityScreen = tester.widget<ActivityScreen>(
        activityScreenFinder,
      );

      activityScreen.onNextStep('Very Active');
      await tester.pump();

      expect(selectedActivity, 'Very Active');
    });

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
          home: EditActivity(
            initialActivity: 'Lightly Active',
            onActivitySelected: (_) {},
            onBackButtonPressed: () {
              backButtonCalled = true;
            },
          ),
        ),
      );

      await tester.pumpAndSettle();

      final editActivityWidget = tester.widget<EditActivity>(
        find.byType(EditActivity),
      );

      editActivityWidget.onBackButtonPressed();
      await tester.pump();

      expect(backButtonCalled, isTrue);
    });
  });
}
