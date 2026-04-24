import 'package:fitness_app/Features/workouts/data/models/difficulty_level_response/difficulty_level_response.dart';
import 'package:fitness_app/Features/workouts/data/models/exercises_response/exercises_response.dart';
import 'package:fitness_app/Features/workouts/data/models/random_muscles/response/random_muscles.dart';
import 'package:fitness_app/Features/workouts/data/models/responses/muscle_groups_response.dart';
import 'package:fitness_app/Features/workouts/data/models/responses/muscles_by_group_response.dart';

abstract class WorkoutsRemoteDataSourceContract {
  Future<DifficultyLevelResponse> getDifficultyLevelsByPrimeMover(String primeMoverMuscleId);
  Future<ExercisesResponse> getExercisesByMuscleDifficulty(String primeMoverMuscleId, String difficultyLevelId, int page);
  Future<MuscleGroupsResponse> getMuscleGroups();
  Future<MusclesByGroupResponse> getMusclesByGroupId(String id);
  Future<RandomMuscles> getRandomMuscles();
}
