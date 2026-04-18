 import 'package:fitness_app/Features/auth/data/data_sources/auth_local_data_source_contract.dart';
import 'package:fitness_app/Features/auth/data/data_sources/auth_remote_data_source_contract.dart';
import 'package:fitness_app/Features/auth/data/repo/auth_repo_imple.dart';

import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
 import 'package:fitness_app/Features/auth/data/models/forget_password_models/request/forget_password_request/forget_password_request.dart';
import 'package:fitness_app/Features/auth/data/models/forget_password_models/request/reset_password_request/reset_password_request.dart';
import 'package:fitness_app/Features/auth/data/models/forget_password_models/request/verify_reset_password_request/verify_reset_password_request.dart';
import 'package:fitness_app/Features/auth/data/models/forget_password_models/response/forget_password_response/forget_password_response.dart';
import 'package:fitness_app/Features/auth/data/models/forget_password_models/response/reset_password_response/reset_password_response.dart';
import 'package:fitness_app/Features/auth/data/models/forget_password_models/response/verify_reset_password_response/verify_reset_password_response.dart';
  import 'package:fitness_app/Features/auth/domain/entities/forget_password_entities/forget_password_entity.dart';
import 'package:fitness_app/Features/auth/domain/entities/forget_password_entities/reset_password_entity.dart';
import 'package:fitness_app/Features/auth/domain/entities/forget_password_entities/verify_reset_password_entity.dart';
import 'package:fitness_app/core/base_response/base_response.dart';

import 'auth_repo_impl_test.mocks.dart';

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


  // ================= isLoggedIn =================
  group('isLoggedIn', () {
    test('returns true when token exists', () async {
      when(mockLocal.getToken()).thenAnswer((_) async => 'some_token');

      final result = await authRepo.isLoggedIn();

      expect(result, true);
    });

    test('returns false when token is null', () async {
      when(mockLocal.getToken()).thenAnswer((_) async => null);

      final result = await authRepo.isLoggedIn();

      expect(result, false);
    });

  });

  // ================= Forget Password =================
  group('Forget Password', () {
    final tRequest = ForgetPasswordRequest(email: 'test@test.com');
    final tResponse = ForgetPasswordResponse(
      message: 'Sent',
      info: 'Check email',
    );

    test(
      'returns SuccessResponse<ForgetPasswordEntity> when RemoteDataSource succeeds',
      () async {
        when(mockRemote.forgetPassword(any)).thenAnswer((_) async => tResponse);

        final result = await authRepo.forgetPassword(tRequest);

        expect(result, isA<SuccessResponse<ForgetPasswordEntity>>());
        verify(mockRemote.forgetPassword(tRequest)).called(1);
      },
    );

    test(
      'returns ErrorResponse when RemoteDataSource throws Exception',
      () async {
        when(
          mockRemote.forgetPassword(any),
        ).thenThrow(Exception('Forget password failed'));

        final result = await authRepo.forgetPassword(tRequest);

        expect(result, isA<ErrorResponse>());
        verify(mockRemote.forgetPassword(tRequest)).called(1);
      },
    );
  });

  // ================= Verify Reset Password =================
  group('Verify Reset Password', () {
    final tRequest = VerifyResetPasswordRequest(resetCode: '123456');
    final tResponse = VerifyResetPasswordResponse(status: 'Verified');

    test(
      'returns SuccessResponse<VerifyResetPasswordEntity> when RemoteDataSource succeeds',
      () async {
        when(mockRemote.verifyPassword(any)).thenAnswer((_) async => tResponse);

        final result = await authRepo.verifyPassword(tRequest);

        expect(result, isA<SuccessResponse<VerifyResetPasswordEntity>>());
        verify(mockRemote.verifyPassword(tRequest)).called(1);
      },
    );

    test(
      'returns ErrorResponse when RemoteDataSource throws Exception',
      () async {
        when(
          mockRemote.verifyPassword(any),
        ).thenThrow(Exception('Invalid code'));

        final result = await authRepo.verifyPassword(tRequest);

        expect(result, isA<ErrorResponse>());
        verify(mockRemote.verifyPassword(tRequest)).called(1);
      },
    );
  });

  // ================= Reset Password =================
  group('Reset Password', () {
    final tRequest = ResetPasswordRequest(
      email: 'test@test.com',
      newPassword: 'newPassword',
    );

    final tResponse = ResetPasswordResponse(
      message: 'Reset done',
      token: 'token123',
    );

    test(
      'returns SuccessResponse<ResetPasswordEntity> when RemoteDataSource succeeds',
      () async {
        when(mockRemote.resetPassword(any)).thenAnswer((_) async => tResponse);

        final result = await authRepo.resetPassword(tRequest);

        expect(result, isA<SuccessResponse<ResetPasswordEntity>>());
        verify(mockRemote.resetPassword(tRequest)).called(1);
      },
    );

    test(
      'returns ErrorResponse when RemoteDataSource throws Exception',
      () async {
        when(
          mockRemote.resetPassword(any),
        ).thenThrow(Exception('Reset failed'));

        final result = await authRepo.resetPassword(tRequest);

        expect(result, isA<ErrorResponse>());
        verify(mockRemote.resetPassword(tRequest)).called(1);
      },
    );
  });
}
