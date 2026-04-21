import 'package:fitness_app/Features/workouts/api/api_client/workouts_api.dart';
import 'package:fitness_app/Features/workouts/data/data_source_contract/workouts_remote_data_source_contract.dart';
import 'package:fitness_app/Features/workouts/data/models/responses/muscle_groups_response.dart';
import 'package:fitness_app/Features/workouts/data/models/responses/muscles_by_group_response.dart';
import 'package:injectable/injectable.dart';

@Injectable(as: WorkoutsRemoteDataSourceContract)
class WorkoutsRemoteDataSourceImpl implements WorkoutsRemoteDataSourceContract {
  final WorkoutsApi _api;

  WorkoutsRemoteDataSourceImpl(this._api);

  @override
  Future<MuscleGroupsResponse> getMuscleGroups() {
    return _api.getMuscleGroups();
  }

  @override
  Future<MusclesByGroupResponse> getMusclesByGroupId(String id) {
    return _api.getMusclesByGroupId(id);
  }
}
