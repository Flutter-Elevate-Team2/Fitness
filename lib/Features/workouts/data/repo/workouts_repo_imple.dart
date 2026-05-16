import 'package:fitness_app/Features/workouts/data/data_source_contract/workouts_local_data_source_contract.dart';
import 'package:fitness_app/Features/workouts/data/data_source_contract/workouts_remote_data_source_contract.dart';
import 'package:fitness_app/Features/workouts/data/mapper/difficulty_level_mapper.dart';
import 'package:fitness_app/Features/workouts/data/mapper/exercise_mapper.dart';
import 'package:fitness_app/Features/workouts/data/mapper/random_muscles_mapper.dart';
import 'package:fitness_app/Features/workouts/data/mapper/workouts_mappers.dart';
import 'package:fitness_app/Features/workouts/data/models/difficulty_level_response/difficulty_level_hive_model.dart';
import 'package:fitness_app/Features/workouts/data/models/difficulty_level_response/difficulty_level_response.dart';
import 'package:fitness_app/Features/workouts/data/models/exercises_response/exercise.dart';
import 'package:fitness_app/Features/workouts/data/models/exercises_response/exercise_hive_model.dart';
import 'package:fitness_app/Features/workouts/data/models/muscle_group_model.dart';
import 'package:fitness_app/Features/workouts/data/models/muscle_model.dart';
import 'package:fitness_app/Features/workouts/data/models/random_muscle_model.dart';
import 'package:fitness_app/Features/workouts/data/models/random_muscles/response/random_muscles.dart';
import 'package:fitness_app/Features/workouts/data/models/responses/muscle_groups_response.dart';
import 'package:fitness_app/Features/workouts/data/models/responses/muscles_by_group_response.dart';
import 'package:fitness_app/Features/workouts/domain/entities/difficulty_level_entity.dart';
import 'package:fitness_app/Features/workouts/domain/entities/exercise_entity.dart';
import 'package:fitness_app/Features/workouts/domain/entities/muscle_entity.dart';
import 'package:fitness_app/Features/workouts/domain/entities/muscle_group_entity.dart';
import 'package:fitness_app/Features/workouts/domain/entities/random_muscles_entity.dart';
import 'package:fitness_app/Features/workouts/domain/repo/workouts_repo_contract.dart';
import 'package:fitness_app/core/base_response/base_response.dart';
import 'package:fitness_app/core/errors/error_strings.dart';
import 'package:fitness_app/core/errors/handel_errors.dart';
import 'package:fitness_app/core/mixins/cache_execution_mixin.dart';
import 'package:fitness_app/core/network/network_info.dart';
import 'package:flutter/foundation.dart';
import 'package:injectable/injectable.dart';

@Injectable(as: WorkoutsRepoContract)
class WorkoutsRepoImple
    with CacheExecutionMixin
    implements WorkoutsRepoContract {
  final WorkoutsRemoteDataSourceContract _remoteDataSource;
  final WorkoutsLocalDataSourceContract _localDataSource;

  @override
  final NetworkInfo networkInfo;

  WorkoutsRepoImple(
    this._remoteDataSource,
    this._localDataSource,
    this.networkInfo,
  );


  @override
  Future<BaseResponse<List<DifficultyLevelEntity>>>
  getDifficultyLevelsByPrimeMover(String primeMoverMuscleId) {
    return executeWithCache<
      DifficultyLevelResponse,
      List<DifficultyLevelHiveModel>?,
      List<DifficultyLevelEntity>
    >(
      fetchFromRemote: () =>
          _remoteDataSource.getDifficultyLevelsByPrimeMover(primeMoverMuscleId),
      fetchFromCache: () =>
          _localDataSource.getCachedDifficultyLevels(primeMoverMuscleId),
      isExpired: () => _localDataSource.isCacheExpired(
        'levels_$primeMoverMuscleId',
        const Duration(hours: 24),
      ),
      saveToCache: (remoteModel) async {
        final hiveList =
            remoteModel.difficultyLevels
                ?.map((e) => e.toHiveModel())
                .toList() ??
            [];
        await _localDataSource.cacheDifficultyLevels(
          primeMoverMuscleId,
          hiveList,
        );
      },
      remoteMapper: (remoteModel) =>
          remoteModel.difficultyLevels
              ?.map((e) => e.toHiveModel().toEntity())
              .toList() ??
          [],
      cacheMapper: (localList) =>
          localList?.map((e) => e.toEntity()).toList() ?? [],
    );
  }


  @override
  Future<BaseResponse<List<ExerciseEntity>>> getExercisesByMuscleDifficulty(
    String primeMoverMuscleId,
    String difficultyLevelId,
    int page,
  ) async {
    final safeMuscleid = primeMoverMuscleId.replaceAll(
      RegExp(r'[^a-zA-Z0-9]'),
      '_',
    );
    final safeLevelId = difficultyLevelId.replaceAll(
      RegExp(r'[^a-zA-Z0-9]'),
      '_',
    );
    final cacheKey = 'exercises_${safeMuscleid}_$safeLevelId';

    if (page == 1) {
      final isExpired = await _localDataSource.isCacheExpired(
        cacheKey,
        const Duration(hours: 24),
      );
      final cachedData = await _localDataSource.getCachedExercises(
        primeMoverMuscleId,
        difficultyLevelId,
      );
      final hasCache = cachedData != null && cachedData.isNotEmpty;

      if (hasCache && !isExpired) {
        return SuccessResponse(
          data: cachedData.map((e) => e.toEntity()).toList(),
        );
      }

      await _localDataSource.clearCachedExercises(
        primeMoverMuscleId,
        difficultyLevelId,
      );
    }

    final isOnline = await networkInfo.isConnected;

    if (!isOnline) {
      final cachedData = await _localDataSource.getCachedExercises(
        primeMoverMuscleId,
        difficultyLevelId,
      );
      if (cachedData != null && cachedData.isNotEmpty) {
        return SuccessResponse(
          data: cachedData.map((e) => e.toEntity()).toList(),
        );
      }
      return const ErrorResponse(errorMessage: ErrorStrings.emptyCacheError);
    }

    try {
      final remoteData = await _remoteDataSource.getExercisesByMuscleDifficulty(
        primeMoverMuscleId,
        difficultyLevelId,
        page,
      );

      final hiveList = await compute(
        _mapExercisesToHive,
        remoteData.exercises ?? [],
      );

      if (hiveList.isNotEmpty) {
        await _localDataSource.appendCachedExercises(
          primeMoverMuscleId,
          difficultyLevelId,
          hiveList,
        );
      }

      return SuccessResponse(data: hiveList.map((e) => e.toEntity()).toList());
    } catch (e) {
      final cachedData = await _localDataSource.getCachedExercises(
        primeMoverMuscleId,
        difficultyLevelId,
      );
      if (cachedData != null && cachedData.isNotEmpty) {
        return SuccessResponse(
          data: cachedData.map((e) => e.toEntity()).toList(),
        );
      }
      return ErrorResponse(errorMessage: ErrorHandler.handleError(e));
    }
  }

  @override
  Future<BaseResponse<List<MuscleGroupEntity>>> getMuscleGroups() async {
    return executeWithCache<
      MuscleGroupsResponse,
      List<MuscleGroupModel>?,
      List<MuscleGroupEntity>
    >(
      isExpired: () async => false,
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
  Future<BaseResponse<List<MuscleEntity>>> getMusclesByGroupId(
    String id,
  ) async {
    return executeWithCache<
      MusclesByGroupResponse,
      List<MuscleModel>?,
      List<MuscleEntity>
    >(
      isExpired: () async => false,
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

  @override
  Future<BaseResponse<List<RandomMusclesEntity>>> getRandomMuscles() {
    return executeWithCache<
      RandomMuscles,
      List<RandomMuscleModel>?,
      List<RandomMusclesEntity>
    >(
      isExpired: () => _localDataSource.isCacheExpired(
        'random_muscles_key',
        const Duration(hours: 24),
      ),

      fetchFromRemote: () => _remoteDataSource.getRandomMuscles(),

      fetchFromCache: () => _localDataSource.getCachedRandomMuscles(),

      saveToCache: (remoteModel) async {
        final hiveList =
            remoteModel.muscles?.map((e) => e.toHiveModel()).toList() ?? [];
        await _localDataSource.cacheRandomMuscles(hiveList);
      },

      remoteMapper: (remoteModel) =>
          remoteModel.muscles
              ?.map((e) => e.toHiveModel().toEntity())
              .toList() ??
          [],

      cacheMapper: (localList) =>
          localList?.map((e) => e.toEntity()).toList() ?? [],
    );
  }
}

List<ExerciseHiveModel> _mapExercisesToHive(List<Exercise> exercises) =>
    exercises.map((e) => e.toHiveModel()).toList();
