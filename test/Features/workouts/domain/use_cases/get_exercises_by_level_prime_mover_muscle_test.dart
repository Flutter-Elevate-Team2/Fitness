import 'package:fitness_app/Features/workouts/domain/entities/exercise_entity.dart';
import 'package:fitness_app/Features/workouts/domain/repo/workouts_repo_contract.dart';
import 'package:fitness_app/Features/workouts/domain/use_cases/get_exercises_by_level_prime_mover_muscle.dart';
import 'package:fitness_app/core/base_response/base_response.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

import 'get_exercises_by_level_prime_mover_muscle_test.mocks.dart';

@GenerateMocks([WorkoutsRepoContract])
void main() {
  late GetExercisesByLevelPrimeMoverMuscleUseCase useCase;
  late MockWorkoutsRepoContract mockRepo;

  setUpAll(() {
    mockRepo = MockWorkoutsRepoContract();
    useCase = GetExercisesByLevelPrimeMoverMuscleUseCase(mockRepo);
    provideDummy<BaseResponse<List<ExerciseEntity>>>(
      const SuccessResponse<List<ExerciseEntity>>(data: []),
    );
  });

  group('GetExercisesByLevelPrimeMoverMuscleUseCase', () {
    const tPrimeMoverMuscleId = 'muscle_123';
    const tDifficultyLevelId = 'level_1';
    const tPage = 1;
    const tExercises = [
      ExerciseEntity(
        id: 'ex_1',
        title: 'Chest • Barbell',
        description: 'Bench Press',
        sets: 3,
        reps: 15,
        thumbnailUrl: 'https://img.youtube.com/vi/abc/hqdefault.jpg',
        videoUrl: 'https://www.youtube.com/watch?v=abc',
      ),
    ];

    test(
      'should return list of ExerciseEntity when call succeeds',
      () async {
        // ARRANGE
        const tSuccessResponse =
            SuccessResponse<List<ExerciseEntity>>(data: tExercises);
        when(mockRepo.getExercisesByMuscleDifficulty(
          tPrimeMoverMuscleId,
          tDifficultyLevelId,
          tPage,
        )).thenAnswer((_) async => tSuccessResponse);

        // ACT
        final result = await useCase.call(
          tPrimeMoverMuscleId,
          tDifficultyLevelId,
          tPage,
        );

        // ASSERT
        expect(result, tSuccessResponse);
        verify(mockRepo.getExercisesByMuscleDifficulty(
          tPrimeMoverMuscleId,
          tDifficultyLevelId,
          tPage,
        )).called(1);
        verifyNoMoreInteractions(mockRepo);
      },
    );

    test(
      'should return ErrorResponse when call fails',
      () async {
        // ARRANGE
        const tErrorResponse = ErrorResponse<List<ExerciseEntity>>(
          errorMessage: 'No exercises found',
        );
        when(mockRepo.getExercisesByMuscleDifficulty(
          tPrimeMoverMuscleId,
          tDifficultyLevelId,
          tPage,
        )).thenAnswer((_) async => tErrorResponse);

        // ACT
        final result = await useCase.call(
          tPrimeMoverMuscleId,
          tDifficultyLevelId,
          tPage,
        );

        // ASSERT
        expect(result, tErrorResponse);
        verify(mockRepo.getExercisesByMuscleDifficulty(
          tPrimeMoverMuscleId,
          tDifficultyLevelId,
          tPage,
        )).called(1);
        verifyNoMoreInteractions(mockRepo);
      },
    );
  });
}
