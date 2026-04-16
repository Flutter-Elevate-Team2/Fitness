import 'package:fitness_app/Features/auth/data/data_sources/auth_local_data_source_contract.dart';
import 'package:fitness_app/Features/auth/data/data_sources/auth_remote_data_source_contract.dart';
import 'package:fitness_app/Features/auth/data/models/login_models/login_request.dart';
import 'package:fitness_app/Features/auth/data/models/login_models/login_response.dart';
import 'package:fitness_app/Features/auth/data/models/register_response/register_response.dart';
import 'package:fitness_app/Features/auth/data/models/register_response/user.dart';
import 'package:fitness_app/Features/auth/data/repo/auth_repo_imple.dart';
import 'package:fitness_app/Features/auth/domain/entities/login_entity/login_entity.dart';
import 'package:fitness_app/Features/auth/domain/entities/register_params.dart';
import 'package:fitness_app/Features/auth/domain/entities/user_entity.dart';
import 'package:fitness_app/core/base_response/base_response.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:dio/dio.dart';

import 'auth_repo_imple_test.mocks.dart';

@GenerateMocks([AuthRemoteDataSourceContract, AuthLocalDataSourceContract])
void main() {
  late AuthRepoImpl authRepo;
  late MockAuthRemoteDataSourceContract mockRemote;
  late MockAuthLocalDataSourceContract mockLocal;

  // --- Shared test data ---
  const tToken = 'valid_token';

  final tRegisterParams = RegisterParams(
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
  );

  setUp(() {
    mockRemote = MockAuthRemoteDataSourceContract();
    mockLocal = MockAuthLocalDataSourceContract();
    authRepo = AuthRepoImpl(mockRemote, mockLocal);

    provideDummy<BaseResponse<UserEntity>>(
      SuccessResponse<UserEntity>(
        data: UserEntity(
          id: '1',
          firstName: 'a',
          lastName: 'b',
          email: 'c',
          gender: '',
          age: 0,
          weight: 0,
          height: 0,
          activityLevel: '',
          goal: '',
          photo: '',
        ),
      ),
    );

    provideDummy<BaseResponse<LoginEntity>>(
      SuccessResponse<LoginEntity>(
        data: LoginEntity(token: tToken, message: ''),
      ),
    );
  });

  group('AuthRepoImpl - Register', () {
    test(
      'should return SuccessResponse and save token when registration succeeds',
      () async {
        // arrange
        final tRegisterResponse = RegisterResponse(
          message: 'Success',
          user: tUser,
          token: tToken,
        );
        when(
          mockRemote.register(any),
        ).thenAnswer((_) async => tRegisterResponse);
        when(mockLocal.saveToken(any)).thenAnswer((_) async => Future.value());

        // act
        final result = await authRepo.register(tRegisterParams);

        // assert
        expect(result, isA<SuccessResponse<UserEntity>>());
        verify(mockRemote.register(any)).called(1);
        verify(mockLocal.saveToken(tToken)).called(1);
      },
    );

    test(
      'should NOT save token when remote response token is null or empty',
      () async {
        // arrange
        final tResponse = RegisterResponse(
          message: 'Success',
          user: tUser,
          token: null,
        );
        when(mockRemote.register(any)).thenAnswer((_) async => tResponse);

        // act
        await authRepo.register(tRegisterParams);

        // assert
        verifyNever(mockLocal.saveToken(any));
      },
    );
  });

  group('AuthRepoImpl - Login', () {
    final tRequest = LoginRequest(email: 'test@test.com', password: '123456');
    final tLoginResponse = LoginResponse(message: 'Success', token: tToken);

    test(
      'should return SuccessResponse and save token/rememberMe on success',
      () async {
        // arrange
        when(mockRemote.login(any)).thenAnswer((_) async => tLoginResponse);
        when(mockLocal.saveToken(any)).thenAnswer((_) async => Future.value());
        when(
          mockLocal.saveRememberMe(any),
        ).thenAnswer((_) async => Future.value());

        // act
        final result = await authRepo.login(tRequest, true);

        // assert
        expect(result, isA<SuccessResponse<LoginEntity>>());
        verify(mockRemote.login(tRequest)).called(1);
        verify(mockLocal.saveToken(tToken)).called(1);
        verify(mockLocal.saveRememberMe(true)).called(1);
      },
    );

    test('should return ErrorResponse when remote login fails', () async {
      // arrange
      when(mockRemote.login(any)).thenThrow(
        DioException(
          requestOptions: RequestOptions(path: ''),
          type: DioExceptionType.connectionError,
        ),
      );

      // act
      final result = await authRepo.login(tRequest, true);

      // assert
      expect(result, isA<ErrorResponse>());
      verifyNever(mockLocal.saveToken(any));
    });
  });

  group('AuthRepoImpl - isLoggedIn & Session', () {
    test(
      'isLoggedIn returns true when token exists and rememberMe is true',
      () async {
        // arrange
        when(mockLocal.getToken()).thenAnswer((_) async => tToken);
        when(mockLocal.getRememberMe()).thenAnswer((_) async => true);

        // act
        final result = await authRepo.isLoggedIn();

        // assert
        expect(result, true);
      },
    );

    test('clearSession should deactivate the current session', () async {
      // act
      authRepo.clearSession();
      when(mockLocal.getToken()).thenAnswer((_) async => null);
      when(mockLocal.getRememberMe()).thenAnswer((_) async => false);

      // assert
      final result = await authRepo.isLoggedIn();
      expect(result, false);
    });
  });
}
