import 'package:fitness_app/Features/workouts/domain/entities/muscle_group_entity.dart';
import 'package:fitness_app/Features/workouts/domain/repo/workouts_repo_contract.dart';
import 'package:fitness_app/core/base_response/base_response.dart';
import 'package:injectable/injectable.dart';

@injectable
class GetMuscleGroupsUseCase {
  final WorkoutsRepoContract _repository;

  GetMuscleGroupsUseCase(this._repository);

  Future<BaseResponse<List<MuscleGroupEntity>>> call() {
    return _repository.getMuscleGroups();
  }
}
