import 'package:bloc_test/bloc_test.dart';
import 'package:fitness_app/Features/auth/domain/entities/login_entity/login_entity.dart';
import 'package:fitness_app/Features/auth/domain/use_cases/login_use_cases/login_use_case.dart';
import 'package:fitness_app/Features/auth/presentation/login/view_model/login_event.dart';
import 'package:fitness_app/Features/auth/presentation/login/view_model/login_state.dart';
import 'package:fitness_app/Features/auth/presentation/login/view_model/login_view_model.dart';
import 'package:fitness_app/core/base_response/base_response.dart';
import 'package:fitness_app/core/base_state/base_state.dart';
import 'package:fitness_app/core/controller/session_controller.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

import 'login_view_model_test.mocks.dart';

@GenerateMocks([LoginUseCase, SessionController])
void main() {
  late LoginViewModel viewModel;
  late MockLoginUseCase mockLoginUseCase;
  late MockSessionController mockSessionController;

  setUp(() {
    mockLoginUseCase = MockLoginUseCase();
    mockSessionController = MockSessionController();
    viewModel = LoginViewModel(mockLoginUseCase, mockSessionController);
  });

  provideDummy<BaseResponse<LoginEntity>>(
    SuccessResponse(
      data: LoginEntity(token: '', message: ''),
    ),
  );

  group('LoginViewModel Tests', () {
    test('initial state should be LoginState', () {
      expect(viewModel.state, const LoginState());
    });

    final tLoginEntity = LoginEntity(token: 'token123', message: '');

    blocTest<LoginViewModel, LoginState>(
      'emits [loading, success] states and notifies session when login succeeds',
      build: () {
        when(
          mockLoginUseCase.call(any),
        ).thenAnswer((_) async => SuccessResponse(data: tLoginEntity));
        return viewModel;
      },
      act: (bloc) => bloc.doIntent(
        LoginButtonClickedEvent(email: 'test@test.com', password: 'password'),
      ),
      expect: () => [
        isA<LoginState>().having(
          (s) => s.loginState?.isLoading,
          'isLoading',
          true,
        ),
        isA<LoginState>().having(
          (s) => s.loginState?.data,
          'data',
          tLoginEntity,
        ),
      ],
      verify: (_) {
        verify(mockSessionController.notifyLogin()).called(1);
      },
    );

    blocTest<LoginViewModel, LoginState>(
      'emits [loading, error] states when login fails',
      build: () {
        when(
          mockLoginUseCase.call(any),
        ).thenAnswer(
          (_) async => ErrorResponse(errorMessage: 'Invalid Credentials'),
        );
        return viewModel;
      },
      act: (bloc) => bloc.doIntent(
        LoginButtonClickedEvent(email: 'wrong@test.com', password: 'wrong'),
      ),
      expect: () => [
        isA<LoginState>().having(
          (s) => s.loginState?.isLoading,
          'isLoading',
          true,
        ),
        isA<LoginState>().having(
          (s) => s.loginState?.errorMessage,
          'error',
          'Invalid Credentials',
        ),
      ],
    );

    blocTest<LoginViewModel, LoginState>(
      'resets loginState when UserTypingEvent is added and there was an error',
      build: () => viewModel,
      seed: () =>
          const LoginState(loginState: BaseState(errorMessage: 'Some Error')),
      act: (bloc) => bloc.doIntent(UserTypingEvent()),
      expect: () => [const LoginState(loginState: BaseState())],
    );

    blocTest<LoginViewModel, LoginState>(
      'emits initial state when LoginInitialEvent is added',
      build: () => viewModel,
      act: (bloc) => bloc.doIntent(LoginInitialEvent()),
      expect: () => [const LoginState()],
    );

    blocTest<LoginViewModel, LoginState>(
      'resets loginState when UserTypingEvent is added and it was loading',
      build: () => viewModel,
      seed: () => const LoginState(loginState: BaseState(isLoading: true)),
      act: (bloc) => bloc.doIntent(UserTypingEvent()),
      expect: () => [const LoginState(loginState: BaseState(isLoading: false))],
    );

    blocTest<LoginViewModel, LoginState>(
      'does NOT emit anything when UserTypingEvent is added and there is no error or loading',
      build: () => viewModel,
      seed: () => const LoginState(loginState: BaseState()),
      act: (bloc) => bloc.doIntent(UserTypingEvent()),
      expect: () => [],
    );
  });
}
