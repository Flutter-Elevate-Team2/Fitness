
import 'package:fitness_app/Features/workouts/domain/entities/difficulty_level_entity.dart';
import 'package:fitness_app/Features/workouts/domain/entities/exercise_entity.dart';
import 'package:fitness_app/core/base_response/base_response.dart';

abstract class WorkoutsRepoContract {
  Future<BaseResponse<List<DifficultyLevelEntity>>> getDifficultyLevelsByPrimeMover(String primeMoverMuscleId);
  Future<BaseResponse<List<ExerciseEntity>>> getExercisesByMuscleDifficulty(String primeMoverMuscleId, String difficultyLevelId,int page,);
}
