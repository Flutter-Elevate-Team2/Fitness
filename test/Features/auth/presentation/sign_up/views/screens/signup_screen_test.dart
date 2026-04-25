import 'package:fitness_app/Features/auth/domain/entities/user_entity.dart';
import 'package:fitness_app/Features/auth/presentation/login/view_model/login_view_model.dart';
import 'package:fitness_app/Features/auth/presentation/login/view_model/login_state.dart';
import 'package:fitness_app/Features/auth/presentation/sign_up/view_model/sign_up_events.dart';
import 'package:fitness_app/Features/auth/presentation/sign_up/view_model/sign_up_states.dart';
import 'package:fitness_app/Features/auth/presentation/sign_up/view_model/sign_up_view_model.dart';
import 'package:firebase_core_platform_interface/firebase_core_platform_interface.dart';
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
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/services.dart';
import 'package:plugin_platform_interface/plugin_platform_interface.dart';

import 'signup_screen_test.mocks.dart';

@GenerateNiceMocks([
  MockSpec<SignUpViewModel>(),
  MockSpec<LoginViewModel>(),
  MockSpec<User>(),
  MockSpec<UserInfo>(),
])

// 1. تعريف الـ Mock لـ Platform Interface
class MockFirebasePlatform extends Mock with MockPlatformInterfaceMixin implements FirebasePlatform {
  @override
  Future<FirebaseAppPlatform> initializeApp({
    String? name,
    FirebaseOptions? options,
  }) async {
    return FirebaseAppPlatform(
      name ?? '[DEFAULT]',
      const FirebaseOptions(
        apiKey: '123',
        appId: '123',
        messagingSenderId: '123',
        projectId: '123',
      ),
    );
  }

  @override
  FirebaseAppPlatform app([String name = '[DEFAULT]']) {
    return FirebaseAppPlatform(
      name,
      const FirebaseOptions(
        apiKey: '123',
        appId: '123',
        messagingSenderId: '123',
        projectId: '123',
      ),
    );
  }
}

void main() {
  final mockSignUpViewModel = MockSignUpViewModel();
  final mockLoginViewModel = MockLoginViewModel();
  final mockFirebaseUser = MockUser();
  final mockUserInfo = MockUserInfo();

  setUpAll(() async {
    TestWidgetsFlutterBinding.ensureInitialized();

    // 2. تفعيل الـ Mock Platform بدلاً من الاتصال الحقيقي
    FirebasePlatform.instance = MockFirebasePlatform();

    // 3. تزييف قناة Auth الضرورية
    const MethodChannel channelAuth = MethodChannel('plugins.flutter.io/firebase_auth');
    TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger
        .setMockMethodCallHandler(channelAuth, (MethodCall methodCall) async => null);

    await Firebase.initializeApp();

    registerFallbackValue(OnSignUpClickEvent(
      firstName: '', lastName: '', email: '', password: '',
      rePassword: '', gender: '', age: 0, weight: 0, height: 0,
      goal: '', activityLevel: '',
    ));
  });

  setUp(() {
    reset(mockSignUpViewModel);
    reset(mockLoginViewModel);
    reset(mockFirebaseUser);

    when(mockUserInfo.email).thenReturn('test@example.com');
    when(mockFirebaseUser.displayName).thenReturn('Arafa Naim');
    when(mockFirebaseUser.email).thenReturn('test@example.com');
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
              user: mockFirebaseUser,
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

  group('SignupScreen Tests', () {
    testWidgets('should render SignupFirstStep and populate fields from Social User', (tester) async {
      await tester.pumpWidget(createTestableWidget());
      await tester.pump();

      expect(find.byType(SignupFirstStep), findsOneWidget);
      expect(find.textContaining('Arafa'), findsWidgets);
    });

    testWidgets('should show success snackbar and navigate to login on success state', (tester) async {
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
      await tester.pump();

      expect(find.text('Account created successfully!'), findsOneWidget);

      await tester.pumpAndSettle();
      expect(find.text('Login Page'), findsOneWidget);
    });

    testWidgets('should show error snackbar when error occurs', (tester) async {
      final errorState = SignUpStates(
        signUpState: BaseState(
          isLoading: false,
          errorMessage: 'Connection Failed',
        ),
      );

      when(mockSignUpViewModel.state).thenReturn(errorState);
      when(mockSignUpViewModel.stream).thenAnswer((_) => Stream.value(errorState));

      await tester.pumpWidget(createTestableWidget());
      await tester.pump();

      expect(find.text('Connection Failed'), findsOneWidget);
    });
  });
}