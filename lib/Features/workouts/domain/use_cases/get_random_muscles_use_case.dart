import 'package:fitness_app/Features/workouts/domain/entities/random_muscles_entity.dart';
import 'package:fitness_app/Features/workouts/domain/repo/workouts_repo_contract.dart';
import 'package:fitness_app/core/base_response/base_response.dart';
import 'package:injectable/injectable.dart';

@injectable
class GetRandomMusclesUseCase {
  final WorkoutsRepoContract _repository;

  GetRandomMusclesUseCase(this._repository);

  Future<BaseResponse<List<RandomMusclesEntity>>> call() {
    return _repository.getRandomMuscles();
  }
}
