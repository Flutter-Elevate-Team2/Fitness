import 'package:fitness_app/Features/workouts/domain/entities/difficulty_level_entity.dart';
import 'package:fitness_app/Features/workouts/domain/repo/workouts_repo_contract.dart';
import 'package:fitness_app/core/base_response/base_response.dart';
import 'package:injectable/injectable.dart';
@injectable
class GetDifficultyLevelUseCase {
  final WorkoutsRepoContract _workoutsRepo;

  GetDifficultyLevelUseCase(this._workoutsRepo);
  Future<BaseResponse<List<DifficultyLevelEntity>>>
  call(String primeMoverMuscleId) {
    return _workoutsRepo.getDifficultyLevelsByPrimeMover(primeMoverMuscleId);
  }

}