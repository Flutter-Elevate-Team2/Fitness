import 'package:fitness_app/Features/workouts/domain/entities/exercise_entity.dart';
import 'package:fitness_app/Features/workouts/domain/repo/workouts_repo_contract.dart';
import 'package:fitness_app/core/base_response/base_response.dart';
import 'package:injectable/injectable.dart';
@injectable
class GetExercisesByLevelPrimeMoverMuscleUseCase {
  final WorkoutsRepoContract _workoutsRepo;

  GetExercisesByLevelPrimeMoverMuscleUseCase(this._workoutsRepo);

  Future<BaseResponse<List<ExerciseEntity>>> call(String primeMoverMuscleId, String difficultyLevelId, int page) {
    return _workoutsRepo.getExercisesByMuscleDifficulty(primeMoverMuscleId, difficultyLevelId, page);
  }
}