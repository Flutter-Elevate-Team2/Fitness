import 'package:fitness_app/Features/auth/domain/entities/user_entity.dart';
import 'package:fitness_app/Features/auth/presentation/login/view_model/login_state.dart';
import 'package:fitness_app/Features/auth/presentation/login/view_model/login_view_model.dart';
import 'package:fitness_app/Features/auth/presentation/sign_up/view_model/sign_up_events.dart';
import 'package:fitness_app/Features/auth/presentation/sign_up/view_model/sign_up_states.dart';
import 'package:fitness_app/Features/auth/presentation/sign_up/view_model/sign_up_view_model.dart';
import 'package:fitness_app/Features/auth/presentation/sign_up/views/screens/signup_screen.dart';
import 'package:fitness_app/Features/auth/presentation/sign_up/views/widgets/signup_first_step.dart';
import 'package:fitness_app/core/app_router/app_router.dart'; // تأكد من استيراد Routes
import 'package:fitness_app/core/base_state/base_state.dart';
import 'package:fitness_app/core/di/di.dart';
import 'package:fitness_app/core/l10n/app_localizations.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:go_router/go_router.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:mocktail/mocktail.dart' show registerFallbackValue;

import 'signup_screen_test.mocks.dart';

@GenerateNiceMocks([MockSpec<SignUpViewModel>(), MockSpec<LoginViewModel>()])
void main() {
  late MockSignUpViewModel mockSignUpViewModel;
  late MockLoginViewModel mockLoginViewModel;

  setUpAll(() {
    registerFallbackValue(
      OnSignUpClickEvent(
        firstName: '', lastName: '', email: '', password: '',
        rePassword: '', gender: '', age: 0, weight: 0, height: 0,
        goal: '', activityLevel: '',
      ),
    );
  });

  setUp(() {
    mockSignUpViewModel = MockSignUpViewModel();
    mockLoginViewModel = MockLoginViewModel();

    when(mockSignUpViewModel.state).thenReturn(SignUpStates());
    when(mockSignUpViewModel.stream).thenAnswer((_) => Stream.value(SignUpStates()));
    when(mockSignUpViewModel.close()).thenAnswer((_) => Future.value());

    when(mockLoginViewModel.state).thenReturn(const LoginState());
    when(mockLoginViewModel.stream).thenAnswer((_) => const Stream.empty());
    when(mockLoginViewModel.close()).thenAnswer((_) => Future.value());

    if (getIt.isRegistered<SignUpViewModel>()) {
      getIt.unregister<SignUpViewModel>();
    }
    getIt.registerFactory<SignUpViewModel>(() => mockSignUpViewModel);
  });

  // دالة مساعدة لإنشاء Router وهمي للاختبار
  Widget createTestableWidget({int step = 0}) {
    final router = GoRouter(
      initialLocation: '/signup',
      routes: [
        GoRoute(
          path: '/signup',
          name: 'signup', // تأكد من مطابقة الأسماء المستخدمة في Routes
          builder: (context, state) => BlocProvider<LoginViewModel>.value(
            value: mockLoginViewModel,
            child: SignupScreen(step: step),
          ),
        ),
        // إضافة مسار وهمي لصفحة الـ Login لأن الكود سيحاول الذهاب إليها
        GoRoute(
          path: '/login',
          name: Routes.loginName,
          builder: (context, state) => const Scaffold(body: Text('Login Page')),
        ),
      ],
    );

    return MaterialApp.router(
      routerConfig: router,
      localizationsDelegates: const [
        AppLocalizations.delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      supportedLocales: AppLocalizations.supportedLocales,
      locale: const Locale('en'),
    );
  }

  group('SignupScreen Generated Mock Tests', () {
    testWidgets('renders SignupFirstStep initially', (tester) async {
      await tester.pumpWidget(createTestableWidget());
      await tester.pumpAndSettle();
      expect(find.byType(SignupFirstStep), findsOneWidget);
    });

    testWidgets('shows success snackbar when data (UserEntity) is received', (tester) async {
      final successState = SignUpStates(
        signUpState: BaseState(
          isLoading: false,
          data: UserEntity(
            id: "1", firstName: "f", lastName: "l", email: "e",
            gender: "g", age: 20, weight: 60, height: 160,
            activityLevel: "a", goal: "g", photo: "p",
          ),
          errorMessage: null,
        ),
      );

      when(mockSignUpViewModel.state).thenReturn(successState);
      when(mockSignUpViewModel.stream).thenAnswer((_) => Stream.value(successState));

      await tester.pumpWidget(createTestableWidget());

      // نستخدم pumpAndSettle لانتظار الـ SnackBar
      await tester.pumpAndSettle();

      expect(find.text('Account created successfully!'), findsOneWidget);
    });
  });
}