import 'package:fitness_app/Features/auth/api/data_sources/auth_remote_data_source_imple.dart';

import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:mockito/annotations.dart';

import 'package:fitness_app/Features/auth/api/api_client/auth_api.dart';
import 'package:fitness_app/Features/auth/data/models/forget_password_models/request/forget_password_request/forget_password_request.dart';
import 'package:fitness_app/Features/auth/data/models/forget_password_models/request/reset_password_request/reset_password_request.dart';
import 'package:fitness_app/Features/auth/data/models/forget_password_models/request/verify_reset_password_request/verify_reset_password_request.dart';
import 'package:fitness_app/Features/auth/data/models/forget_password_models/response/forget_password_response/forget_password_response.dart';
import 'package:fitness_app/Features/auth/data/models/forget_password_models/response/reset_password_response/reset_password_response.dart';
import 'package:fitness_app/Features/auth/data/models/forget_password_models/response/verify_reset_password_response/verify_reset_password_response.dart';

import 'auth_remote_data_source_impl_test.mocks.dart';

@GenerateMocks([AuthApi])
void main() {
  late AuthRemoteDataSourceImpl dataSource;
  late MockAuthApi mockAuthApi;

  setUp(() {
    mockAuthApi = MockAuthApi();
    dataSource = AuthRemoteDataSourceImpl(mockAuthApi);
  });

  // ================= FORGET PASSWORD =================
  group('forgetPassword', () {
    final tRequest = ForgetPasswordRequest(email: 'test@test.com');
    final tResponse = ForgetPasswordResponse(
      message: 'Email sent',
      info: 'Check inbox',
    );

    test(
      'should return ForgetPasswordResponse when AuthApi.forgetPassword succeeds',
      () async {
        // arrange
        when(
          mockAuthApi.forgetPassword(tRequest),
        ).thenAnswer((_) async => tResponse);

        // act
        final result = await dataSource.forgetPassword(tRequest);

        // assert
        expect(result, tResponse);
        verify(mockAuthApi.forgetPassword(tRequest)).called(1);
      },
    );

    test('should throw Exception when AuthApi.forgetPassword fails', () async {
      // arrange
      when(
        mockAuthApi.forgetPassword(any),
      ).thenThrow(Exception('Forget password failed'));

      // act & assert
      expect(() => dataSource.forgetPassword(tRequest), throwsException);
    });
  });

  // ================= VERIFY RESET PASSWORD =================
  group('verifyPassword', () {
    final tRequest = VerifyResetPasswordRequest(resetCode: '123456');
    final tResponse = VerifyResetPasswordResponse(status: 'Verified');

    test(
      'should return VerifyResetPasswordResponse when AuthApi.verifyPassword succeeds',
      () async {
        // arrange
        when(
          mockAuthApi.verifyPassword(tRequest),
        ).thenAnswer((_) async => tResponse);

        // act
        final result = await dataSource.verifyPassword(tRequest);

        // assert
        expect(result, tResponse);
        verify(mockAuthApi.verifyPassword(tRequest)).called(1);
      },
    );

    test('should throw Exception when AuthApi.verifyPassword fails', () async {
      // arrange
      when(
        mockAuthApi.verifyPassword(any),
      ).thenThrow(Exception('Invalid code'));

      // act & assert
      expect(() => dataSource.verifyPassword(tRequest), throwsException);
    });
  });

  // ================= RESET PASSWORD =================
  group('resetPassword', () {
    final tRequest = ResetPasswordRequest(
      email: 'test@test.com',
      newPassword: 'newPassword',
    );

    final tResponse = ResetPasswordResponse(
      message: 'Password reset',
      token: 'token123',
    );

    test(
      'should return ResetPasswordResponse when AuthApi.resetPassword succeeds',
      () async {
        // arrange
        when(
          mockAuthApi.resetPassword(tRequest),
        ).thenAnswer((_) async => tResponse);

        // act
        final result = await dataSource.resetPassword(tRequest);

        // assert
        expect(result, tResponse);
        verify(mockAuthApi.resetPassword(tRequest)).called(1);
      },
    );

    test('should throw Exception when AuthApi.resetPassword fails', () async {
      // arrange
      when(mockAuthApi.resetPassword(any)).thenThrow(Exception('Reset failed'));

      // act & assert
      expect(() => dataSource.resetPassword(tRequest), throwsException);
    });
  });
}
