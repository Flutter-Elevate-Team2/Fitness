import 'package:fitness_app/Features/workouts/data/models/difficulty_level_response/difficulty_level_response.dart';
import 'package:fitness_app/Features/workouts/data/models/exercises_response/exercises_response.dart';

abstract class WorkoutsRemoteDataSourceContract {
  Future<DifficultyLevelResponse> getDifficultyLevelsByPrimeMover(String primeMoverMuscleId);
  Future<ExercisesResponse> getExercisesByMuscleDifficulty(String primeMoverMuscleId, String difficultyLevelId, int page);
}
