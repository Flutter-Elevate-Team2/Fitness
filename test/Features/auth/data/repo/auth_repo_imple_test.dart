import 'package:fitness_app/Features/auth/data/data_sources/auth_local_data_source_contract.dart';
import 'package:fitness_app/Features/auth/data/data_sources/auth_remote_data_source_contract.dart';
import 'package:fitness_app/Features/auth/data/models/register_response/register_response.dart';
import 'package:fitness_app/Features/auth/data/models/register_response/user.dart';
import 'package:fitness_app/Features/auth/data/repo/auth_repo_imple.dart';
import 'package:fitness_app/Features/auth/domain/entities/register_params.dart';
import 'package:fitness_app/Features/auth/domain/entities/user_entity.dart';
import 'package:fitness_app/core/base_response/base_response.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

import 'auth_repo_imple_test.mocks.dart';

@GenerateMocks([AuthRemoteDataSourceContract, AuthLocalDataSourceContract])
void main() {
  late AuthRepoImple authRepoImple;
  late MockAuthRemoteDataSourceContract mockRemoteDataSource;
  late MockAuthLocalDataSourceContract mockLocalDataSource;

  // --- Shared test data ---
  const tToken = 'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.test_token';

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

    test(
      'should NOT cache the token when the remote response returns an empty token',
      () async {
        // ARRANGE
        final tRegisterResponseEmptyToken = RegisterResponse(
          message: 'User created successfully',
          user: tUser,
          token: '',
        );
        when(mockRemoteDataSource.register(any))
            .thenAnswer((_) async => tRegisterResponseEmptyToken);

        // ACT
        final result = await authRepoImple.register(tRegisterParams);

        // ASSERT
        expect(result, isA<SuccessResponse<UserEntity>>());
        verify(mockRemoteDataSource.register(any)).called(1);
        verifyZeroInteractions(mockLocalDataSource);
      },
    );

    test(
      'should return ErrorResponse and have ZERO interactions with local data source when remote call throws an exception',
      () async {
        // ARRANGE
        when(mockRemoteDataSource.register(any))
            .thenThrow(Exception('Network error'));

        // ACT
        final result = await authRepoImple.register(tRegisterParams);

        // ASSERT
        expect(result, isA<ErrorResponse<UserEntity>>());
        verify(mockRemoteDataSource.register(any)).called(1);
        verifyZeroInteractions(mockLocalDataSource);
      },
    );

    test(
      'should correctly map the remote RegisterResponse data into a UserEntity on success',
      () async {
        // ARRANGE
        final tRegisterResponse = RegisterResponse(
          message: 'success',
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
      },
    );
  });
}
