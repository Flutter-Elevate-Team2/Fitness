import 'package:fitness_app/core/helpers/form_validators.dart';
import 'package:fitness_app/core/l10n/app_localizations.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  Widget createTestWidget(Widget Function(BuildContext) builder) {
    return MaterialApp(
      localizationsDelegates: AppLocalizations.localizationsDelegates,
      supportedLocales: AppLocalizations.supportedLocales,
      home: Builder(builder: builder),
    );
  }

  group('FormValidators Full Coverage', () {
    testWidgets('validateEmail cases', (tester) async {
      String? r1, r2, r3, r4;
      await tester.pumpWidget(createTestWidget((ctx) {
        r1 = FormValidators.validateEmail(ctx, null);
        r2 = FormValidators.validateEmail(ctx, '');
        r3 = FormValidators.validateEmail(ctx, 'invalid-email');
        r4 = FormValidators.validateEmail(ctx, 'test@example.com');
        return const SizedBox();
      }));
      expect(r1, isNotNull);
      expect(r2, isNotNull);
      expect(r3, isNotNull);
      expect(r4, isNull);
    });

    testWidgets('validatePassword cases', (tester) async {
      String? r1, r2, r3, r4, r5;
      await tester.pumpWidget(createTestWidget((ctx) {
        r1 = FormValidators.validatePassword(ctx, null);
        r2 = FormValidators.validatePassword(ctx, '');
        r3 = FormValidators.validatePassword(ctx, 'short');
        r4 = FormValidators.validatePassword(ctx, 'nonspecialist123');
        r5 = FormValidators.validatePassword(ctx, 'Valid123@Password');
        return const SizedBox();
      }));
      expect(r1, isNotNull);
      expect(r2, isNotNull);
      expect(r3, isNotNull);
      expect(r4, isNotNull);
      expect(r5, isNull);
    });

    testWidgets('validateConfirmPassword cases', (tester) async {
      String? r1, r2, r3, r4;
      await tester.pumpWidget(createTestWidget((ctx) {
        r1 = FormValidators.validateConfirmPassword(ctx, null, 'pass');
        r2 = FormValidators.validateConfirmPassword(ctx, '', 'pass');
        r3 = FormValidators.validateConfirmPassword(ctx, 'wrong', 'pass');
        r4 = FormValidators.validateConfirmPassword(ctx, 'pass', 'pass');
        return const SizedBox();
      }));
      expect(r1, isNotNull);
      expect(r2, isNotNull);
      expect(r3, isNotNull);
      expect(r4, isNull);
    });

    testWidgets('validatePhone cases', (tester) async {
      String? r1, r2, r3, r4;
      await tester.pumpWidget(createTestWidget((ctx) {
        r1 = FormValidators.validatePhone(ctx, null);
        r2 = FormValidators.validatePhone(ctx, '');
        r3 = FormValidators.validatePhone(ctx, '123');
        r4 = FormValidators.validatePhone(ctx, '01012345678');
        return const SizedBox();
      }));
      expect(r1, isNotNull);
      expect(r2, isNotNull);
      expect(r3, isNotNull);
      expect(r4, isNull);
    });

    test('validateRequired cases', () {
      expect(FormValidators.validateRequired(null, 'err'), 'err');
      expect(FormValidators.validateRequired('', 'err'), 'err');
      expect(FormValidators.validateRequired('val', 'err'), isNull);
    });

    testWidgets('validateLoginPassword cases', (tester) async {
      String? r1, r2, r3, r4;
      await tester.pumpWidget(createTestWidget((ctx) {
        r1 = FormValidators.validateLoginPassword(ctx, null);
        r2 = FormValidators.validateLoginPassword(ctx, '');
        r3 = FormValidators.validateLoginPassword(ctx, '1234567');
        r4 = FormValidators.validateLoginPassword(ctx, '12345678');
        return const SizedBox();
      }));
      expect(r1, isNotNull);
      expect(r2, isNotNull);
      expect(r3, isNotNull);
      expect(r4, isNull);
    });

    testWidgets('validateNationalId cases', (tester) async {
      String? r1, r2, r3, r4, r5;
      await tester.pumpWidget(createTestWidget((ctx) {
        r1 = FormValidators.validateNationalId(ctx, null);
        r2 = FormValidators.validateNationalId(ctx, '');
        r3 = FormValidators.validateNationalId(ctx, '123');
        r4 = FormValidators.validateNationalId(ctx, '1234567890123A');
        r5 = FormValidators.validateNationalId(ctx, '12345678901234');
        return const SizedBox();
      }));
      expect(r1, isNotNull);
      expect(r2, isNotNull);
      expect(r3, isNotNull);
      expect(r4, isNotNull);
      expect(r5, isNull);
    });

    testWidgets('validateVehicleNumber cases', (tester) async {
      String? r1, r2, r3, r4, r5, r6;
      await tester.pumpWidget(createTestWidget((ctx) {
        r1 = FormValidators.validateVehicleNumber(ctx, null);
        r2 = FormValidators.validateVehicleNumber(ctx, '');
        r3 = FormValidators.validateVehicleNumber(ctx, '12');
        r4 = FormValidators.validateVehicleNumber(ctx, '12345678901');
        r5 = FormValidators.validateVehicleNumber(ctx, 'ABC@1');
        r6 = FormValidators.validateVehicleNumber(ctx, 'ABC123');
        return const SizedBox();
      }));
      expect(r1, isNotNull);
      expect(r2, isNotNull);
      expect(r3, isNotNull);
      expect(r4, isNotNull);
      expect(r5, isNotNull);
      expect(r6, isNull);
    });
  });
}