import 'package:fitness_app/Features/workouts/api/api_client/workouts_api.dart';
import 'package:fitness_app/Features/workouts/api/data_source_imple/workouts_remote_data_source_imple.dart';
import 'package:fitness_app/Features/workouts/data/models/difficulty_level_response/difficulty_level_response.dart';
import 'package:fitness_app/Features/workouts/data/models/exercises_response/exercises_response.dart';
import 'package:fitness_app/Features/workouts/data/models/random_muscles/response/random_muscles.dart';
import 'package:fitness_app/Features/workouts/data/models/responses/muscle_groups_response.dart';
import 'package:fitness_app/Features/workouts/data/models/responses/muscles_by_group_response.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

import 'workouts_remote_data_source_imple_test.mocks.dart';
@GenerateMocks([WorkoutsApi])

void main() {
  late WorkoutsRemoteDataSourceImple dataSource;
  late MockWorkoutsApi mockApi;

  setUp(() {
    mockApi = MockWorkoutsApi();
    dataSource = WorkoutsRemoteDataSourceImple(mockApi);
  });

  group('getDifficultyLevelsByPrimeMover', () {
    const tMuscleId = 'chest_id';
    final tResponse = DifficultyLevelResponse(message: 'Success', difficultyLevels: []);

    test('should call api.getDifficultyLevelsByPrimeMover with correct id', () async {
      when(mockApi.getDifficultyLevelsByPrimeMover(any))
          .thenAnswer((_) async => tResponse);

      final result = await dataSource.getDifficultyLevelsByPrimeMover(tMuscleId);

      expect(result, tResponse);
      verify(mockApi.getDifficultyLevelsByPrimeMover(tMuscleId));
    });
  });

  group('getExercisesByMuscleDifficulty', () {
    const tMuscleId = 'chest_id';
    const tLevelId = 'intermediate_id';
    const tPage = 1;
    final tResponse = ExercisesResponse(message: 'Success', exercises: []);

    test('should call api.getExercisesByMuscleDifficulty with correct parameters', () async {
      when(mockApi.getExercisesByMuscleDifficulty(any, any, any))
          .thenAnswer((_) async => tResponse);

      final result = await dataSource.getExercisesByMuscleDifficulty(tMuscleId, tLevelId, tPage);

      expect(result, tResponse);
      verify(mockApi.getExercisesByMuscleDifficulty(tMuscleId, tLevelId, tPage));
    });
  });

  group('getMuscleGroups', () {
    final tResponse = MuscleGroupsResponse(message: 'Success', musclesGroup: []);

    test('should call api.getMuscleGroups and return response', () async {
      when(mockApi.getMuscleGroups()).thenAnswer((_) async => tResponse);

      final result = await dataSource.getMuscleGroups();

      expect(result, tResponse);
      verify(mockApi.getMuscleGroups());
    });
  });

  group('getMusclesByGroupId', () {
    const tGroupId = 'group_123';
    final tResponse = MusclesByGroupResponse(message: 'Success', muscles: []);

    test('should call api.getMusclesByGroupId with correct id', () async {
      when(mockApi.getMusclesByGroupId(any))
          .thenAnswer((_) async => tResponse);

      final result = await dataSource.getMusclesByGroupId(tGroupId);

      expect(result, tResponse);
      verify(mockApi.getMusclesByGroupId(tGroupId));
    });
  });

  group('getRandomMuscles', () {
    final tResponse = RandomMuscles(message: 'Success', muscles: []);

    test('should call api.getRandomMuscles and return response', () async {
      when(mockApi.getRandomMuscles()).thenAnswer((_) async => tResponse);

      final result = await dataSource.getRandomMuscles();

      expect(result, tResponse);
      verify(mockApi.getRandomMuscles());
    });
  });
}