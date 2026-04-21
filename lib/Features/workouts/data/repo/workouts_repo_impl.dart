import 'package:fitness_app/Features/workouts/data/data_source_contract/workouts_local_data_source_contract.dart';
import 'package:fitness_app/Features/workouts/data/data_source_contract/workouts_remote_data_source_contract.dart';
import 'package:fitness_app/Features/workouts/data/mapper/workouts_mappers.dart';
import 'package:fitness_app/Features/workouts/data/models/muscle_group_model.dart';
import 'package:fitness_app/Features/workouts/data/models/muscle_model.dart';
import 'package:fitness_app/Features/workouts/data/models/responses/muscle_groups_response.dart';
import 'package:fitness_app/Features/workouts/data/models/responses/muscles_by_group_response.dart';
import 'package:fitness_app/Features/workouts/domain/entities/muscle_entity.dart';
import 'package:fitness_app/Features/workouts/domain/entities/muscle_group_entity.dart';
import 'package:fitness_app/Features/workouts/domain/repo/workouts_repo_contract.dart';
import 'package:fitness_app/core/base_response/base_response.dart';
import 'package:fitness_app/core/network/network_info.dart';
import 'package:fitness_app/core/mixins/cache_execution_mixin.dart';
import 'package:injectable/injectable.dart';

@Injectable(as: WorkoutsRepoContract)
class WorkoutsRepoImpl with CacheExecutionMixin implements WorkoutsRepoContract {
  final WorkoutsRemoteDataSourceContract _remoteDataSource;
  final WorkoutsLocalDataSourceContract _localDataSource;
  final NetworkInfo _networkInfo;

  WorkoutsRepoImpl(
    this._remoteDataSource,
    this._localDataSource,
    this._networkInfo,
  );

  @override
  NetworkInfo get networkInfo => _networkInfo;

  @override
  Future<BaseResponse<List<MuscleGroupEntity>>> getMuscleGroups() async {
    return executeWithCache<MuscleGroupsResponse, List<MuscleGroupModel>?, List<MuscleGroupEntity>>(
      fetchFromRemote: () => _remoteDataSource.getMuscleGroups(),
      fetchFromCache: () => _localDataSource.getMuscleGroups(),
      saveToCache: (data) async {
        if (data.musclesGroup != null) {
          await _localDataSource.saveMuscleGroups(data.musclesGroup!);
        }
      },
      remoteMapper: (data) => data.musclesGroup.toEntityList(),
      cacheMapper: (data) => data.toEntityList(),
    );
  }

  @override
  Future<BaseResponse<List<MuscleEntity>>> getMusclesByGroupId(String id) async {
    return executeWithCache<MusclesByGroupResponse, List<MuscleModel>?, List<MuscleEntity>>(
      fetchFromRemote: () => _remoteDataSource.getMusclesByGroupId(id),
      fetchFromCache: () => _localDataSource.getMuscles(id),
      saveToCache: (data) async {
        if (data.muscles != null) {
          await _localDataSource.saveMuscles(id, data.muscles!);
        }
      },
      remoteMapper: (data) => data.muscles.toEntityList(),
      cacheMapper: (data) => data.toEntityList(),
    );
  }
}
