import 'package:fitness_app/Features/profile/api/api_client/api_client.dart';
import 'package:fitness_app/Features/profile/api/remot_data_source_imple/profile_remote_data_source_imple.dart';
import 'package:fitness_app/Features/profile/data/models/user_profile_response.dart';
import 'package:fitness_app/Features/profile/data/models/change_password_request/change_password_request.dart';
 import 'package:fitness_app/Features/profile/data/models/edit_profile_request.dart';
import 'package:fitness_app/Features/profile/data/models/change_password_response/change_password_response.dart';
import 'package:fitness_app/Features/profile/data/models/logout_response.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

@GenerateMocks([ProfileApi])
import 'profile_remote_data_source_imple_test.mocks.dart';

void main() {
  late ProfileRemoteDataSourceImple dataSource;
  late MockProfileApi mockApi;

  setUp(() {
    mockApi = MockProfileApi();
    dataSource = ProfileRemoteDataSourceImple(mockApi);
  });


  // ---------------------------------------------------------------------------
  // getUserProfile
  // ---------------------------------------------------------------------------
  group('getUserProfile', () {
    final response = UserProfileResponse(
      message: 'Success',
      user: User(id: '1', firstName: 'John'),
    );

    test(
      'delegates to ProfileApi.getUserProfile and returns the response',
      () async {
        when(mockApi.getUserProfile()).thenAnswer((_) async => response);

        final result = await dataSource.getUserProfile();

        expect(result, response);
        verify(mockApi.getUserProfile()).called(1);
      },
    );

    test('throws when ProfileApi.getUserProfile throws', () async {
      when(mockApi.getUserProfile()).thenThrow(Exception('Not found'));

      expect(() => dataSource.getUserProfile(), throwsException);
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
      phone: '+201234567890',
    );

    final response = UserProfileResponse(
      message: 'Updated',
      user: User(id: '1', firstName: 'Jane'),
    );

    test(
      'delegates to ProfileApi.editProfile and returns the response',
          () async {
        when(mockApi.editProfile(request)).thenAnswer((_) async => response);

        final result = await dataSource.editProfile(request);

        expect(result, response);
        verify(mockApi.editProfile(request)).called(1);
      },
    );

    test('throws when ProfileApi.editProfile throws', () async {
      when(mockApi.editProfile(request)).thenThrow(Exception('API error'));

      expect(() => dataSource.editProfile(request), throwsException);
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
      message: 'Changed',
      token: 'new_token',
    );

    test(
      'delegates to ProfileApi.changePassword and returns the response',
          () async {
        when(mockApi.changePassword(request)).thenAnswer((_) async => response);

        final result = await dataSource.changePassword(request);

        expect(result, response);
        verify(mockApi.changePassword(request)).called(1);
      },
    );

    test('throws when ProfileApi.changePassword throws', () async {
      when(mockApi.changePassword(request)).thenThrow(Exception('API error'));

      expect(() => dataSource.changePassword(request), throwsException);
    });
  });

  // ---------------------------------------------------------------------------
  // logout
  // ---------------------------------------------------------------------------
  group('logout', () {
    final response = LogoutResponse(message: 'Logged out');

    test('delegates to ProfileApi.logout and returns the response', () async {
      when(mockApi.logout()).thenAnswer((_) async => response);

      final result = await dataSource.logout();

      expect(result, response);
      verify(mockApi.logout()).called(1);
    });

    test('throws when ProfileApi.logout throws', () async {
      when(mockApi.logout()).thenThrow(Exception('Logout failed'));

      expect(() => dataSource.logout(), throwsException);
    });
  });

}
