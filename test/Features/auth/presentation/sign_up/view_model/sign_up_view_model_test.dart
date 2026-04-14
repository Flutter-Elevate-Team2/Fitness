import 'package:bloc_test/bloc_test.dart';
import 'package:fitness_app/Features/auth/domain/entities/register_params.dart';
import 'package:fitness_app/Features/auth/domain/entities/user_entity.dart';
import 'package:fitness_app/Features/auth/domain/use_cases/register_use_case.dart';
import 'package:fitness_app/Features/auth/presentation/sign_up/view_model/sign_up_events.dart';
import 'package:fitness_app/Features/auth/presentation/sign_up/view_model/sign_up_states.dart';
import 'package:fitness_app/Features/auth/presentation/sign_up/view_model/sign_up_view_model.dart';
import 'package:fitness_app/core/base_response/base_response.dart';
import 'package:fitness_app/core/base_state/base_state.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

import 'sign_up_view_model_test.mocks.dart';

@GenerateMocks([RegisterUseCase])
void main() {
  late SignUpViewModel viewModel;
  late MockRegisterUseCase mockRegisterUseCase;

  // ── Shared test fixtures ──
  const tParams = RegisterParams(
    firstName: 'John',
    lastName: 'Doe',
    email: 'john@example.com',
    password: 'Password123',
    rePassword: 'Password123',
    gender: 'male',
    age: 25,
    weight: 70,
    height: 175,
    goal: 'lose_weight',
    activityLevel: 'intermediate',
  );

  const tUserEntity = UserEntity(
    id: '1',
    firstName: 'John',
    lastName: 'Doe',
    email: 'john@example.com',
    gender: 'male',
    age: 25,
    weight: 70,
    height: 175,
    activityLevel: 'intermediate',
    goal: 'lose_weight',
    photo: '',
  );

  final tEvent = OnSignUpClickEvent(
    firstName: tParams.firstName,
    lastName: tParams.lastName,
    email: tParams.email,
    password: tParams.password,
    rePassword: tParams.rePassword,
    gender: tParams.gender,
    age: tParams.age,
    weight: tParams.weight,
    height: tParams.height,
    goal: tParams.goal,
    activityLevel: tParams.activityLevel,
  );

  setUp(() {
    mockRegisterUseCase = MockRegisterUseCase();
    viewModel = SignUpViewModel(mockRegisterUseCase);

    // Provide a dummy for the sealed BaseResponse type
    provideDummy<BaseResponse<UserEntity>>(
      const SuccessResponse<UserEntity>(data: tUserEntity),
    );
  });

  group('SignUpViewModel', () {
    test('initial state should have null signUpState', () {
      expect(viewModel.state.signUpState, isNull);
    });

    blocTest<SignUpViewModel, SignUpStates>(
      'emits [loading, success] when sign up succeeds',
      build: () {
        when(mockRegisterUseCase.register(tParams)).thenAnswer(
          (_) async => const SuccessResponse<UserEntity>(data: tUserEntity),
        );
        return viewModel;
      },
      act: (vm) => vm.doIntent(tEvent),
      expect: () => [
        // 1st emission: loading
        isA<SignUpStates>().having(
          (s) => s.signUpState?.isLoading,
          'isLoading',
          true,
        ),
        // 2nd emission: success with data
        isA<SignUpStates>()
            .having((s) => s.signUpState?.isLoading, 'isLoading', false)
            .having((s) => s.signUpState?.data, 'data', tUserEntity)
            .having(
                (s) => s.signUpState?.errorMessage, 'errorMessage', isNull),
      ],
      verify: (_) {
        verify(mockRegisterUseCase.register(tParams)).called(1);
        verifyNoMoreInteractions(mockRegisterUseCase);
      },
    );

    blocTest<SignUpViewModel, SignUpStates>(
      'emits [loading, error] when sign up fails',
      build: () {
        when(mockRegisterUseCase.register(tParams)).thenAnswer(
          (_) async => const ErrorResponse<UserEntity>(
            errorMessage: 'Email already exists',
          ),
        );
        return viewModel;
      },
      act: (vm) => vm.doIntent(tEvent),
      expect: () => [
        // 1st emission: loading
        isA<SignUpStates>().having(
          (s) => s.signUpState?.isLoading,
          'isLoading',
          true,
        ),
        // 2nd emission: error
        isA<SignUpStates>()
            .having((s) => s.signUpState?.isLoading, 'isLoading', false)
            .having((s) => s.signUpState?.data, 'data', isNull)
            .having((s) => s.signUpState?.errorMessage, 'errorMessage',
                'Email already exists'),
      ],
      verify: (_) {
        verify(mockRegisterUseCase.register(tParams)).called(1);
        verifyNoMoreInteractions(mockRegisterUseCase);
      },
    );

    blocTest<SignUpViewModel, SignUpStates>(
      'calls RegisterUseCase.register with correct RegisterParams',
      build: () {
        when(mockRegisterUseCase.register(any)).thenAnswer(
          (_) async => const SuccessResponse<UserEntity>(data: tUserEntity),
        );
        return viewModel;
      },
      act: (vm) => vm.doIntent(tEvent),
      verify: (_) {
        final captured = verify(mockRegisterUseCase.register(captureAny))
            .captured
            .single as RegisterParams;
        expect(captured.firstName, 'John');
        expect(captured.lastName, 'Doe');
        expect(captured.email, 'john@example.com');
        expect(captured.password, 'Password123');
        expect(captured.rePassword, 'Password123');
        expect(captured.gender, 'male');
        expect(captured.age, 25);
        expect(captured.weight, 70);
        expect(captured.height, 175);
        expect(captured.goal, 'lose_weight');
        expect(captured.activityLevel, 'intermediate');
      },
    );
  });
}
