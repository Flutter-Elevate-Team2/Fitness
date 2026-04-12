import 'package:fitness_app/Features/auth/data/data_sources/auth_local_data_source_contract.dart';
import 'package:fitness_app/Features/auth/data/data_sources/auth_remote_data_source_contract.dart';
import 'package:fitness_app/Features/auth/data/models/login_models/login_request.dart';
import 'package:fitness_app/Features/auth/data/models/login_models/login_response.dart';
import 'package:fitness_app/Features/auth/data/repo/auth_repo_imple.dart';
import 'package:fitness_app/Features/auth/domain/entities/login_entity/login_entity.dart';
import 'package:fitness_app/core/base_response/base_response.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:dio/dio.dart';

import 'auth_repo_imple_test.mocks.dart';

@GenerateMocks([AuthRemoteDataSourceContract, AuthLocalDataSourceContract])
void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  late AuthRepoImpl authRepo;
  late MockAuthRemoteDataSourceContract mockRemote;
  late MockAuthLocalDataSourceContract mockLocal;

  setUp(() {
    mockRemote = MockAuthRemoteDataSourceContract();
    mockLocal = MockAuthLocalDataSourceContract();
    authRepo = AuthRepoImpl(mockRemote, mockLocal);
  });

  // ================= Login =================
  group('Login', () {
    final tRequest = LoginRequest(email: 'test@test.com', password: '123456');
    final tToken = 'valid_token';
    final tResponse = LoginResponse(message: 'Success', token: tToken);
    final tIsRememberMe = true;

    test(
      'returns SuccessResponse<LoginEntity> AND saves token when RemoteDataSource succeeds',
      () async {
        when(mockRemote.login(any)).thenAnswer((_) async => tResponse);
        when(mockLocal.saveToken(any)).thenAnswer((_) async {});
        when(mockLocal.saveRememberMe(any)).thenAnswer((_) async {});

        final result = await authRepo.login(tRequest, tIsRememberMe);

        expect(result, isA<SuccessResponse<LoginEntity>>());
        verify(mockRemote.login(tRequest)).called(1);
        verify(mockLocal.saveToken(tToken)).called(1);
        verify(mockLocal.saveRememberMe(tIsRememberMe)).called(1);
      },
    );

    test(
      'returns ErrorResponse AND does NOT save token when RemoteDataSource fails',
      () async {
        final dioError = DioException(
          requestOptions: RequestOptions(path: ''),
          type: DioExceptionType.connectionError,
        );
        when(mockRemote.login(any)).thenThrow(dioError);

        final result = await authRepo.login(tRequest, tIsRememberMe);

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
      'should return true immediately if session is active without calling local storage',
      () async {
        final tRequest = LoginRequest(
          email: 'test@test.com',
          password: '123456',
        );
        final tResponse = LoginResponse(message: 'Success', token: 'token');

        when(mockRemote.login(any)).thenAnswer((_) async => tResponse);
        when(mockLocal.saveToken(any)).thenAnswer((_) async {});
        when(mockLocal.saveRememberMe(any)).thenAnswer((_) async {});

        await authRepo.login(tRequest, true);

        final result = await authRepo.isLoggedIn();

        expect(result, true);

        verifyNever(mockLocal.getToken());
        verifyNever(mockLocal.getRememberMe());
      },
    );
  });
}
