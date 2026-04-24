import 'package:fitness_app/Features/profile/domain/entities/user_entity.dart';
import 'package:fitness_app/Features/profile/domain/use_cases/get_user_profile_use_case.dart';
import 'package:fitness_app/Features/profile/presentation/view_model/profile_events.dart';
import 'package:fitness_app/Features/profile/presentation/view_model/profile_states.dart';
import 'package:fitness_app/Features/profile/presentation/view_model/profile_view_model.dart';
import 'package:fitness_app/core/base_response/base_response.dart';
import 'package:fitness_app/core/base_state/base_state.dart';
import 'package:fitness_app/core/controller/session_controller.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'profile_view_model_test.mocks.dart';

@GenerateMocks([
  GetUserProfileUseCase,
  SessionController,
])
void main() {
  late ProfileViewModel viewModel;
  late MockGetUserProfileUseCase mockGetUserProfileUseCase;
  late MockSessionController mockSessionController;

  setUp(() {
    provideDummy<BaseResponse<String>>(ErrorResponse(errorMessage: 'dummy'));
    provideDummy<BaseResponse<UserEntity>>(
      ErrorResponse(errorMessage: 'dummy'),
    );

    mockGetUserProfileUseCase = MockGetUserProfileUseCase();
    mockSessionController = MockSessionController();
    when(mockSessionController.onLogin).thenAnswer((_) => const Stream.empty());

    viewModel = ProfileViewModel(
      mockGetUserProfileUseCase,
      mockSessionController,
    );
  });

  group('ProfileViewModel Tests', () {
    test('initial state should be ProfileStates()', () {
      expect(viewModel.state, const ProfileStates());
    });

    group('GetUserProfile Tests', () {
      final user = UserEntity(
        id: '1',
        firstName: 'John',
        lastName: 'Doe',
        email: 'john@example.com',
         photo: '',
         gender: 'Male',
        age: 20,
        weight:  70,
        height: 170,
        activityLevel: 'Intermediate',
        goal: 'Lose Weight',
      );

      test(
        'should emit loading then success and save user when GetUserProfileUseCase succeeds',
            () async {
          when(
            mockGetUserProfileUseCase.call(),
          ).thenAnswer((_) async => SuccessResponse(data: user));

          final expectation = expectLater(
            viewModel.stream,
            emitsInOrder([
              predicate<ProfileStates>(
                    (state) => state.profileState?.isLoading == true,
              ),
              predicate<ProfileStates>(
                    (state) =>
                state.profileState?.isLoading == false &&
                    state.profileState?.data == user,
              ),
            ]),
          );

          viewModel.doIntent(GetUserProfileEvent());
          await expectation;

         },
      );

      test(
        'should emit loading then error when GetUserProfileUseCase fails',
            () async {
          const errorMessage = 'Error fetching profile';
          when(
            mockGetUserProfileUseCase.call(),
          ).thenAnswer((_) async => ErrorResponse(errorMessage: errorMessage));

          final expectation = expectLater(
            viewModel.stream,
            emitsInOrder([
              predicate<ProfileStates>(
                    (state) => state.profileState?.isLoading == true,
              ),
              predicate<ProfileStates>(
                    (state) =>
                state.profileState?.isLoading == false &&
                    state.profileState?.errorMessage == errorMessage,
              ),
            ]),
          );

          viewModel.doIntent(GetUserProfileEvent());
          await expectation;
        },
      );
    });

  });
  group('ProfileStates Unit Tests', () {

    final tUser = UserEntity(
        id: '1', firstName: 'Ahmed', lastName: 'Ali', email: 'a@a.com',
        photo: '', gender: 'M', age: 25, weight: 70, height: 170,
        activityLevel: 'High', goal: 'Muscle Gain'
    );

    test('Initial state should have null profileState', () {
      const initialState = ProfileStates();
      expect(initialState.profileState, isNull);
    });

    group('copyWith should work correctly', () {

      test('should return same object when copyWith is called with no arguments', () {
        const state = ProfileStates();
        final result = state.copyWith();
        expect(result.profileState, state.profileState);
      });

      test('should update profileState with Loading state', () {
        const state = ProfileStates();
        final loadingState = BaseState<UserEntity>(isLoading: true);

        final result = state.copyWith(profileState: loadingState);

        expect(result.profileState?.isLoading, true);
        expect(result.profileState?.data, isNull);
      });

      test('should update profileState with Success data', () {
        const state = ProfileStates();
        final successState = BaseState<UserEntity>(
            isLoading: false,
            data: tUser
        );

        final result = state.copyWith(profileState: successState);

        expect(result.profileState?.isLoading, false);
        expect(result.profileState?.data, tUser);
        expect(result.profileState?.data?.firstName, 'Ahmed');
      });

      test('should update profileState with Error message', () {
        const state = ProfileStates();
        final errorState = BaseState<UserEntity>(
            isLoading: false,
            errorMessage: 'Server Error'
        );

        final result = state.copyWith(profileState: errorState);

        expect(result.profileState?.isLoading, false);
        expect(result.profileState?.errorMessage, 'Server Error');
        expect(result.profileState?.data, isNull);
      });
    });

  });
}
