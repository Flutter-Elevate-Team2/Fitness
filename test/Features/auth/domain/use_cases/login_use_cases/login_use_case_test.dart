import 'package:fitness_app/Features/auth/data/models/login_models/login_request.dart';
import 'package:fitness_app/Features/auth/domain/entities/login_entity/login_entity.dart';
import 'package:fitness_app/Features/auth/domain/repo/auth_repo_contract.dart';
import 'package:fitness_app/Features/auth/domain/use_cases/login_use_cases/login_use_case.dart';
import 'package:fitness_app/core/base_response/base_response.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

import 'login_use_case_test.mocks.dart';

@GenerateMocks([AuthRepoContract])
void main() {
  late LoginUseCase useCase;
  late MockAuthRepoContract mockRepo;

  setUp(() {
    provideDummy<BaseResponse<LoginEntity>>(
      SuccessResponse(
        data: LoginEntity(token: "dummy", message: "dummy"),
      ),
    );

    mockRepo = MockAuthRepoContract();
    useCase = LoginUseCase(mockRepo);
  });

  final tRequest = LoginRequest(email: 'test@test.com', password: '123456');
  final tEntity = LoginEntity(message: 'Success', token: 'abc123');

  test(
    'should return SuccessResponse<LoginEntity> when repo succeeds',
        () async {
      when(
        mockRepo.login(any),
      ).thenAnswer((_) async => SuccessResponse(data: tEntity));

      final result = await useCase(tRequest);

      expect(result, isA<SuccessResponse<LoginEntity>>());
      verify(mockRepo.login(tRequest)).called(1);
    },
  );

  test('should return ErrorResponse when repo fails', () async {
    when(
      mockRepo.login(any),
    ).thenAnswer((_) async => ErrorResponse(errorMessage: 'Failed'));

    final result = await useCase(tRequest);

    expect(result, isA<ErrorResponse>());
    verify(mockRepo.login(tRequest)).called(1);
  });
}
