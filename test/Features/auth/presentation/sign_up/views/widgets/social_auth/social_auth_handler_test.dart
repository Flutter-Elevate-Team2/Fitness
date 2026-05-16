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
  MockSpec<UserInfo>(),
])
void main() {
  late MockLoginViewModel mockViewModel;
  late MockUserCredential mockUserCredential;
  late MockUser mockUser;
  late MockAdditionalUserInfo mockAdditionalUserInfo;
  late MockUserInfo mockUserInfo;

  setUp(() {
    mockViewModel = MockLoginViewModel();
    mockUserCredential = MockUserCredential();
    mockUser = MockUser();
    mockAdditionalUserInfo = MockAdditionalUserInfo();
    mockUserInfo = MockUserInfo();

    when(mockUserInfo.email).thenReturn('test@example.com');
    when(mockUser.providerData).thenReturn([mockUserInfo]);
    when(mockUserCredential.user).thenReturn(mockUser);
  });

  GoRouter createMockRouter() {
    return GoRouter(
      initialLocation: '/',
      routes: [
        GoRoute(
          path: '/',
          builder: (context, state) => const Scaffold(body: Text('Initial')),
        ),
        GoRoute(
          name: Routes.signupName,
          path: '/signup',
          builder: (context, state) => const Scaffold(body: Text('Signup Page')),
        ),
        GoRoute(
          name: Routes.homeName,
          path: '/home',
          builder: (context, state) => const Scaffold(body: Text('Home Page')),
        ),
      ],
    );
  }

  group('SocialAuthHandler Tests', () {
    testWidgets('should show SnackBar and navigate to signup when user is new', (WidgetTester tester) async {
      final router = createMockRouter();

      when(mockAdditionalUserInfo.isNewUser).thenReturn(true);
      when(mockUserCredential.additionalUserInfo).thenReturn(mockAdditionalUserInfo);

      await tester.pumpWidget(MaterialApp.router(routerConfig: router));
      final BuildContext context = tester.element(find.text('Initial'));

      await SocialAuthHandler.handle(
        context: context,
        userCredential: mockUserCredential,
        viewModel: mockViewModel,
      );

      await tester.pump();
      expect(find.text("Please complete registration"), findsOneWidget);

      await tester.pumpAndSettle();

      expect(router.state.uri.toString(), contains('signup'));
      verifyNever(mockViewModel.doIntent(any));
    });

    testWidgets('should call doIntent and navigate to home when user already exists', (WidgetTester tester) async {
      final router = createMockRouter();

      when(mockAdditionalUserInfo.isNewUser).thenReturn(false);
      when(mockUserCredential.additionalUserInfo).thenReturn(mockAdditionalUserInfo);
      when(mockViewModel.doIntent(any)).thenAnswer((_) async => {});

      await tester.pumpWidget(MaterialApp.router(routerConfig: router));
      final BuildContext context = tester.element(find.text('Initial'));

      await SocialAuthHandler.handle(
        context: context,
        userCredential: mockUserCredential,
        viewModel: mockViewModel,
      );

      await tester.pumpAndSettle();

      verify(mockViewModel.doIntent(argThat(isA<SocialLoginEvent>()))).called(1);
      expect(router.state.uri.toString(), contains('home'));
    });

    testWidgets('should do nothing when userCredential is null', (WidgetTester tester) async {
      final router = createMockRouter();
      await tester.pumpWidget(MaterialApp.router(routerConfig: router));
      final BuildContext context = tester.element(find.text('Initial'));

      await SocialAuthHandler.handle(
        context: context,
        userCredential: null,
        viewModel: mockViewModel,
      );

      await tester.pumpAndSettle();

      verifyNever(mockViewModel.doIntent(any));
      expect(router.state.uri.toString(), '/');
    });
  });
}