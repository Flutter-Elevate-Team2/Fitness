import 'package:fitness_app/Features/auth/presentation/login/views/widgets/password_field.dart';
import 'package:fitness_app/core/l10n/app_localizations.dart';
import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  late TextEditingController controller;
  bool isChangedCalled = false;

  setUp(() {
    controller = TextEditingController();
    isChangedCalled = false;
  });

  tearDown(() {
    controller.dispose();
  });

  Widget createTestableWidget() {
    return MaterialApp(
      localizationsDelegates: const [
        AppLocalizations.delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      supportedLocales: const [Locale('en')],
      home: Scaffold(
        body: PasswordField(
          controller: controller,
          onChanged: () => isChangedCalled = true,
        ),
      ),
    );
  }

  group('PasswordField Widget Tests', () {
    testWidgets('should initial hide password text', (tester) async {
      await tester.pumpWidget(createTestableWidget());

      final textField = tester.widget<TextField>(find.byType(TextField));

      expect(textField.obscureText, isTrue);
      expect(find.byIcon(Icons.visibility_off_outlined), findsOneWidget);
    });

    testWidgets(
      'should toggle password visibility when suffix icon is pressed',
      (tester) async {
        await tester.pumpWidget(createTestableWidget());

        await tester.tap(find.byType(IconButton));
        await tester.pump();

        final textField = tester.widget<TextField>(find.byType(TextField));

        expect(textField.obscureText, isFalse);
        expect(find.byIcon(Icons.visibility), findsOneWidget);
      },
    );

    testWidgets('should call onChanged callback when text is entered', (
      tester,
    ) async {
      await tester.pumpWidget(createTestableWidget());

      await tester.enterText(find.byType(TextFormField), '123456');

      expect(isChangedCalled, isTrue);
      expect(controller.text, '123456');
    });

    testWidgets('should have correct keyboard type and action', (tester) async {
      await tester.pumpWidget(createTestableWidget());

      final textField = tester.widget<TextField>(find.byType(TextField));

      expect(textField.keyboardType, TextInputType.visiblePassword);
      expect(textField.textInputAction, TextInputAction.done);
    });

    testWidgets('should show validation error when input is invalid', (
      tester,
    ) async {
      await tester.pumpWidget(createTestableWidget());

      final formField = tester.widget<TextFormField>(
        find.byType(TextFormField),
      );

      final result = formField.validator!(null);

      expect(result, isNotNull);
    });
  });
}
