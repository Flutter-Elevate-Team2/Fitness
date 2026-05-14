import 'dart:async';
import 'package:fitness_app/Features/auth/domain/entities/forget_password_entities/reset_password_entity.dart';
import 'package:fitness_app/Features/auth/presentation/forget_password/view_model/forget_password_state.dart';
import 'package:fitness_app/Features/auth/presentation/forget_password/view_model/forget_password_view_model.dart';
import 'package:fitness_app/Features/auth/presentation/forget_password/widgets/reset_password_widgets/reset_password_screen_body.dart';
import 'package:fitness_app/core/base_state/base_state.dart';
import 'package:fitness_app/core/l10n/app_localizations.dart';
import 'package:fitness_app/core/widget/custom_button.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

import 'reset_password_screen_body_test.mocks.dart';

@GenerateMocks([ForgetPasswordViewModel])
void main() {
  late MockForgetPasswordViewModel mockViewModel;
  late StreamController<ForgetPasswordState> stateController;

  setUp(() {
    mockViewModel = MockForgetPasswordViewModel();
    stateController = StreamController<ForgetPasswordState>.broadcast();
    when(mockViewModel.state).thenReturn(ForgetPasswordState());
    when(mockViewModel.stream).thenAnswer((_) => stateController.stream);
  });

  tearDown(() => stateController.close());

  Widget createWidgetUnderTest({String? email = 'test@example.com'}) {
    return MaterialApp(
      localizationsDelegates: AppLocalizations.localizationsDelegates,
      supportedLocales: AppLocalizations.supportedLocales,
      locale: const Locale('en'),
      home: BlocProvider<ForgetPasswordViewModel>.value(
        value: mockViewModel,
        child: Scaffold(
          body: ResetPasswordScreenBody(userEmail: email),
        ),
      ),
    );
  }

  group('ResetPasswordScreenBody Comprehensive Tests', () {
    testWidgets('should display password fields with correct keys', (tester) async {
      await tester.pumpWidget(createWidgetUnderTest());
      expect(find.byKey(const Key('new_password_field')), findsOneWidget);
      expect(find.byKey(const Key('confirm_password_field')), findsOneWidget);
    });

    testWidgets('should show snackbar when userEmail is null and button is pressed', (tester) async {
      await tester.pumpWidget(createWidgetUnderTest(email: null));

       await tester.enterText(find.byKey(const Key('new_password_field')), '12345678');
      await tester.enterText(find.byKey(const Key('confirm_password_field')), '12345678');

      await tester.tap(find.byType(CustomButton));
      await tester.pumpAndSettle();

      expect(find.byType(SnackBar), findsOneWidget);
    });

    testWidgets('should show success dialog on successful password reset', (tester) async {
      await tester.pumpWidget(createWidgetUnderTest());

      stateController.add(
        ForgetPasswordState(
          resetPasswordState: BaseState(
            isLoading: false,
            data: ResetPasswordEntity(message: 'Success', token: ""),
          ),
        ),
      );

      await tester.pumpAndSettle();

      expect(find.byType(AlertDialog), findsOneWidget);
    });

    testWidgets('should show error snackbar when resetPasswordState has error', (tester) async {
      await tester.pumpWidget(createWidgetUnderTest());

      stateController.add(
        ForgetPasswordState(
          resetPasswordState: BaseState(
            isLoading: false,
            errorMessage: 'Error occurred',
          ),
        ),
      );

      await tester.pumpAndSettle();

      expect(find.byType(SnackBar), findsOneWidget);
      expect(find.text('Error occurred'), findsOneWidget);
    });

    testWidgets('should enable auto-validation after an invalid submission attempt', (tester) async {
      await tester.pumpWidget(createWidgetUnderTest());

      // الضغط على الزر والحقول فارغة لإثارة الخطأ
      await tester.tap(find.byType(CustomButton));
      await tester.pump();

      final form = tester.widget<Form>(find.byType(Form));
      expect(form.autovalidateMode, AutovalidateMode.onUserInteraction);
    });
  });
}