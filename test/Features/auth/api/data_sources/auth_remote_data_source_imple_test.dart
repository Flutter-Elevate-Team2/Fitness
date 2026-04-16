import 'package:fitness_app/Features/auth/api/api_client/auth_api.dart';
import 'package:fitness_app/Features/auth/api/data_sources/auth_remote_data_source_imple.dart';
import 'package:fitness_app/Features/auth/data/models/login_models/login_request.dart';
import 'package:fitness_app/Features/auth/data/models/login_models/login_response.dart';
import 'package:fitness_app/Features/auth/data/models/register_request/register_request.dart';
import 'package:fitness_app/Features/auth/data/models/register_response/register_response.dart';
import 'package:fitness_app/Features/auth/data/models/register_response/user.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

import 'auth_remote_data_source_imple_test.mocks.dart';

@GenerateMocks([AuthApi])
void main() {
  late AuthRemoteDataSourceImpl dataSource;
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
    dataSource = AuthRemoteDataSourceImpl(mockAuthApi);
  });

  // ================= LOGIN =================
  group('login', () {
    final tRequest = LoginRequest(email: 'test@test.com', password: '123456');
    provideDummy<RegisterResponse>(RegisterResponse());
  });

    final tResponse = LoginResponse(message: 'Success', token: 'token');
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

    test('should return LoginResponse when AuthApi.login succeeds', () async {
      // arrange
      when(mockAuthApi.login(tRequest)).thenAnswer((_) async => tResponse);
        // ACT
        final result = await remoteDataSource.register(tRegisterRequest);

      // act
      final result = await dataSource.login(tRequest);
        // ASSERT
        expect(result, tRegisterResponse);
        verify(mockAuthApi.register(tRegisterRequest)).called(1);
        verifyNoMoreInteractions(mockAuthApi);
      },
    );

      // assert
      expect(result, tResponse);
      verify(mockAuthApi.login(tRequest)).called(1);
    });
    test(
      'should propagate the exception thrown by AuthApi.register without swallowing it',
      () async {
        // ARRANGE
        when(mockAuthApi.register(tRegisterRequest))
            .thenThrow(Exception('500 Internal Server Error'));

    test('should throw Exception when AuthApi.login fails', () async {
      // arrange
      when(mockAuthApi.login(any)).thenThrow(Exception('Login Failed'));

      // act & assert
      expect(() => dataSource.login(tRequest), throwsException);
    });
  });

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
