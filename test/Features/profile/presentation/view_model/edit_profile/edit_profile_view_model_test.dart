import 'dart:io';

import 'package:fitness_app/Features/profile/domain/use_cases/upload_photo_use_case.dart';
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

@GenerateMocks([EditProfileUseCase, SessionController, UploadPhotoUseCase])
import 'edit_profile_view_model_test.mocks.dart';

void main() {
  late EditProfileViewModel viewModel;
  late MockEditProfileUseCase mockEditProfileUseCase;
  late MockUploadPhotoUseCase mockUploadPhotoUseCase;
  late MockSessionController mockSessionController;
  final getIt = GetIt.instance;

  final userEntity = UserEntity(
    id: '123',
    firstName: 'Malak',
    lastName: 'Doe',
    email: 'malak@test.com',
    photo: 'https://example.com/photo.jpg',
    gender: 'female',
    age: 20,
    height: 170,
    weight: 70,
    activityLevel: 'high',
    goal: 'lose weight',
  );

  setUp(() {
    mockEditProfileUseCase = MockEditProfileUseCase();
    mockUploadPhotoUseCase = MockUploadPhotoUseCase();
    mockSessionController = MockSessionController();

    provideDummy<BaseResponse<UserEntity>>(ErrorResponse(errorMessage: ''));
    provideDummy<BaseResponse<String>>(ErrorResponse(errorMessage: ''));

    if (getIt.isRegistered<SessionController>()) {
      getIt.unregister<SessionController>();
    }
    getIt.registerSingleton<SessionController>(mockSessionController);

    viewModel = EditProfileViewModel(
      editProfileUseCase: mockEditProfileUseCase,
      uploadPhotoUseCase: mockUploadPhotoUseCase,
    );
  });

  tearDown(() {
    viewModel.close();
    if (getIt.isRegistered<SessionController>()) {
      getIt.unregister<SessionController>();
    }
  });

  group('EditProfileViewModel - Edit Profile', () {
    final request = EditProfileRequest(
      firstName: 'Malak',
      lastName: 'Doe',
      email: 'malak@test.com',
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
  });

  group('EditProfileViewModel - Upload Photo', () {
    final File testFile = File('dummy_path.jpg');

    test(
      'emits loading then success state when upload photo succeeds',
          () async {
        when(mockSessionController.user).thenReturn(userEntity);
        when(
          mockUploadPhotoUseCase.call(testFile),
        ).thenAnswer((_) async => SuccessResponse(data: 'new_photo_url.jpg'));

        final states = <EditProfileStates>[];
        final subscription = viewModel.stream.listen(states.add);

        viewModel.doIntent(UploadPhotoEvent(testFile));
        await Future.delayed(const Duration(milliseconds: 100));

        expect(states.length, 2);
        expect(states[0].uploadPhotoState?.isLoading, true);
        expect(states[1].uploadPhotoState?.isLoading, false);
        expect(states[1].uploadPhotoState?.data, 'new_photo_url.jpg');

        verify(mockSessionController.saveUser(any)).called(1);

        await subscription.cancel();
      },
    );

    test(
      'emits loading then error state when upload photo fails',
          () async {
        when(
          mockUploadPhotoUseCase.call(testFile),
        ).thenAnswer((_) async => ErrorResponse(errorMessage: 'Upload failed'));

        final states = <EditProfileStates>[];
        final subscription = viewModel.stream.listen(states.add);

        viewModel.doIntent(UploadPhotoEvent(testFile));
        await Future.delayed(const Duration(milliseconds: 100));

        expect(states.length, 2);
        expect(states[0].uploadPhotoState?.isLoading, true);
        expect(states[1].uploadPhotoState?.isLoading, false);
        expect(states[1].uploadPhotoState?.errorMessage, 'Upload failed');

        await subscription.cancel();
      },
    );

    test(
      'does not update current user or emit when view model is closed',
          () async {
        when(mockSessionController.user).thenReturn(userEntity);
        when(
          mockUploadPhotoUseCase.call(testFile),
        ).thenAnswer((_) async => SuccessResponse(data: 'new_photo_url.jpg'));

        viewModel.close();

         viewModel.doIntent(UploadPhotoEvent(testFile));
        await Future.delayed(const Duration(milliseconds: 100));

        verifyZeroInteractions(mockSessionController);
      },
    );
  });
}