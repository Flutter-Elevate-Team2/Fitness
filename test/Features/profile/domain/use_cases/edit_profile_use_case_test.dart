import 'package:fitness_app/Features/profile/domain/entities/user_entity.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:fitness_app/Features/profile/data/models/edit_profile_request.dart';
 import 'package:fitness_app/Features/profile/domain/repo/profile_repo_contract.dart';
import 'package:fitness_app/Features/profile/domain/use_cases/edit_profile_use_case.dart';
import 'package:fitness_app/core/base_response/base_response.dart';

@GenerateMocks([ProfileRepoContract])
import 'edit_profile_use_case_test.mocks.dart';

void main() {
  late EditProfileUseCase useCase;
  late MockProfileRepoContract mockRepo;

  setUp(() {
    mockRepo = MockProfileRepoContract();
    useCase = EditProfileUseCase(mockRepo);

    provideDummy<BaseResponse<UserEntity>>(ErrorResponse(errorMessage: ''));
  });

  group('EditProfileUseCase', () {
    final request = EditProfileRequest(
      firstName: 'John',
      lastName: 'Doe',
      email: 'john@test.com',
    );

    final userEntity = UserEntity(
      id: '123',
      firstName: 'John',
      lastName: 'Doe',
      email: 'john@test.com',
       photo: 'url',
       gender: 'male',
      age:20,
      weight: 70,
      height: 170,
      activityLevel: 'Intermediate',
      goal: 'Lose Weight',
    );

    test('returns SuccessResponse when repo succeeds', () async {
      when(
        mockRepo.editProfile(request),
      ).thenAnswer((_) async => SuccessResponse(data: userEntity));

      final result = await useCase(request);

      expect(result, isA<SuccessResponse<UserEntity>>());
      final success = result as SuccessResponse<UserEntity>;
      expect(success.data.firstName, 'John');
      expect(success.data.email, 'john@test.com');
      verify(mockRepo.editProfile(request)).called(1);
    });

    test('returns ErrorResponse when repo fails', () async {
      when(
        mockRepo.editProfile(request),
      ).thenAnswer((_) async => ErrorResponse(errorMessage: 'Server error'));

      final result = await useCase(request);

      expect(result, isA<ErrorResponse<UserEntity>>());
      expect((result as ErrorResponse).errorMessage, 'Server error');
      verify(mockRepo.editProfile(request)).called(1);
    });

    test('delegates call directly to repo', () async {
      when(
        mockRepo.editProfile(request),
      ).thenAnswer((_) async => SuccessResponse(data: userEntity));

      await useCase(request);

      verify(mockRepo.editProfile(request)).called(1);
      verifyNoMoreInteractions(mockRepo);
    });
  });
}
