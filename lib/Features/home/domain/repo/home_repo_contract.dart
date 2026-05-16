import 'package:fitness_app/Features/workouts/domain/entities/difficulty_level_entity.dart';
import 'package:fitness_app/core/base_response/base_response.dart';

abstract class HomeRepoContract {
  Future<BaseResponse<List<DifficultyLevelEntity>>> getLevels();
}
