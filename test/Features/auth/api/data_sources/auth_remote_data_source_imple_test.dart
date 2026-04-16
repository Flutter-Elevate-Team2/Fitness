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

import 'auth_remote_data_source_imple_test.mocks.dart';

@GenerateMocks([AuthApi])
void main() {
  late AuthRemoteDataSourceImpl dataSource;
  late MockAuthApi mockAuthApi;

  setUp(() {
    mockAuthApi = MockAuthApi();
    dataSource = AuthRemoteDataSourceImpl(mockAuthApi);
  });

  // بيانات وهمية مشتركة للاختبارات
  final tUser = User(
    id: '1',
    firstName: 'John',
    lastName: 'Doe',
    email: 'john.doe@example.com',
  );

  final tRegisterRequest = RegisterRequest(
    firstName: 'John',
    lastName: 'Doe',
    email: 'john.doe@example.com',
    password: 'password123',
    rePassword: 'password123',
  );

  final tLoginRequest = LoginRequest(email: 'test@test.com', password: '123456');

  group('AuthRemoteDataSourceImpl - Register', () {
    test('should call AuthApi.register and return RegisterResponse on success', () async {
      // arrange
      final tRegisterResponse = RegisterResponse(
        message: 'User created successfully',
        user: tUser,
        token: 'test_token',
      );
      when(mockAuthApi.register(any)).thenAnswer((_) async => tRegisterResponse);

      // act
      final result = await dataSource.register(tRegisterRequest);

      // assert
      expect(result, tRegisterResponse);
      verify(mockAuthApi.register(tRegisterRequest)).called(1);
    });

    test('should throw Exception when AuthApi.register fails', () async {
      // arrange
      when(mockAuthApi.register(any)).thenThrow(Exception('Register Failed'));

      // act & assert
      expect(() => dataSource.register(tRegisterRequest), throwsException);
    });
  });

  group('AuthRemoteDataSourceImpl - Login', () {
    final tLoginResponse = LoginResponse(message: 'Success', token: 'token');

    test('should return LoginResponse when AuthApi.login succeeds', () async {
      // arrange
      when(mockAuthApi.login(any)).thenAnswer((_) async => tLoginResponse);

      // act
      final result = await dataSource.login(tLoginRequest);

      // assert
      expect(result, tLoginResponse);
      verify(mockAuthApi.login(tLoginRequest)).called(1);
    });

    test('should throw Exception when AuthApi.login fails', () async {
      // arrange
      when(mockAuthApi.login(any)).thenThrow(Exception('Login Failed'));

      // act & assert
      expect(() => dataSource.login(tLoginRequest), throwsException);
    });
  });
}