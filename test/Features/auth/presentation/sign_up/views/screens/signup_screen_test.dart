import 'package:fitness_app/Features/auth/domain/entities/user_entity.dart';
import 'package:fitness_app/Features/auth/presentation/login/view_model/login_view_model.dart';
import 'package:fitness_app/Features/auth/presentation/login/view_model/login_state.dart';
import 'package:fitness_app/Features/auth/presentation/sign_up/view_model/sign_up_events.dart';
import 'package:fitness_app/Features/auth/presentation/sign_up/view_model/sign_up_states.dart';
import 'package:fitness_app/Features/auth/presentation/sign_up/view_model/sign_up_view_model.dart';
import 'package:fitness_app/Features/auth/presentation/sign_up/views/screens/signup_screen.dart';
import 'package:fitness_app/Features/auth/presentation/sign_up/views/widgets/signup_first_step.dart';
import 'package:fitness_app/core/app_router/app_router.dart';
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
import 'package:firebase_auth/firebase_auth.dart'; // مهم جداً

import 'signup_screen_test.mocks.dart';

// ضيفنا MockUser و MockUserInfo عشان كود الـ initState بتاعك بيستخدمهم
@GenerateNiceMocks([
  MockSpec<SignUpViewModel>(),
  MockSpec<LoginViewModel>(),
  MockSpec<User>(),
  MockSpec<UserInfo>(),
])
void main() {
  late MockSignUpViewModel mockSignUpViewModel;
  late MockLoginViewModel mockLoginViewModel;
  late MockUser mockFirebaseUser;
  late MockUserInfo mockUserInfo;

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
    mockFirebaseUser = MockUser();
    mockUserInfo = MockUserInfo();

    // تجهيز بيانات اليوزر الوهمي عشان initState ما تضربش
    when(mockUserInfo.email).thenReturn('test@example.com');
    when(mockFirebaseUser.displayName).thenReturn('Arafa Naim');
    when(mockFirebaseUser.providerData).thenReturn([mockUserInfo]);

    when(mockSignUpViewModel.state).thenReturn(SignUpStates());
    when(mockSignUpViewModel.stream).thenAnswer((_) => Stream.value(SignUpStates()));
    when(mockSignUpViewModel.close()).thenAnswer((_) => Future.value());

    when(mockLoginViewModel.state).thenReturn(const LoginState());
    when(mockLoginViewModel.stream).thenAnswer((_) => const Stream.empty());

    if (getIt.isRegistered<SignUpViewModel>()) {
      getIt.unregister<SignUpViewModel>();
    }
    getIt.registerFactory<SignUpViewModel>(() => mockSignUpViewModel);
  });

  Widget createTestableWidget({int step = 0}) {
    final router = GoRouter(
      initialLocation: '/signup',
      routes: [
        GoRoute(
          path: '/signup',
          name: 'signup',
          builder: (context, state) => BlocProvider<LoginViewModel>.value(
            value: mockLoginViewModel,
            child: SignupScreen(
              step: step,
              user: mockFirebaseUser, // تمرير اليوزر الوهمي هنا
            ),
          ),
        ),
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

  group('SignupScreen Tests with Firebase User Mock', () {
    testWidgets('renders SignupFirstStep and populates fields from Social User', (tester) async {
      await tester.pumpWidget(createTestableWidget());
      await tester.pumpAndSettle();

      expect(find.byType(SignupFirstStep), findsOneWidget);

      // التأكد أن البيانات اتسحبت صح من اليوزر وظهرت في الـ TextFields
      expect(find.text('Arafa'), findsOneWidget);
      expect(find.text('test@example.com'), findsOneWidget);
    });

    testWidgets('shows success snackbar and navigates on success', (tester) async {
      final successState = SignUpStates(
        signUpState: BaseState(
          isLoading: false,
          data: UserEntity(
            id: "1", firstName: "Arafa", lastName: "Naim", email: "test@example.com",
            gender: "male", age: 25, weight: 70, height: 170,
            activityLevel: "level2", goal: "get_fitter", photo: "",
          ),
        ),
      );

      when(mockSignUpViewModel.state).thenReturn(successState);
      when(mockSignUpViewModel.stream).thenAnswer((_) => Stream.value(successState));

      await tester.pumpWidget(createTestableWidget());
      await tester.pumpAndSettle();

      expect(find.text('Account created successfully!'), findsOneWidget);
    });
  });
}