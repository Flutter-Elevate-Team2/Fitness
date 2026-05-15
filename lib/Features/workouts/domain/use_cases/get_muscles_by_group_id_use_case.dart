import 'package:fitness_app/Features/workouts/domain/entities/muscle_entity.dart';
import 'package:fitness_app/Features/workouts/domain/repo/workouts_repo_contract.dart';
import 'package:fitness_app/core/base_response/base_response.dart';
import 'package:injectable/injectable.dart';

@injectable
class GetMusclesByGroupIdUseCase {
  final WorkoutsRepoContract _repository;

  GetMusclesByGroupIdUseCase(this._repository);

  Future<BaseResponse<List<MuscleEntity>>> call(String id) {
    return _repository.getMusclesByGroupId(id);
  }
}
