import 'package:fitness_app/Features/workouts/api/api_client/workouts_api.dart';
import 'package:fitness_app/Features/workouts/data/data_source_contract/workouts_remote_data_source_contract.dart';
import 'package:fitness_app/Features/workouts/data/models/difficulty_level_response/difficulty_level_response.dart';
import 'package:fitness_app/Features/workouts/data/models/exercises_response/exercises_response.dart';
import 'package:fitness_app/Features/workouts/data/models/random_muscles/response/random_muscles.dart';
import 'package:fitness_app/Features/workouts/data/models/responses/muscle_groups_response.dart';
import 'package:fitness_app/Features/workouts/data/models/responses/muscles_by_group_response.dart';
import 'package:injectable/injectable.dart';

@Injectable(as: WorkoutsRemoteDataSourceContract)
class WorkoutsRemoteDataSourceImple implements WorkoutsRemoteDataSourceContract {
 final WorkoutsApi _workoutsApi;

  WorkoutsRemoteDataSourceImple(this._workoutsApi);

  @override
  Future<DifficultyLevelResponse> getDifficultyLevelsByPrimeMover(String primeMoverMuscleId) {
  return _workoutsApi.getDifficultyLevelsByPrimeMover(primeMoverMuscleId);
  }

  @override
  Future<ExercisesResponse> getExercisesByMuscleDifficulty(String primeMoverMuscleId, String difficultyLevelId, int page) {
    return _workoutsApi.getExercisesByMuscleDifficulty(primeMoverMuscleId, difficultyLevelId, page);
  }
  @override
  Future<MuscleGroupsResponse> getMuscleGroups() {
    return _workoutsApi.getMuscleGroups();
  }

  @override
  Future<MusclesByGroupResponse> getMusclesByGroupId(String id) {
    return _workoutsApi.getMusclesByGroupId(id);
  }

  @override
  Future<RandomMuscles> getRandomMuscles() {
    return _workoutsApi.getRandomMuscles();
  }
}
