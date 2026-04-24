import 'package:fitness_app/Features/workouts/api/api_client/workouts_api.dart';
import 'package:fitness_app/Features/workouts/api/data_source_imple/workouts_remote_data_source_imple.dart';
import 'package:fitness_app/Features/workouts/data/models/difficulty_level_response/difficulty_level.dart';
import 'package:fitness_app/Features/workouts/data/models/difficulty_level_response/difficulty_level_response.dart';
import 'package:fitness_app/Features/workouts/data/models/exercises_response/exercise.dart';
import 'package:fitness_app/Features/workouts/data/models/exercises_response/exercises_response.dart';

import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

import 'workouts_remote_data_source_impl_test.mocks.dart';

@GenerateMocks([WorkoutsApi])
void main() {
  late WorkoutsRemoteDataSourceImple dataSource;
  late MockWorkoutsApi mockWorkoutsApi;

  setUp(() {
    mockWorkoutsApi = MockWorkoutsApi();
    dataSource = WorkoutsRemoteDataSourceImple(mockWorkoutsApi);
  });

  // ================= getDifficultyLevelsByPrimeMover =================
  group('getDifficultyLevelsByPrimeMover', () {
    const tPrimeMoverMuscleId = 'muscle_123';
    final tResponse = DifficultyLevelResponse(
      message: 'Success',
      totalLevels: 3,
      difficultyLevels: [
        DifficultyLevel(id: '1', name: 'Beginner'),
        DifficultyLevel(id: '2', name: 'Intermediate'),
        DifficultyLevel(id: '3', name: 'Advanced'),
      ],
    );

    test(
      'should return DifficultyLevelResponse when WorkoutsApi.getDifficultyLevelsByPrimeMover succeeds',
      () async {
        // arrange
        when(
          mockWorkoutsApi.getDifficultyLevelsByPrimeMover(tPrimeMoverMuscleId),
        ).thenAnswer((_) async => tResponse);

        // act
        final result = await dataSource.getDifficultyLevelsByPrimeMover(
          tPrimeMoverMuscleId,
        );

        // assert
        expect(result, tResponse);
        verify(
          mockWorkoutsApi.getDifficultyLevelsByPrimeMover(tPrimeMoverMuscleId),
        ).called(1);
      },
    );

    test(
      'should throw Exception when WorkoutsApi.getDifficultyLevelsByPrimeMover fails',
      () async {
        // arrange
        when(
          mockWorkoutsApi.getDifficultyLevelsByPrimeMover(any),
        ).thenThrow(Exception('Failed to fetch difficulty levels'));

        // act & assert
        expect(
          () => dataSource.getDifficultyLevelsByPrimeMover(tPrimeMoverMuscleId),
          throwsException,
        );
      },
    );
  });

  // ================= getExercisesByMuscleDifficulty =================
  group('getExercisesByMuscleDifficulty', () {
    const tPrimeMoverMuscleId = 'muscle_123';
    const tDifficultyLevelId = 'level_1';
    const tPage = 1;
    final tResponse = ExercisesResponse(
      message: 'Success',
      totalExercises: 2,
      totalPages: 1,
      currentPage: 1,
      exercises: [
        Exercise(
          id: 'ex_1',
          exercise: 'Bench Press',
          primeMoverMuscle: 'Chest',
          primaryEquipment: 'Barbell',
        ),
        Exercise(
          id: 'ex_2',
          exercise: 'Push Up',
          primeMoverMuscle: 'Chest',
          primaryEquipment: 'Bodyweight',
        ),
      ],
    );

    test(
      'should return ExercisesResponse when WorkoutsApi.getExercisesByMuscleDifficulty succeeds',
      () async {
        // arrange
        when(
          mockWorkoutsApi.getExercisesByMuscleDifficulty(
            tPrimeMoverMuscleId,
            tDifficultyLevelId,
            tPage,
          ),
        ).thenAnswer((_) async => tResponse);

        // act
        final result = await dataSource.getExercisesByMuscleDifficulty(
          tPrimeMoverMuscleId,
          tDifficultyLevelId,
          tPage,
        );

        // assert
        expect(result, tResponse);
        verify(
          mockWorkoutsApi.getExercisesByMuscleDifficulty(
            tPrimeMoverMuscleId,
            tDifficultyLevelId,
            tPage,
          ),
        ).called(1);
      },
    );

    test(
      'should throw Exception when WorkoutsApi.getExercisesByMuscleDifficulty fails',
      () async {
        // arrange
        when(
          mockWorkoutsApi.getExercisesByMuscleDifficulty(any, any, any),
        ).thenThrow(Exception('Failed to fetch exercises'));

        // act & assert
        expect(
          () => dataSource.getExercisesByMuscleDifficulty(
            tPrimeMoverMuscleId,
            tDifficultyLevelId,
            tPage,
          ),
          throwsException,
        );
      },
    );
  });
}
