import 'package:fitness_app/Features/workouts/data/models/responses/muscle_groups_response.dart';
import 'package:fitness_app/Features/workouts/data/models/responses/muscles_by_group_response.dart';

abstract class WorkoutsRemoteDataSourceContract {
  Future<MuscleGroupsResponse> getMuscleGroups();
  Future<MusclesByGroupResponse> getMusclesByGroupId(String id);
}
