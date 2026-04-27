import 'package:flutter_test/flutter_test.dart';
import 'package:get_it/get_it.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:fitness_app/Features/profile/data/models/edit_profile_request.dart';
import 'package:fitness_app/Features/profile/domain/entities/user_entity.dart';
import 'package:fitness_app/Features/profile/domain/use_cases/edit_profile_use_case.dart';
 import 'package:fitness_app/Features/profile/presentation/view_model/edit_profile/edit_profile_events.dart';
import 'package:fitness_app/Features/profile/presentation/view_model/edit_profile/edit_profile_states.dart';
import 'package:fitness_app/Features/profile/presentation/view_model/edit_profile/edit_profile_view_model.dart';
import 'package:fitness_app/core/base_response/base_response.dart';
import 'package:fitness_app/core/controller/session_controller.dart';

@GenerateMocks([EditProfileUseCase, SessionController])
import 'edit_profile_view_model_test.mocks.dart';

void main() {
  late EditProfileViewModel viewModel;
  late MockEditProfileUseCase mockEditProfileUseCase;
   late MockSessionController mockSessionController;
  final getIt = GetIt.instance;

  final userEntity = UserEntity(
    id: '123',
    firstName: 'John',
    lastName: 'Doe',
    email: 'john@test.com',
     photo: 'https://example.com/photo.jpg',
     gender: 'male',
   age: 20,
    height:170,
    weight: 70,
    activityLevel: 'high',
    goal: 'lose weight',
  );

  setUp(() {
    mockEditProfileUseCase = MockEditProfileUseCase();
     mockSessionController = MockSessionController();

    provideDummy<BaseResponse<UserEntity>>(ErrorResponse(errorMessage: ''));
    provideDummy<BaseResponse<String>>(ErrorResponse(errorMessage: ''));

    if (getIt.isRegistered<SessionController>()) {
      getIt.unregister<SessionController>();
    }
    getIt.registerSingleton<SessionController>(mockSessionController);

    viewModel = EditProfileViewModel(
      editProfileUseCase: mockEditProfileUseCase,
     );
  });

  tearDown(() {
    viewModel.close();
    if (getIt.isRegistered<SessionController>()) {
      getIt.unregister<SessionController>();
    }
  });

  group('EditProfileViewModel - editProfile', () {
    final request = EditProfileRequest(
      firstName: 'John',
      lastName: 'Doe',
      email: 'john@test.com',
      phone: '+201234567890',
    );

    test(
      'emits loading then success state when edit profile succeeds',
      () async {
        when(
          mockEditProfileUseCase(request),
        ).thenAnswer((_) async => SuccessResponse(data: userEntity));
        when(mockSessionController.isLoggedIn).thenReturn(true);

        final states = <EditProfileStates>[];
        final subscription = viewModel.stream.listen(states.add);

        viewModel.doIntent(EditProfileEvent(request));
        await Future.delayed(const Duration(milliseconds: 100));

        expect(states.length, 2);
        expect(states[0].editProfileState?.isLoading, true);
        expect(states[1].editProfileState?.isLoading, false);
        expect(states[1].editProfileState?.data, userEntity);

        await subscription.cancel();
      },
    );

    test('emits loading then error state when edit profile fails', () async {
      when(
        mockEditProfileUseCase(request),
      ).thenAnswer((_) async => ErrorResponse(errorMessage: 'Server error'));

      final states = <EditProfileStates>[];
      final subscription = viewModel.stream.listen(states.add);

      viewModel.doIntent(EditProfileEvent(request));
      await Future.delayed(const Duration(milliseconds: 100));

      expect(states.length, 2);
      expect(states[0].editProfileState?.isLoading, true);
      expect(states[1].editProfileState?.isLoading, false);
      expect(states[1].editProfileState?.errorMessage, 'Server error');

      await subscription.cancel();
    });

    test('does not save user to session on error', () async {
      when(
        mockEditProfileUseCase(request),
      ).thenAnswer((_) async => ErrorResponse(errorMessage: 'fail'));

      final states = <EditProfileStates>[];
      final subscription = viewModel.stream.listen(states.add);

      viewModel.doIntent(EditProfileEvent(request));
      await Future.delayed(const Duration(milliseconds: 100));

      verifyNever(mockSessionController.isLoggedIn);

      await subscription.cancel();
    });
  });

 }
