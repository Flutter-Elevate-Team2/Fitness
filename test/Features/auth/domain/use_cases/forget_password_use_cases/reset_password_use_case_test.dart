import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:fitness_app/Features/auth/data/models/forget_password_models/request/reset_password_request/reset_password_request.dart';
import 'package:fitness_app/Features/auth/domain/repo/auth_repo_contract.dart';
import 'package:fitness_app/Features/auth/domain/entities/forget_password_entities/reset_password_entity.dart';
import 'package:fitness_app/Features/auth/domain/use_cases/forget_password_use_cases/reset_password_use_case.dart';
import 'package:fitness_app/core/base_response/base_response.dart';

import 'reset_password_use_case_test.mocks.dart';

@GenerateMocks([AuthRepoContract])
void main() {
  late ResetPasswordUseCase useCase;
  late MockAuthRepoContract mockAuthRepo;

  setUp(() {
    provideDummy<BaseResponse<ResetPasswordEntity>>(
      SuccessResponse(
        data: ResetPasswordEntity(message: "dummy", token: "dummy"),
      ),
    );

    mockAuthRepo = MockAuthRepoContract();
    useCase = ResetPasswordUseCase(mockAuthRepo);
  });

  final tRequest = ResetPasswordRequest(
    email: 'test@test.com',
    newPassword: 'newPassword',
  );
  final tEntity = ResetPasswordEntity(
    message: 'Password Reset',
    token: 'token123',
  );

  group('ResetPasswordUseCase', () {
    test('should return SuccessResponse on success', () async {
      // arrange
      when(
        mockAuthRepo.resetPassword(tRequest),
      ).thenAnswer((_) async => SuccessResponse(data: tEntity));

      // act
      final result = await useCase.resetPassword(tRequest);

      // assert
      expect(result, isA<SuccessResponse<ResetPasswordEntity>>());
      expect((result as SuccessResponse).data, tEntity);
      verify(mockAuthRepo.resetPassword(tRequest)).called(1);
    });

    test('should return ErrorResponse on failure', () async {
      // arrange
      when(
        mockAuthRepo.resetPassword(tRequest),
      ).thenAnswer((_) async => ErrorResponse(errorMessage: 'Reset failed'));

      // act
      final result = await useCase.resetPassword(tRequest);

      // assert
      expect(result, isA<ErrorResponse<ResetPasswordEntity>>());
      expect((result as ErrorResponse).errorMessage, 'Reset failed');
      verify(mockAuthRepo.resetPassword(tRequest)).called(1);
    });
  });
}
