import 'package:fitness_app/Features/auth/api/api_client/auth_api.dart';
import 'package:fitness_app/Features/auth/api/data_sources/auth_remote_data_source_imple.dart';
import 'package:fitness_app/Features/auth/data/models/register_request/register_request.dart';
import 'package:fitness_app/Features/auth/data/models/register_response/register_response.dart';
import 'package:fitness_app/Features/auth/data/models/register_response/user.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

import 'auth_remote_data_source_imple_test.mocks.dart';

@GenerateMocks([AuthApi])
void main() {
  late AuthRemoteDataSourceImple remoteDataSource;
  late MockAuthApi mockAuthApi;

  final tRegisterRequest = RegisterRequest(
    firstName: 'John',
    lastName: 'Doe',
    email: 'john.doe@example.com',
    password: 'password123',
    rePassword: 'password123',
    gender: 'male',
    age: 25,
    weight: 70,
    height: 175,
    activityLevel: 'active',
    goal: 'lose weight',
  );

  final tUser = User(
    id: '1',
    firstName: 'John',
    lastName: 'Doe',
    email: 'john.doe@example.com',
    gender: 'male',
    age: 25,
    weight: 70,
    height: 175,
    activityLevel: 'active',
    goal: 'lose weight',
    photo: '',
  );

  setUp(() {
    mockAuthApi = MockAuthApi();
    remoteDataSource = AuthRemoteDataSourceImple(mockAuthApi);

    provideDummy<RegisterResponse>(RegisterResponse());
  });

  group('AuthRemoteDataSourceImple - register', () {
    test(
      'should call AuthApi.register and return the RegisterResponse on success',
      () async {
        // ARRANGE
        final tRegisterResponse = RegisterResponse(
          message: 'User created successfully',
          user: tUser,
          token: 'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.test_token',
        );
        when(mockAuthApi.register(tRegisterRequest))
            .thenAnswer((_) async => tRegisterResponse);

        // ACT
        final result = await remoteDataSource.register(tRegisterRequest);

        // ASSERT
        expect(result, tRegisterResponse);
        verify(mockAuthApi.register(tRegisterRequest)).called(1);
        verifyNoMoreInteractions(mockAuthApi);
      },
    );

    test(
      'should propagate the exception thrown by AuthApi.register without swallowing it',
      () async {
        // ARRANGE
        when(mockAuthApi.register(tRegisterRequest))
            .thenThrow(Exception('500 Internal Server Error'));

        // ACT & ASSERT
        expect(
          () => remoteDataSource.register(tRegisterRequest),
          throwsA(isA<Exception>()),
        );
        verify(mockAuthApi.register(tRegisterRequest)).called(1);
        verifyNoMoreInteractions(mockAuthApi);
      },
    );
  });
}
