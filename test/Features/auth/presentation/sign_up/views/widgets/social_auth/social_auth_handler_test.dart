import 'package:fitness_app/Features/auth/presentation/login/view_model/login_event.dart';
import 'package:fitness_app/Features/auth/presentation/login/view_model/login_view_model.dart';
import 'package:fitness_app/Features/auth/presentation/sign_up/views/widgets/social_auth/social_auth_handler.dart';
import 'package:fitness_app/core/app_router/app_router.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:go_router/go_router.dart';

import 'social_auth_handler_test.mocks.dart';

@GenerateNiceMocks([
  MockSpec<LoginViewModel>(),
  MockSpec<UserCredential>(),
  MockSpec<User>(),
  MockSpec<AdditionalUserInfo>(),
])
void main() {
  late MockLoginViewModel mockViewModel;
  late MockUserCredential mockUserCredential;
  late MockUser mockUser;
  late MockAdditionalUserInfo mockAdditionalUserInfo;

  setUp(() {
    mockViewModel = MockLoginViewModel();
    mockUserCredential = MockUserCredential();
    mockUser = MockUser();
    mockAdditionalUserInfo = MockAdditionalUserInfo();

    when(mockUser.email).thenReturn('test@example.com');
    when(mockUserCredential.user).thenReturn(mockUser);
  });

   GoRouter createMockRouter() {
    return GoRouter(
      initialLocation: '/',
      routes: [
        GoRoute(path: '/', builder: (context, state) => const Scaffold(body: Text('Initial'))),
        GoRoute(name: Routes.signupName, path: '/signup', builder: (context, state) => const Scaffold(body: Text('Signup Page'))),
        GoRoute(name: Routes.homeName, path: '/home', builder: (context, state) => const Scaffold(body: Text('Home Page'))),
      ],
    );
  }

  Widget createTestWidget(GoRouter router) {
    return MaterialApp.router(
      routerConfig: router,
    );
  }

  group('SocialAuthHandler Tests', () {
    testWidgets('should show SnackBar and navigate to Signup when the user is new', (WidgetTester tester) async {
      //  Setup
      final router = createMockRouter();
      when(mockAdditionalUserInfo.isNewUser).thenReturn(true);
      when(mockUserCredential.additionalUserInfo).thenReturn(mockAdditionalUserInfo);

       await tester.pumpWidget(createTestWidget(router));

       final BuildContext context = tester.element(find.text('Initial'));

      // Action
      await SocialAuthHandler.handle(
        context: context,
        userCredential: mockUserCredential,
        viewModel: mockViewModel,
      );

      await tester.pumpAndSettle();

      //  Verify
      expect(find.text("Please complete registration"), findsOneWidget);
      expect(router.state.name, Routes.signupName);
      verifyNever(mockViewModel.doIntent(any));
    });

    testWidgets('should call doIntent and navigate to Home when user already exists', (WidgetTester tester) async {
      // 1. Setup
      final router = createMockRouter();
      when(mockAdditionalUserInfo.isNewUser).thenReturn(false);
      when(mockUserCredential.additionalUserInfo).thenReturn(mockAdditionalUserInfo);
      when(mockViewModel.doIntent(any)).thenAnswer((_) async => {});

      // 2. Build UI
      await tester.pumpWidget(createTestWidget(router));
      final BuildContext context = tester.element(find.text('Initial'));

      // 3. Action
      await SocialAuthHandler.handle(
        context: context,
        userCredential: mockUserCredential,
        viewModel: mockViewModel,
      );

      await tester.pumpAndSettle();

      // 4. Verify
      verify(mockViewModel.doIntent(argThat(isA<SocialLoginEvent>()))).called(1);
      expect(router.state.name, Routes.homeName);
    });
  });
}