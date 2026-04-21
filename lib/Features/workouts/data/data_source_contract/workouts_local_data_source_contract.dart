import 'package:fitness_app/Features/workouts/data/models/difficulty_level_response/difficulty_level_hive_model.dart';
import 'package:fitness_app/Features/workouts/data/models/exercises_response/exercise_hive_model.dart';
 
abstract class WorkoutsLocalDataSourceContract {
  Future<void> cacheDifficultyLevels(String primeMoverMuscleId, List<DifficultyLevelHiveModel> levels);
  Future<List<DifficultyLevelHiveModel>?> getCachedDifficultyLevels(String primeMoverMuscleId);
 
  Future<void> appendCachedExercises(
    String primeMoverMuscleId,
    String difficultyLevelId,
    List<ExerciseHiveModel> newExercises,
  );
  Future<void> clearCachedExercises(String primeMoverMuscleId, String difficultyLevelId);
  Future<List<ExerciseHiveModel>?> getCachedExercises(String primeMoverMuscleId, String difficultyLevelId);
 
  Future<bool> isCacheExpired(String key, Duration ttl);
}