import 'package:fitness_app/Features/auth/presentation/login/views/widgets/email_field.dart';
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
        body: EmailField(
          controller: controller,
          onChanged: () => isChangedCalled = true,
        ),
      ),
    );
  }

  group('EmailField Widget Tests', () {
    testWidgets('should render with correct initial setup', (tester) async {
      await tester.pumpWidget(createTestableWidget());

      expect(find.byType(TextFormField), findsOneWidget);

      expect(find.byType(Image), findsOneWidget);

      expect(find.text('Email'), findsOneWidget);
    });

    testWidgets('should have correct keyboard type and text input action', (
      tester,
    ) async {
      await tester.pumpWidget(createTestableWidget());

      final textField = tester.widget<TextField>(find.byType(TextField));

      expect(textField.keyboardType, TextInputType.emailAddress);
      expect(textField.textInputAction, TextInputAction.next);
    });

    testWidgets(
      'should call onChanged and update controller when text is entered',
      (tester) async {
        await tester.pumpWidget(createTestableWidget());

        const testEmail = 'test@example.com';
        await tester.enterText(find.byType(TextFormField), testEmail);

        expect(controller.text, testEmail);
        expect(isChangedCalled, isTrue);
      },
    );

    testWidgets(
      'should trigger validation and return error for invalid email',
      (tester) async {
        await tester.pumpWidget(createTestableWidget());

        final formField = tester.widget<TextFormField>(
          find.byType(TextFormField),
        );

        final result = formField.validator!('not-an-email');

        expect(result, isNotNull);
      },
    );

    testWidgets('should return null from validator for a valid email', (
      tester,
    ) async {
      await tester.pumpWidget(createTestableWidget());

      final formField = tester.widget<TextFormField>(
        find.byType(TextFormField),
      );

      final result = formField.validator!('valid@example.com');

      expect(result, isNull);
    });
  });
}
