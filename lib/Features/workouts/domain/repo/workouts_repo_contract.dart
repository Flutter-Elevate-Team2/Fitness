import 'package:fitness_app/core/base_response/base_response.dart';
import 'package:fitness_app/Features/workouts/domain/entities/muscle_group_entity.dart';
import 'package:fitness_app/Features/workouts/domain/entities/muscle_entity.dart';

abstract class WorkoutsRepoContract {
  Future<BaseResponse<List<MuscleGroupEntity>>> getMuscleGroups();
  Future<BaseResponse<List<MuscleEntity>>> getMusclesByGroupId(String id);
}
