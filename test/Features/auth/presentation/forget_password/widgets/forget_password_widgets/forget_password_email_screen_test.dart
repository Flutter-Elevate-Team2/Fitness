import 'dart:async';
import 'package:fitness_app/Features/auth/domain/entities/forget_password_entities/forget_password_entity.dart';
import 'package:fitness_app/Features/auth/presentation/forget_password/view_model/forget_password_event.dart';
import 'package:fitness_app/Features/auth/presentation/forget_password/view_model/forget_password_state.dart';
import 'package:fitness_app/Features/auth/presentation/forget_password/view_model/forget_password_view_model.dart';
import 'package:fitness_app/Features/auth/presentation/forget_password/widgets/forget_password_widgets/forget_password_email_screen.dart';
import 'package:fitness_app/Features/auth/presentation/login/views/widgets/email_field.dart';
import 'package:fitness_app/core/base_state/base_state.dart';
import 'package:fitness_app/core/l10n/app_localizations.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

 @GenerateMocks([ForgetPasswordViewModel])
import 'forget_password_email_screen_test.mocks.dart';

void main() {
  late MockForgetPasswordViewModel mockViewModel;
  late StreamController<ForgetPasswordState> stateController;
  bool isNextPageCalled = false;

  setUp(() {
    mockViewModel = MockForgetPasswordViewModel();
    stateController = StreamController<ForgetPasswordState>.broadcast();
    isNextPageCalled = false;

     when(mockViewModel.state).thenReturn(const ForgetPasswordState());
    when(mockViewModel.stream).thenAnswer((_) => stateController.stream);
  });

  tearDown(() {
    stateController.close();
  });

  Widget createWidgetUnderTest() {
    return MaterialApp(
      localizationsDelegates: AppLocalizations.localizationsDelegates,
      supportedLocales: AppLocalizations.supportedLocales,
      home: Scaffold(
        body: BlocProvider<ForgetPasswordViewModel>.value(
          value: mockViewModel,
          child: ForgetPasswordEmailScreen(
            onNextPage: () => isNextPageCalled = true,
          ),
        ),
      ),
    );
  }

  group('ForgetPasswordEmailScreen Widget Tests', () {

    testWidgets('1. Should call SendOtp when a valid email is submitted', (tester) async {
      await tester.pumpWidget(createWidgetUnderTest());
      const testEmail = 'test@example.com';

       await tester.enterText(find.byType(EmailField), testEmail);

       final BuildContext context = tester.element(find.byType(ForgetPasswordEmailScreen));
      await tester.tap(find.text(AppLocalizations.of(context)!.sentOtp));
      await tester.pump();

       verify(mockViewModel.doIntent(argThat(
        isA<SendOtp>().having((e) => e.email, 'email', testEmail),
      ))).called(1);
    });

    testWidgets('2. Should call onNextPage when sendOtpState reports success', (tester) async {
      await tester.pumpWidget(createWidgetUnderTest());

       final successState = const ForgetPasswordState().copyWith(
        sendOtpState: BaseState<ForgetPasswordEntity>(
          isLoading: false,
          data:   ForgetPasswordEntity(message: 'OTP Sent', info: ''),
        ),
      );

      stateController.add(successState);
      await tester.pump();

      expect(isNextPageCalled, true);
    });

    testWidgets('3. Should show SnackBar when sendOtpState reports an error', (tester) async {
      await tester.pumpWidget(createWidgetUnderTest());
      const errorMsg = 'User not found';

       final errorState = const ForgetPasswordState().copyWith(
        sendOtpState: BaseState<ForgetPasswordEntity>(
          isLoading: false,
          errorMessage: errorMsg,
        ),
      );

      stateController.add(errorState);
      await tester.pump();
      await tester.pump();

      expect(find.byType(SnackBar), findsOneWidget);
      expect(find.text(errorMsg), findsOneWidget);
    });
  });
}