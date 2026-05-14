import 'package:fitness_app/Features/profile/presentation/views/widgets/edit_profile/profile_text_field.dart';
import 'package:fitness_app/Features/profile/presentation/views/widgets/edit_profile/profile_text_field_section.dart';
import 'package:fitness_app/core/l10n/app_localizations.dart';
import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  late TextEditingController firstNameController;
  late TextEditingController lastNameController;
  late TextEditingController emailController;

  setUp(() {
    firstNameController = TextEditingController();
    lastNameController = TextEditingController();
    emailController = TextEditingController();
  });

  tearDown(() {
    firstNameController.dispose();
    lastNameController.dispose();
    emailController.dispose();
  });

  Widget createWidgetUnderTest({
    String? weightText,
    String? goalText,
    String? activityText,
    required VoidCallback onEditWeight,
    required VoidCallback onEditGoal,
    required VoidCallback onEditActivity,
    required VoidCallback onChanged,
  }) {
    return MaterialApp(
      localizationsDelegates: const [
        AppLocalizations.delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      supportedLocales: const [Locale('en')],
      home: Scaffold(
        body: Form(
          child: ProfileTextFieldSection(
            firstNameController: firstNameController,
            lastNameController: lastNameController,
            emailController: emailController,
            onChanged: onChanged,
            weightText: weightText,
            goalText: goalText,
            activityText: activityText,
            onEditWeight: onEditWeight,
            onEditGoal: onEditGoal,
            onEditActivity: onEditActivity,
          ),
        ),
      ),
    );
  }

  group('ProfileTextFieldSection Widget Tests', () {
    testWidgets('renders all CustomProfileField widgets correctly', (
      WidgetTester tester,
    ) async {
      await tester.pumpWidget(
        createWidgetUnderTest(
          onEditWeight: () {},
          onEditGoal: () {},
          onEditActivity: () {},
          onChanged: () {},
        ),
      );
      await tester.pumpAndSettle();

      expect(find.byType(CustomProfileField), findsAtLeastNWidgets(6));
    });

    testWidgets('triggers onChanged when text changes', (
      WidgetTester tester,
    ) async {
      bool onChangedCalled = false;

      await tester.pumpWidget(
        createWidgetUnderTest(
          onEditWeight: () {},
          onEditGoal: () {},
          onEditActivity: () {},
          onChanged: () {
            onChangedCalled = true;
          },
        ),
      );

      await tester.enterText(find.byType(CustomProfileField).first, 'John');
      await tester.pumpAndSettle();

      expect(onChangedCalled, isTrue);
    });

    testWidgets('triggers callbacks on readOnly field taps', (
      WidgetTester tester,
    ) async {
      bool weightTapped = false;
      bool goalTapped = false;

      await tester.pumpWidget(
        createWidgetUnderTest(
          weightText: '70 kg',
          goalText: 'Lose weight',
          activityText: 'Active',
          onEditWeight: () {
            weightTapped = true;
          },
          onEditGoal: () {
            goalTapped = true;
          },
          onEditActivity: () {},
          onChanged: () {},
        ),
      );

      await tester.pumpAndSettle();

      await tester.tap(find.text('70 kg'));
      await tester.pumpAndSettle();

      expect(weightTapped, isTrue);
      expect(goalTapped, isFalse);
    });
  });
}
