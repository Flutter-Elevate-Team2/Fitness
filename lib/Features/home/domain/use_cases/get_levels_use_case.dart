import 'package:fitness_app/Features/home/domain/repo/home_repo_contract.dart';
import 'package:fitness_app/Features/workouts/domain/entities/difficulty_level_entity.dart';
import 'package:fitness_app/core/base_response/base_response.dart';
import 'package:injectable/injectable.dart';

@injectable
class GetLevelsUseCase {
  final HomeRepoContract _homeRepoContract;
  GetLevelsUseCase(this._homeRepoContract);
  Future<BaseResponse<List<DifficultyLevelEntity>>> call() async {
    return await _homeRepoContract.getLevels();
  }
}
