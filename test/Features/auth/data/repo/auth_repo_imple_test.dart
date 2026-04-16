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
  TestWidgetsFlutterBinding.ensureInitialized();
  late AuthRepoImple authRepoImple;
  late MockAuthRemoteDataSourceContract mockRemoteDataSource;
  late MockAuthLocalDataSourceContract mockLocalDataSource;

  // --- Shared test data ---
  const tToken = 'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.test_token';

  late AuthRepoImpl authRepo;
  late MockAuthRemoteDataSourceContract mockRemote;
  late MockAuthLocalDataSourceContract mockLocal;
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
    gender: 'male',
    age: 25,
    weight: 70,
    height: 175,
    activityLevel: 'active',
    goal: 'lose weight',
    photo: '',
  );

  setUp(() {
    mockRemoteDataSource = MockAuthRemoteDataSourceContract();
    mockLocalDataSource = MockAuthLocalDataSourceContract();
    authRepoImple = AuthRepoImple(mockRemoteDataSource, mockLocalDataSource);

    provideDummy<BaseResponse<UserEntity>>(
      SuccessResponse<UserEntity>(
        data: UserEntity(
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
        ),
      ),
    );
    mockRemote = MockAuthRemoteDataSourceContract();
    mockLocal = MockAuthLocalDataSourceContract();
    authRepo = AuthRepoImpl(mockRemote, mockLocal);
  });

  group('AuthRepoImple - register', () {
    test(
      'should call remote data source and cache the token when registration is successful',
      () async {
        // ARRANGE
        final tRegisterResponse = RegisterResponse(
          message: 'User created successfully',
          user: tUser,
          token: tToken,
        );
        when(mockRemoteDataSource.register(any))
            .thenAnswer((_) async => tRegisterResponse);
        when(mockLocalDataSource.saveToken(any)).thenAnswer((_) async {
          return null;
        });

        // ACT
        final result = await authRepoImple.register(tRegisterParams);

        // ASSERT
        expect(result, isA<SuccessResponse<UserEntity>>());
        verify(mockRemoteDataSource.register(any)).called(1);
        verify(mockLocalDataSource.saveToken(tToken)).called(1);
        verifyNoMoreInteractions(mockRemoteDataSource);
        verifyNoMoreInteractions(mockLocalDataSource);
      },
    );

    test(
      'should NOT cache the token when the remote response returns a null token',
      () async {
        // ARRANGE
        final tRegisterResponseNoToken = RegisterResponse(
          message: 'User created successfully',
          user: tUser,
          token: null,
        );
        when(mockRemoteDataSource.register(any))
            .thenAnswer((_) async => tRegisterResponseNoToken);

        // ACT
        final result = await authRepoImple.register(tRegisterParams);

        // ASSERT
        expect(result, isA<SuccessResponse<UserEntity>>());
        verify(mockRemoteDataSource.register(any)).called(1);
        verifyZeroInteractions(mockLocalDataSource);
      },
    );
  // ================= Login =================
  group('Login', () {
    final tRequest = LoginRequest(email: 'test@test.com', password: '123456');
    final tToken = 'valid_token';
    final tResponse = LoginResponse(message: 'Success', token: tToken);
    final tIsRememberMe = true;

    test(
      'should NOT cache the token when the remote response returns an empty token',
      'returns SuccessResponse<LoginEntity> AND saves token when RemoteDataSource succeeds',
      () async {
        // ARRANGE
        final tRegisterResponseEmptyToken = RegisterResponse(
          message: 'User created successfully',
          user: tUser,
          token: '',
        );
        when(mockRemoteDataSource.register(any))
            .thenAnswer((_) async => tRegisterResponseEmptyToken);
        when(mockRemote.login(any)).thenAnswer((_) async => tResponse);
        when(mockLocal.saveToken(any)).thenAnswer((_) async {});
        when(mockLocal.saveRememberMe(any)).thenAnswer((_) async {});

        // ACT
        final result = await authRepoImple.register(tRegisterParams);
        final result = await authRepo.login(tRequest, tIsRememberMe);

        // ASSERT
        expect(result, isA<SuccessResponse<UserEntity>>());
        verify(mockRemoteDataSource.register(any)).called(1);
        verifyZeroInteractions(mockLocalDataSource);
        expect(result, isA<SuccessResponse<LoginEntity>>());
        verify(mockRemote.login(tRequest)).called(1);
        verify(mockLocal.saveToken(tToken)).called(1);
        verify(mockLocal.saveRememberMe(tIsRememberMe)).called(1);
      },
    );

    test(
      'should return ErrorResponse and have ZERO interactions with local data source when remote call throws an exception',
      'returns ErrorResponse AND does NOT save token when RemoteDataSource fails',
      () async {
        // ARRANGE
        when(mockRemoteDataSource.register(any))
            .thenThrow(Exception('Network error'));
        final dioError = DioException(
          requestOptions: RequestOptions(path: ''),
          type: DioExceptionType.connectionError,
        );
        when(mockRemote.login(any)).thenThrow(dioError);

        // ACT
        final result = await authRepoImple.register(tRegisterParams);
        final result = await authRepo.login(tRequest, tIsRememberMe);

        // ASSERT
        expect(result, isA<ErrorResponse<UserEntity>>());
        verify(mockRemoteDataSource.register(any)).called(1);
        verifyZeroInteractions(mockLocalDataSource);
        expect(result, isA<ErrorResponse>());
        verify(mockRemote.login(tRequest)).called(1);
        verifyNever(mockLocal.saveToken(any));
        verifyNever(mockLocal.saveRememberMe(any));
      },
    );
  });

  // ================= isLoggedIn =================
  group('isLoggedIn', () {
    test('returns true when token exists AND rememberMe is true', () async {
      when(mockLocal.getToken()).thenAnswer((_) async => 'some_token');
      when(mockLocal.getRememberMe()).thenAnswer((_) async => true);

      final result = await authRepo.isLoggedIn();

      expect(result, true);
    });

    test('returns false when token is null', () async {
      when(mockLocal.getToken()).thenAnswer((_) async => null);
      when(mockLocal.getRememberMe()).thenAnswer((_) async => true);

      final result = await authRepo.isLoggedIn();

      expect(result, false);
    });

    test('returns false when rememberMe is false', () async {
      when(mockLocal.getToken()).thenAnswer((_) async => 'some_token');
      when(mockLocal.getRememberMe()).thenAnswer((_) async => false);

      final result = await authRepo.isLoggedIn();

      expect(result, false);
    });
  });

  // ================= clearSession =================
  group('clearSession', () {
    test('should set _isCurrentSessionActive to false', () async {
      final tRequest = LoginRequest(email: 'test@test.com', password: '123456');
      final tResponse = LoginResponse(message: 'Success', token: 'token');

      when(mockRemote.login(any)).thenAnswer((_) async => tResponse);
      when(mockLocal.saveToken(any)).thenAnswer((_) async {});
      when(mockLocal.saveRememberMe(any)).thenAnswer((_) async {});

      await authRepo.login(tRequest, true);

      expect(await authRepo.isLoggedIn(), true);

      authRepo.clearSession();

      when(mockLocal.getToken()).thenAnswer((_) async => null);
      when(mockLocal.getRememberMe()).thenAnswer((_) async => false);

      final result = await authRepo.isLoggedIn();
      expect(result, false);
    });
  });

  // ================= isLoggedIn (Session Case) =================
  group('isLoggedIn Session Logic', () {
    test(
      'should correctly map the remote RegisterResponse data into a UserEntity on success',
      'should return true immediately if session is active without calling local storage',
      () async {
        // ARRANGE
        final tRegisterResponse = RegisterResponse(
          message: 'success',
          user: tUser,
          token: tToken,
        final tRequest = LoginRequest(
          email: 'test@test.com',
          password: '123456',
        );
        when(mockRemoteDataSource.register(any))
            .thenAnswer((_) async => tRegisterResponse);
        when(mockLocalDataSource.saveToken(any)).thenAnswer((_) async {
          return null;
        });
        final tResponse = LoginResponse(message: 'Success', token: 'token');

        when(mockRemote.login(any)).thenAnswer((_) async => tResponse);
        when(mockLocal.saveToken(any)).thenAnswer((_) async {});
        when(mockLocal.saveRememberMe(any)).thenAnswer((_) async {});

        // ACT
        final result = await authRepoImple.register(tRegisterParams);
        await authRepo.login(tRequest, true);

        // ASSERT
        expect(result, isA<SuccessResponse<UserEntity>>());
        final entity = (result as SuccessResponse<UserEntity>).data;
        expect(entity.id, '1');
        expect(entity.firstName, 'John');
        expect(entity.lastName, 'Doe');
        expect(entity.email, 'john.doe@example.com');
        expect(entity.gender, 'male');
        expect(entity.age, 25);
        expect(entity.weight, 70);
        expect(entity.height, 175);
        expect(entity.activityLevel, 'active');
        expect(entity.goal, 'lose weight');
        expect(entity.photo, '');
        final result = await authRepo.isLoggedIn();

        expect(result, true);

        verifyNever(mockLocal.getToken());
        verifyNever(mockLocal.getRememberMe());
      },
    );
  });
}
