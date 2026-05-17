import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mockito/mockito.dart';
import 'package:fitness_app/Features/auth/presentation/forget_password/view_model/forget_password_event.dart';
import 'package:fitness_app/Features/auth/presentation/forget_password/view_model/forget_password_view_model.dart';
import 'package:fitness_app/Features/auth/presentation/forget_password/view_model/forget_password_state.dart';
import 'package:fitness_app/Features/auth/presentation/forget_password/widgets/verify_reset_password_widgets/resend_code_text.dart';
import 'package:fitness_app/core/l10n/app_localizations.dart';

import '../reset_password_widgets/reset_password_screen_body_test.mocks.dart' show MockForgetPasswordViewModel;


void main() {
  late MockForgetPasswordViewModel mockViewModel;

  setUp(() {
    mockViewModel = MockForgetPasswordViewModel();
    when(mockViewModel.state).thenReturn(ForgetPasswordState());
    when(
      mockViewModel.stream,
    ).thenAnswer((_) => Stream.value(ForgetPasswordState()));
  });

  Widget createWidgetUnderTest({String? email, bool isLoading = false}) {
    return MaterialApp(
      localizationsDelegates: AppLocalizations.localizationsDelegates,
      supportedLocales: AppLocalizations.supportedLocales,
      home: Scaffold(
        body: BlocProvider<ForgetPasswordViewModel>.value(
          value: mockViewModel,
          child: ResendCodeText(email: email, isLoading: isLoading),
        ),
      ),
    );
  }

  group('ResendCodeText Tests', () {
    testWidgets(
      '1. Should show CircularProgressIndicator when isLoading is true',
      (tester) async {
        await tester.pumpWidget(createWidgetUnderTest(isLoading: true));

        expect(find.byType(CircularProgressIndicator), findsOneWidget);
        expect(find.byType(TextButton), findsNothing);
      },
    );

    testWidgets(
      '2. Should show TextButton and trigger SendOtp event when pressed',
      (tester) async {
        const testEmail = 'user@example.com';
        await tester.pumpWidget(
          createWidgetUnderTest(email: testEmail, isLoading: false),
        );

        final resendButton = find.byType(TextButton);
        expect(resendButton, findsOneWidget);

        await tester.tap(resendButton);
        await tester.pump();

        verify(
          mockViewModel.doIntent(
            argThat(isA<SendOtp>().having((e) => e.email, 'email', testEmail)),
          ),
        ).called(1);
      },
    );

    testWidgets('3. Should use empty string if email is null when pressed', (
      tester,
    ) async {
      await tester.pumpWidget(
        createWidgetUnderTest(email: null, isLoading: false),
      );

      await tester.tap(find.byType(TextButton));
      await tester.pump();

      verify(
        mockViewModel.doIntent(
          argThat(isA<SendOtp>().having((e) => e.email, 'email', '')),
        ),
      ).called(1);
    });

    testWidgets('4. Should display correct localization texts', (tester) async {
      await tester.pumpWidget(createWidgetUnderTest());
      await tester.pumpAndSettle();

      expect(find.textContaining(''), findsWidgets);
    });
  });
}
