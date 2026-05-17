import 'package:fitness_app/Features/workouts/domain/entities/difficulty_level_entity.dart';
import 'package:fitness_app/Features/workouts/domain/repo/workouts_repo_contract.dart';
import 'package:fitness_app/Features/workouts/domain/use_cases/get_difficulty_level_use_case.dart';
import 'package:fitness_app/core/base_response/base_response.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

import 'get_difficulty_level_use_case_test.mocks.dart';

@GenerateMocks([WorkoutsRepoContract])
void main() {
  late GetDifficultyLevelUseCase useCase;
  late MockWorkoutsRepoContract mockRepo;

  setUpAll(() {
    mockRepo = MockWorkoutsRepoContract();
    useCase = GetDifficultyLevelUseCase(mockRepo);
    provideDummy<BaseResponse<List<DifficultyLevelEntity>>>(
      const SuccessResponse<List<DifficultyLevelEntity>>(data: []),
    );
  });

  group('GetDifficultyLevelUseCase', () {
    const tPrimeMoverMuscleId = 'muscle_123';
    const tLevels = [
      DifficultyLevelEntity(id: '1', name: 'Beginner'),
      DifficultyLevelEntity(id: '2', name: 'Advanced'),
    ];

    test(
      'should return list of DifficultyLevelEntity when call succeeds',
      () async {
        // ARRANGE
        const tSuccessResponse =
            SuccessResponse<List<DifficultyLevelEntity>>(data: tLevels);
        when(mockRepo.getDifficultyLevelsByPrimeMover(tPrimeMoverMuscleId))
            .thenAnswer((_) async => tSuccessResponse);

        // ACT
        final result = await useCase.call(tPrimeMoverMuscleId);

        // ASSERT
        expect(result, tSuccessResponse);
        verify(mockRepo.getDifficultyLevelsByPrimeMover(tPrimeMoverMuscleId))
            .called(1);
        verifyNoMoreInteractions(mockRepo);
      },
    );

    test(
      'should return ErrorResponse when call fails',
      () async {
        // ARRANGE
        const tErrorResponse = ErrorResponse<List<DifficultyLevelEntity>>(
          errorMessage: 'Server error',
        );
        when(mockRepo.getDifficultyLevelsByPrimeMover(tPrimeMoverMuscleId))
            .thenAnswer((_) async => tErrorResponse);

        // ACT
        final result = await useCase.call(tPrimeMoverMuscleId);

        // ASSERT
        expect(result, tErrorResponse);
        verify(mockRepo.getDifficultyLevelsByPrimeMover(tPrimeMoverMuscleId))
            .called(1);
        verifyNoMoreInteractions(mockRepo);
      },
    );
  });
}
