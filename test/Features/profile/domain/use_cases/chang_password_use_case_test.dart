import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:fitness_app/Features/profile/data/models/change_password_request/change_password_request.dart';
import 'package:fitness_app/Features/profile/domain/entities/change_password_entity.dart';
import 'package:fitness_app/Features/profile/domain/repo/profile_repo_contract.dart';
import 'package:fitness_app/Features/profile/domain/use_cases/chang_password_use_case.dart';
import 'package:fitness_app/core/base_response/base_response.dart';

import 'chang_password_use_case_test.mocks.dart';

@GenerateMocks([ProfileRepoContract])
void main() {
  late ChangPasswordUseCase useCase;
  late MockProfileRepoContract mockRepo;

  setUpAll(() {
    provideDummy<BaseResponse<ChangePasswordEntity>>(
      SuccessResponse(data:  ChangePasswordEntity(message: '', token: '')),
    );
  });

  setUp(() {
    mockRepo = MockProfileRepoContract();
    useCase = ChangPasswordUseCase(mockRepo);
  });

  final tRequest = ChangePasswordRequest(
    password: 'oldPassword123',
    newPassword: 'newPassword456',
  );

  final tEntity = ChangePasswordEntity(
    message: 'Success',
    token: 'token_abc_123',
  );

  group('ChangPasswordUseCase Coverage Tests', () {
    test('should call changePassword and return Success result', () async {
      final tResponse = SuccessResponse(data:tEntity);

      when(mockRepo.changePassword(any))
          .thenAnswer((_) async => tResponse);

      final result = await useCase.call(tRequest);

      expect(result, isA<SuccessResponse<ChangePasswordEntity>>());
      expect(result, tResponse);
      verify(mockRepo.changePassword(tRequest)).called(1);
    });

    test('should propagate exceptions thrown by the repository', () async {
      when(mockRepo.changePassword(any))
          .thenThrow(Exception('Network Error'));

      expect(() => useCase.call(tRequest), throwsException);
    });
  });
}