import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:fitness_app/Features/profile/domain/repo/profile_repo_contract.dart';
import 'package:fitness_app/Features/profile/domain/use_cases/logout_use_case.dart';
import 'package:fitness_app/core/base_response/base_response.dart';

import 'logout_use_case_test.mocks.dart';

@GenerateMocks([ProfileRepoContract])
void main() {
  late LogoutUseCase useCase;
  late MockProfileRepoContract mockRepo;

  setUp(() {
    provideDummy<BaseResponse<String>>(ErrorResponse(errorMessage: 'dummy'));
    mockRepo = MockProfileRepoContract();
    useCase = LogoutUseCase(mockRepo);
  });

  test('should call logout on the repository', () async {
    // arrange
    when(
      mockRepo.logout(),
    ).thenAnswer((_) async => SuccessResponse(data: 'Success'));

    // act
    final result = await useCase.call();

    // assert
    expect(result, isA<SuccessResponse<String>>());
    expect((result as SuccessResponse).data, 'Success');
    verify(mockRepo.logout()).called(1);
    verifyNoMoreInteractions(mockRepo);
  });
}
