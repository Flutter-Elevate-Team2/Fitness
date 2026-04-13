import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:pinput/pinput.dart';
import 'package:fitness_app/Features/auth/presentation/forget_password/widgets/verify_reset_password_widgets/otp_input_widget.dart';

void main() {
  group('OtpInputWidget Tests', () {
    testWidgets(
      '1. Should call onChanged when typing and onCompleted when full',
      (tester) async {
        String? changedValue;
        String? completedValue;

        await tester.pumpWidget(
          MaterialApp(
            home: Scaffold(
              body: OtpInputWidget(
                length: 4,
                onChanged: (v) => changedValue = v,
                onCompleted: (v) => completedValue = v,
              ),
            ),
          ),
        );

        await tester.enterText(find.byType(Pinput), '1');
        await tester.pump();
        expect(changedValue, '1');

        await tester.enterText(find.byType(Pinput), '1234');
        await tester.pump();

        expect(changedValue, '1234');
        expect(completedValue, '1234');
      },
    );

    testWidgets('2. Should display error message when errorText is provided', (
      tester,
    ) async {
      const errorMsg = 'Invalid OTP';

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: OtpInputWidget(onCompleted: (_) {}, errorText: errorMsg),
          ),
        ),
      );

      expect(find.text(errorMsg), findsOneWidget);
      expect(find.byIcon(Icons.error_outline), findsOneWidget);
    });

    testWidgets('3. Should clear error when user starts typing again', (
      tester,
    ) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: OtpInputWidget(onCompleted: (_) {}, errorText: 'Error'),
          ),
        ),
      );

      expect(find.text('Error'), findsOneWidget);

      await tester.enterText(find.byType(Pinput), '5');
      await tester.pump();

      expect(find.text('Error'), findsNothing);
    });

    testWidgets(
      '4. Should request focus and update error when didUpdateWidget is triggered',
      (tester) async {
        await tester.pumpWidget(
          MaterialApp(
            home: Scaffold(
              body: StatefulBuilder(
                builder: (context, setState) {
                  return OtpInputWidget(onCompleted: (_) {}, errorText: null);
                },
              ),
            ),
          ),
        );

        await tester.pumpWidget(
          MaterialApp(
            home: Scaffold(
              body: StatefulBuilder(
                builder: (context, setState) {
                  return OtpInputWidget(
                    onCompleted: (_) {},
                    errorText: 'New Error',
                  );
                },
              ),
            ),
          ),
        );

        await tester.pump();

        expect(find.text('New Error'), findsOneWidget);
        final pinput = tester.widget<Pinput>(find.byType(Pinput));
        expect(pinput.focusNode!.hasFocus, isTrue);
      },
    );
  });
}
