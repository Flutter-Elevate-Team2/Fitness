import 'package:fitness_app/Features/auth/presentation/login/views/widgets/password_field.dart';
import 'package:fitness_app/Features/profile/presentation/views/widgets/change_password/change_password_form.dart';
import 'package:fitness_app/core/l10n/app_localizations.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_localizations/flutter_localizations.dart';

void main() {
  late TextEditingController oldPasswordController;
  late TextEditingController newPasswordController;
  late TextEditingController confirmPasswordController;

  setUp(() {
    oldPasswordController = TextEditingController();
    newPasswordController = TextEditingController();
    confirmPasswordController = TextEditingController();
  });

  tearDown(() {
    oldPasswordController.dispose();
    newPasswordController.dispose();
    confirmPasswordController.dispose();
  });

  Widget createWidgetUnderTest() {
    return MaterialApp(
      localizationsDelegates: const [
        AppLocalizations.delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      supportedLocales: const [Locale('en')],
      home: Scaffold(
        body: ChangePasswordForm(
          oldPasswordController: oldPasswordController,
          newPasswordController: newPasswordController,
          confirmPasswordController: confirmPasswordController,
        ),
      ),
    );
  }

  group('ChangePasswordForm Widget Tests', () {
    testWidgets('should render three PasswordField widgets', (tester) async {
      await tester.pumpWidget(createWidgetUnderTest());

      expect(find.byType(PasswordField), findsNWidgets(3));
    });

    testWidgets('should update controllers when text is entered', (tester) async {
      await tester.pumpWidget(createWidgetUnderTest());

      await tester.enterText(find.byType(PasswordField).at(0), 'oldPass123');
      await tester.enterText(find.byType(PasswordField).at(1), 'newPass123');
      await tester.enterText(find.byType(PasswordField).at(2), 'newPass123');

      expect(oldPasswordController.text, 'oldPass123');
      expect(newPasswordController.text, 'newPass123');
      expect(confirmPasswordController.text, 'newPass123');
    });

    testWidgets('should display correct titles from l10n', (tester) async {
      await tester.pumpWidget(createWidgetUnderTest());
      await tester.pumpAndSettle();

     expect(find.textContaining('Old Password'), findsOneWidget);
      expect(find.textContaining('New Password'), findsOneWidget);
      expect(find.textContaining('Confirm Password'), findsOneWidget);
    });
  });
}