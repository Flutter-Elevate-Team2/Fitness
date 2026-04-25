import 'package:fitness_app/Features/profile/domain/entities/user_entity.dart';
import 'package:fitness_app/Features/profile/domain/repo/profile_repo_contract.dart';
import 'package:fitness_app/Features/profile/domain/use_cases/get_user_profile_use_case.dart';
import 'package:fitness_app/core/base_response/base_response.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

import 'get_user_profile_use_case_test.mocks.dart';

@GenerateMocks([ProfileRepoContract])
void main() {
  late GetUserProfileUseCase useCase;
  late MockProfileRepoContract mockRepo;

  setUp(() {
    provideDummy<BaseResponse<UserEntity>>(
      ErrorResponse(errorMessage: 'dummy'),
    );
    mockRepo = MockProfileRepoContract();
    useCase = GetUserProfileUseCase(mockRepo);
  });

  final user = UserEntity(
    id: '1',
    firstName: 'John',
    lastName: 'Doe',
    email: 'john@example.com',
     photo: '',
  gender: "",
  age: 20,
    weight:  70,
  height: 170,
  activityLevel: 'Intermediate',
  goal: 'Lose Weight',
  );

  test('should call getUserProfile on the repository', () async {
    // arrange
    when(
      mockRepo.getUserProfile(),
    ).thenAnswer((_) async => SuccessResponse(data: user));

    // act
    final result = await useCase.call();

    // assert
    expect(result, isA<SuccessResponse<UserEntity>>());
    expect((result as SuccessResponse).data, user);
    verify(mockRepo.getUserProfile()).called(1);
    verifyNoMoreInteractions(mockRepo);
  });
}
