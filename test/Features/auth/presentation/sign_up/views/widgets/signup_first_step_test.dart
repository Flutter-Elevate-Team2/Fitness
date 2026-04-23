import 'package:firebase_auth_mocks/firebase_auth_mocks.dart';
 import 'package:fitness_app/Features/auth/presentation/login/view_model/login_state.dart';
import 'package:fitness_app/Features/auth/presentation/login/view_model/login_view_model.dart';
import 'package:fitness_app/Features/auth/presentation/sign_up/views/widgets/signup_first_step.dart';
import 'package:fitness_app/Features/auth/presentation/sign_up/views/widgets/social_login_row.dart';
import 'package:fitness_app/core/l10n/app_localizations.dart';
import 'package:fitness_app/core/widget/pill_text_form_field.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

 @GenerateNiceMocks([MockSpec<LoginViewModel>()])
import 'signup_first_step_test.mocks.dart';

void main() {
  group('SignupFirstStep', () {
    late TextEditingController firstNameCtrl;
    late TextEditingController lastNameCtrl;
    late TextEditingController emailCtrl;
    late TextEditingController passwordCtrl;
    late MockLoginViewModel mockLoginViewModel;
    late MockUser mockUser;

    setUp(() {
      firstNameCtrl = TextEditingController();
      lastNameCtrl = TextEditingController();
      emailCtrl = TextEditingController();
      passwordCtrl = TextEditingController();

      mockLoginViewModel = MockLoginViewModel();
      mockUser = MockUser(uid: '123', email: 'test@test.com');

      // Stubs للـ ViewModel
      when(mockLoginViewModel.state).thenReturn(const LoginState());
      when(mockLoginViewModel.stream).thenAnswer((_) => const Stream.empty());
      when(mockLoginViewModel.close()).thenAnswer((_) => Future.value());
    });

    tearDown(() {
      firstNameCtrl.dispose();
      lastNameCtrl.dispose();
      emailCtrl.dispose();
      passwordCtrl.dispose();
    });

    Widget buildWidget({VoidCallback? onNextStep}) {
      return MaterialApp(
        localizationsDelegates: const [
          AppLocalizations.delegate,
          GlobalMaterialLocalizations.delegate,
          GlobalWidgetsLocalizations.delegate,
          GlobalCupertinoLocalizations.delegate,
        ],
        supportedLocales: AppLocalizations.supportedLocales,
        locale: const Locale('en'),
        home: BlocProvider<LoginViewModel>.value(
          value: mockLoginViewModel,
          child: Scaffold(
            body: SignupFirstStep(
              firstNameController: firstNameCtrl,
              lastNameController: lastNameCtrl,
              emailController: emailCtrl,
              passwordController: passwordCtrl,
              onNextStep: onNextStep ?? () {},
            ),
          ),
        ),
      );
    }

    testWidgets('displays greeting texts and form elements', (tester) async {
      await tester.pumpWidget(buildWidget());
      await tester.pump();

      expect(find.text('Hey There'), findsOneWidget);
      expect(find.byType(PillTextFormField), findsNWidgets(4));
      expect(find.byType(SocialLoginRow), findsOneWidget);
    });

    testWidgets('validation fails when fields are empty', (tester) async {
      bool called = false;
      await tester.pumpWidget(buildWidget(onNextStep: () => called = true));

       final registerBtn = find.text('Register');

      await tester.tap(registerBtn.last);
      await tester.pump();

      expect(called, isFalse);
    });

    testWidgets('password visibility toggles when suffix icon is tapped', (tester) async {
      await tester.pumpWidget(buildWidget());

       final passwordField = tester.widget<PillTextFormField>(
        find.widgetWithText(PillTextFormField, 'Password'),
      );
      expect(passwordField.obscureText, isTrue);

       await tester.tap(find.byIcon(Icons.visibility_off_outlined));
      await tester.pump();

       final passwordFieldUpdated = tester.widget<PillTextFormField>(
        find.widgetWithText(PillTextFormField, 'Password'),
      );
      expect(passwordFieldUpdated.obscureText, isFalse);
    });
  });
}