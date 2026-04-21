import 'package:fitness_app/Features/workouts/data/data_source_contract/workouts_local_data_source_contract.dart';
import 'package:fitness_app/Features/workouts/data/data_source_contract/workouts_remote_data_source_contract.dart';
import 'package:fitness_app/Features/workouts/data/mapper/difficulty_level_mapper.dart';
import 'package:fitness_app/Features/workouts/data/mapper/exercise_mapper.dart';
import 'package:fitness_app/Features/workouts/data/models/difficulty_level_response/difficulty_level_hive_model.dart';
import 'package:fitness_app/Features/workouts/data/models/difficulty_level_response/difficulty_level_response.dart';
import 'package:fitness_app/Features/workouts/domain/entities/difficulty_level_entity.dart';
import 'package:fitness_app/Features/workouts/domain/entities/exercise_entity.dart';
import 'package:fitness_app/Features/workouts/domain/repo/workouts_repo_contract.dart';
import 'package:fitness_app/core/base_response/base_response.dart';
import 'package:fitness_app/core/errors/error_strings.dart';
import 'package:fitness_app/core/errors/handel_errors.dart';
import 'package:fitness_app/core/mixins/cache_execution_mixin.dart';
import 'package:fitness_app/core/network/network_info.dart';
import 'package:flutter/material.dart';
import 'package:injectable/injectable.dart';

@Injectable(as: WorkoutsRepoContract)
class WorkoutsRepoImple with CacheExecutionMixin implements WorkoutsRepoContract {
  final WorkoutsRemoteDataSourceContract _remoteDataSource;
  final WorkoutsLocalDataSourceContract _localDataSource;
 
  @override
  final NetworkInfo networkInfo;
 
  WorkoutsRepoImple(this._remoteDataSource, this._localDataSource, this.networkInfo);
 
  @override
  Future<BaseResponse<List<DifficultyLevelEntity>>> getDifficultyLevelsByPrimeMover(String primeMoverMuscleId) {
    return executeWithCache<DifficultyLevelResponse, List<DifficultyLevelHiveModel>?, List<DifficultyLevelEntity>>(
      fetchFromRemote: () => _remoteDataSource.getDifficultyLevelsByPrimeMover(primeMoverMuscleId),
      fetchFromCache: () => _localDataSource.getCachedDifficultyLevels(primeMoverMuscleId),
      isExpired: () => _localDataSource.isCacheExpired('levels_$primeMoverMuscleId', const Duration(hours: 24)),
      saveToCache: (remoteModel) async {
        final hiveList = remoteModel.difficultyLevels?.map((e) => e.toHiveModel()).toList() ?? [];
        await _localDataSource.cacheDifficultyLevels(primeMoverMuscleId, hiveList);
      },
      remoteMapper: (remoteModel) =>
          remoteModel.difficultyLevels?.map((e) => e.toHiveModel().toEntity()).toList() ?? [],
      cacheMapper: (localList) => localList?.map((e) => e.toEntity()).toList() ?? [],
    );
  }
 
  @override
  Future<BaseResponse<List<ExerciseEntity>>> getExercisesByMuscleDifficulty(
    String primeMoverMuscleId,
    String difficultyLevelId,
    int page,
  ) async {
    final cacheKey = 'exercises_${primeMoverMuscleId}_$difficultyLevelId';
 
    if (page == 1) {
      final isExpired = await _localDataSource.isCacheExpired(cacheKey, const Duration(hours: 24));
      final cachedData = await _localDataSource.getCachedExercises(primeMoverMuscleId, difficultyLevelId);
      final hasCache = cachedData != null;
 
      debugPrint('--- Exercises Cache (page 1) ---');
      debugPrint('Has Cache: $hasCache | Is Expired: $isExpired');
 
      if (hasCache && !isExpired) {
        debugPrint(' Returning cached exercises');
        return SuccessResponse(data: cachedData.map((e) => e.toEntity()).toList());
      }
 
      await _localDataSource.clearCachedExercises(primeMoverMuscleId, difficultyLevelId);
    }
 
    final isOnline = await networkInfo.isConnected;
    if (!isOnline) {
      final cachedData = await _localDataSource.getCachedExercises(primeMoverMuscleId, difficultyLevelId);
      if (cachedData != null) {
        debugPrint(' Offline. Returning cached exercises as fallback');
        return SuccessResponse(data: cachedData.map((e) => e.toEntity()).toList());
      }
      return const ErrorResponse(errorMessage: ErrorStrings.emptyCacheError);
    }
    try {
      debugPrint(' Fetching page $page from API...');
      final remoteData = await _remoteDataSource.getExercisesByMuscleDifficulty(
        primeMoverMuscleId,
        difficultyLevelId,
        page,
      );
 
      final hiveList = remoteData.exercises?.map((e) => e.toHiveModel()).toList() ?? [];
 
      await _localDataSource.appendCachedExercises(primeMoverMuscleId, difficultyLevelId, hiveList);
 
      return SuccessResponse(
        data: hiveList.map((e) => e.toEntity()).toList(),
      );
    } catch (e) {
      final cachedData = await _localDataSource.getCachedExercises(primeMoverMuscleId, difficultyLevelId);
      if (cachedData != null) {
        debugPrint(' API Failed. Returning stale cache as fallback');
        return SuccessResponse(data: cachedData.map((e) => e.toEntity()).toList());
      }
      return ErrorResponse(errorMessage: ErrorHandler.handleError(e));
    }
  }
}
