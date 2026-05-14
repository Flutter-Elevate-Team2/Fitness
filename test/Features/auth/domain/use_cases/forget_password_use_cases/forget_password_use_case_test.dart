import 'package:fitness_app/Features/auth/domain/repo/auth_repo_contract.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:fitness_app/Features/auth/data/models/forget_password_models/request/forget_password_request/forget_password_request.dart';
 import 'package:fitness_app/Features/auth/domain/entities/forget_password_entities/forget_password_entity.dart';
import 'package:fitness_app/Features/auth/domain/use_cases/forget_password_use_cases/forget_password_use_case.dart';
import 'package:fitness_app/core/base_response/base_response.dart';

import 'forget_password_use_case_test.mocks.dart';

@GenerateMocks([AuthRepoContract])
void main() {
  late ForgetPasswordUseCase useCase;
  late MockAuthRepoContract mockAuthRepo;

  setUp(() {
    provideDummy<BaseResponse<ForgetPasswordEntity>>(
      SuccessResponse(
        data: ForgetPasswordEntity(message: "dummy", info: "dummy"),
      ),
    );

    mockAuthRepo = MockAuthRepoContract();
    useCase = ForgetPasswordUseCase(mockAuthRepo);
  });

  final tRequest = ForgetPasswordRequest(email: 'test@test.com');
  final tEntity = ForgetPasswordEntity(
    message: 'Email Sent',
    info: 'Check inbox',
  );

  group('ForgetPasswordUseCase', () {
    test('should return SuccessResponse when repo succeeds', () async {
      // arrange
      when(
        mockAuthRepo.forgetPassword(tRequest),
      ).thenAnswer((_) async => SuccessResponse(data: tEntity));

      // act
      final result = await useCase.forgetPassword(tRequest);

      // assert
      expect(result, isA<SuccessResponse<ForgetPasswordEntity>>());
      expect((result as SuccessResponse).data, tEntity);
      verify(mockAuthRepo.forgetPassword(tRequest)).called(1);
      verifyNoMoreInteractions(mockAuthRepo);
    });

    test('should return ErrorResponse when repo fails', () async {
      // arrange
      when(
        mockAuthRepo.forgetPassword(tRequest),
      ).thenAnswer((_) async => ErrorResponse(errorMessage: 'Invalid email'));

      // act
      final result = await useCase.forgetPassword(tRequest);

      // assert
      expect(result, isA<ErrorResponse<ForgetPasswordEntity>>());
      expect((result as ErrorResponse).errorMessage, 'Invalid email');
      verify(mockAuthRepo.forgetPassword(tRequest)).called(1);
    });
  });
}
