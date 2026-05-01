import 'dart:io';
import 'package:fitness_app/Features/profile/domain/entities/user_entity.dart';
import 'package:fitness_app/Features/profile/data/models/user_profile_response.dart';
import 'package:fitness_app/Features/profile/data/remote_data_source_contract/profile_remote_data_source_contract.dart';
import 'package:fitness_app/Features/profile/data/repo/profile_repo_imple.dart';
import 'package:fitness_app/core/base_response/base_response.dart';

import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

import 'profile_repo_imple_test.mocks.dart';
import 'package:fitness_app/Features/profile/data/models/change_password_request/change_password_request.dart';
import 'package:fitness_app/Features/profile/data/models/edit_profile_request.dart';
import 'package:fitness_app/Features/profile/data/models/change_password_response/change_password_response.dart';
import 'package:fitness_app/Features/profile/data/models/logout_response.dart';
import 'package:fitness_app/Features/profile/domain/entities/change_password_entity.dart';
import 'package:fitness_app/Features/profile/data/models/upload_photo/upload_photo_response.dart';

@GenerateMocks([ProfileRemoteDataSourceContract])
void main() {
  late ProfileRepoImple repo;
  late MockProfileRemoteDataSourceContract mockRemoteDataSource;

  setUp(() {
    mockRemoteDataSource = MockProfileRemoteDataSourceContract();
    repo = ProfileRepoImple(mockRemoteDataSource);
  });

  // ---------------------------------------------------------------------------
  // getUserProfile
  // ---------------------------------------------------------------------------
  group('getUserProfile', () {
    final userModel = User(
      id: '1',
      firstName: 'John',
      lastName: 'Doe',
      email: 'john@test.com',
      photo: '',
      gender: 'male',
      age: 20,
      weight: 70,
      height: 170,
      activityLevel: 'Intermediate',
      goal: 'Lose Weight',
    );

    final response = UserProfileResponse(message: 'Success', user: userModel);

    test('returns SuccessResponse<userEntity> when succeeds', () async {
      when(
        mockRemoteDataSource.getUserProfile(),
      ).thenAnswer((_) async => response);

      final result = await repo.getUserProfile();

      expect(result, isA<SuccessResponse<UserEntity>>());
      final data = (result as SuccessResponse<UserEntity>).data;
      expect(data.id, '1');
      expect(data.firstName, 'John');
      verify(mockRemoteDataSource.getUserProfile()).called(1);
    });

    test('returns ErrorResponse when data source throws', () async {
      when(
        mockRemoteDataSource.getUserProfile(),
      ).thenThrow(Exception('Server error'));

      final result = await repo.getUserProfile();

      expect(result, isA<ErrorResponse<UserEntity>>());
    });
  });

  // ---------------------------------------------------------------------------
  // editProfile
  // ---------------------------------------------------------------------------
  group('editProfile', () {
    final request = EditProfileRequest(
      firstName: 'Jane',
      lastName: 'Doe',
      email: 'jane@test.com',
    );

    final userModel = User(
      id: '123',
      firstName: 'Jane',
      lastName: 'Doe',
      email: 'jane@test.com',
      photo: 'photo.jpg',
      gender: 'female',
      age: 20,
      weight: 70,
      height: 170,
      activityLevel: 'Intermediate',
      goal: 'Lose Weight',
    );

    final response = UserProfileResponse(
      message: 'Profile updated',
      user: userModel,
    );

    test(
      'returns SuccessResponse<UserEntity> when data source succeeds',
          () async {
        when(
          mockRemoteDataSource.editProfile(request),
        ).thenAnswer((_) async => response);

        final result = await repo.editProfile(request);

        expect(result, isA<SuccessResponse<UserEntity>>());
        final data = (result as SuccessResponse<UserEntity>).data;
        expect(data.firstName, 'Jane');
        expect(data.lastName, 'Doe');
        expect(data.email, 'jane@test.com');
        verify(mockRemoteDataSource.editProfile(request)).called(1);
      },
    );

    test('returns ErrorResponse when data source throws', () async {
      when(
        mockRemoteDataSource.editProfile(request),
      ).thenThrow(Exception('Network error'));

      final result = await repo.editProfile(request);

      expect(result, isA<ErrorResponse<UserEntity>>());
    });
  });

  // ---------------------------------------------------------------------------
  // changePassword
  // ---------------------------------------------------------------------------
  group('changePassword', () {
    final request = ChangePasswordRequest(
      password: 'oldPass',
      newPassword: 'newPass',
    );

    final response = ChangePasswordResponse(
      message: 'Password changed',
      token: 'new_token',
    );

    test(
      'returns SuccessResponse<ChangePasswordEntity> when succeeds',
          () async {
        when(
          mockRemoteDataSource.changePassword(request),
        ).thenAnswer((_) async => response);

        final result = await repo.changePassword(request);

        expect(result, isA<SuccessResponse<ChangePasswordEntity>>());
        final data = (result as SuccessResponse<ChangePasswordEntity>).data;
        expect(data.message, 'Password changed');
        expect(data.token, 'new_token');
        verify(mockRemoteDataSource.changePassword(request)).called(1);
      },
    );

    test('returns ErrorResponse when data source throws', () async {
      when(
        mockRemoteDataSource.changePassword(request),
      ).thenThrow(Exception('Wrong password'));

      final result = await repo.changePassword(request);

      expect(result, isA<ErrorResponse<ChangePasswordEntity>>());
    });
  });

  // ---------------------------------------------------------------------------
  // uploadPhoto
  // ---------------------------------------------------------------------------
  group('uploadPhoto', () {
    final File testFile = File('dummy_path.jpg');
    final response = UploadPhotoResponse(
      message: 'Photo uploaded successfully',
    );

    test('returns SuccessResponse<String> with message when succeeds', () async {
      when(
        mockRemoteDataSource.uploadPhoto(testFile),
      ).thenAnswer((_) async => response);

      final result = await repo.uploadPhoto(testFile);

      expect(result, isA<SuccessResponse<String>>());
      expect(
        (result as SuccessResponse<String>).data,
        'Photo uploaded successfully',
      );
      verify(mockRemoteDataSource.uploadPhoto(testFile)).called(1);
    });

    test('returns ErrorResponse when data source throws', () async {
      when(
        mockRemoteDataSource.uploadPhoto(testFile),
      ).thenThrow(Exception('Upload failed'));

      final result = await repo.uploadPhoto(testFile);

      expect(result, isA<ErrorResponse<String>>());
    });
  });

  // ---------------------------------------------------------------------------
  // logout
  // ---------------------------------------------------------------------------
  group('logout', () {
    final response = LogoutResponse(message: 'Logged out');

    test(
      'returns SuccessResponse<String> with message when succeeds',
          () async {
        when(mockRemoteDataSource.logout()).thenAnswer((_) async => response);

        final result = await repo.logout();

        expect(result, isA<SuccessResponse<String>>());
        expect((result as SuccessResponse<String>).data, 'Logged out');
        verify(mockRemoteDataSource.logout()).called(1);
      },
    );

    test('returns ErrorResponse when data source throws', () async {
      when(mockRemoteDataSource.logout()).thenThrow(Exception('Logout failed'));

      final result = await repo.logout();

      expect(result, isA<ErrorResponse<String>>());
    });
  });
}