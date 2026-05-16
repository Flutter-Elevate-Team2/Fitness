import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:fitness_app/Features/auth/data/models/forget_password_models/request/verify_reset_password_request/verify_reset_password_request.dart';
import 'package:fitness_app/Features/auth/domain/repo/auth_repo_contract.dart';
import 'package:fitness_app/Features/auth/domain/entities/forget_password_entities/verify_reset_password_entity.dart';
import 'package:fitness_app/Features/auth/domain/use_cases/forget_password_use_cases/verify_reset_password_use_case.dart';
import 'package:fitness_app/core/base_response/base_response.dart';

import 'verify_reset_password_use_case_test.mocks.dart';

@GenerateMocks([AuthRepoContract])
void main() {
  late VerifyResetPasswordUseCase useCase;
  late MockAuthRepoContract mockAuthRepo;

  setUp(() {
    provideDummy<BaseResponse<VerifyResetPasswordEntity>>(
      SuccessResponse(data: VerifyResetPasswordEntity(status: 'dummy')),
    );

    mockAuthRepo = MockAuthRepoContract();
    useCase = VerifyResetPasswordUseCase(mockAuthRepo);
  });

  final tRequest = VerifyResetPasswordRequest(resetCode: '123456');
  final tEntity = VerifyResetPasswordEntity(status: 'Verified');

  group('VerifyResetPasswordUseCase', () {
    test('should return SuccessResponse when verification succeeds', () async {
      // arrange
      when(
        mockAuthRepo.verifyPassword(tRequest),
      ).thenAnswer((_) async => SuccessResponse(data: tEntity));

      // act
      final result = await useCase.verifyPassword(tRequest);

      // assert
      expect(result, isA<SuccessResponse<VerifyResetPasswordEntity>>());
      expect((result as SuccessResponse).data, tEntity);
      verify(mockAuthRepo.verifyPassword(tRequest)).called(1);
    });

    test('should return ErrorResponse when verification fails', () async {
      // arrange
      when(
        mockAuthRepo.verifyPassword(tRequest),
      ).thenAnswer((_) async => ErrorResponse(errorMessage: 'Invalid code'));

      // act
      final result = await useCase.verifyPassword(tRequest);

      // assert
      expect(result, isA<ErrorResponse<VerifyResetPasswordEntity>>());
      expect((result as ErrorResponse).errorMessage, 'Invalid code');
      verify(mockAuthRepo.verifyPassword(tRequest)).called(1);
    });
  });
}
