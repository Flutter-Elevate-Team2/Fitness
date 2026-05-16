import 'package:bloc_test/bloc_test.dart';
import 'package:fitness_app/Features/auth/domain/entities/login_entity/login_entity.dart';
import 'package:fitness_app/Features/auth/presentation/login/view_model/login_view_model.dart';
import 'package:fitness_app/Features/auth/presentation/login/view_model/login_state.dart';
import 'package:fitness_app/Features/auth/presentation/login/views/screens/login_screen.dart';
import 'package:fitness_app/core/base_state/base_state.dart';
import 'package:fitness_app/core/di/di.dart';
import 'package:fitness_app/core/l10n/app_localizations.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:go_router/go_router.dart';

class MockLoginViewModel extends MockCubit<LoginState>
    implements LoginViewModel {}

class MockGoRouter extends Mock implements GoRouter {}

void main() {
  late MockLoginViewModel mockViewModel;
  late MockGoRouter mockRouter;

  setUp(() async {
    mockViewModel = MockLoginViewModel();
    mockRouter = MockGoRouter();

    await getIt.reset();
    getIt.registerSingleton<LoginViewModel>(mockViewModel);
  });

  Widget createTestableWidget() {
    return InheritedGoRouter(
      goRouter: mockRouter,
      child: MaterialApp(
        localizationsDelegates: const [
          AppLocalizations.delegate,
          AppLocalizations.delegate,
          AppLocalizations.delegate,
        ],
        supportedLocales: const [Locale('en')],
        home: const Scaffold(body: LoginScreen()),
      ),
    );
  }

  group('LoginScreen Widget Tests', () {
    testWidgets('should show SnackBar when loginState has an error', (
      tester,
    ) async {
      whenListen(
        mockViewModel,
        Stream.fromIterable([
          const LoginState(
            loginState: BaseState(errorMessage: 'Invalid Credentials'),
          ),
        ]),
        initialState: const LoginState(),
      );

      await tester.pumpWidget(createTestableWidget());
      await tester.pump();

      expect(find.byType(SnackBar), findsOneWidget);
      expect(find.text('Invalid Credentials'), findsOneWidget);
    });

    testWidgets('should navigate to home when login is successful', (
      tester,
    ) async {
      final tLoginEntity = LoginEntity(token: '123', message: '');

      whenListen(
        mockViewModel,
        Stream.fromIterable([
          LoginState(loginState: BaseState(data: tLoginEntity)),
        ]),
        initialState: const LoginState(),
      );

      await tester.pumpWidget(createTestableWidget());
      await tester.pump();

      verify(() => mockRouter.goNamed(any())).called(1);
    });
  });
}
