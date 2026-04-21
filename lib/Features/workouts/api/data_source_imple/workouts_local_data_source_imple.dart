import 'package:fitness_app/Features/workouts/data/data_source_contract/workouts_local_data_source_contract.dart';
import 'package:fitness_app/Features/workouts/data/models/difficulty_level_response/difficulty_level_hive_model.dart';
import 'package:fitness_app/Features/workouts/data/models/exercises_response/exercise_hive_model.dart';
import 'package:fitness_app/core/data_base/hive_database_service.dart';
import 'package:injectable/injectable.dart';

@Injectable(as: WorkoutsLocalDataSourceContract)
class WorkoutsLocalDataSourceImple implements WorkoutsLocalDataSourceContract {
  final HiveDatabaseService _hiveDb;
  static const String _metadataBox = 'cache_metadata_box';
 
  WorkoutsLocalDataSourceImple(this._hiveDb);
 
  @override
  Future<void> cacheDifficultyLevels(String primeMoverMuscleId, List<DifficultyLevelHiveModel> levels) async {
    final box = await _hiveDb.openBox<List<dynamic>>('difficulty_levels_box');
    await box.put('levels_$primeMoverMuscleId', levels);
    await _saveTimestamp('levels_$primeMoverMuscleId');
  }
 
  @override
  Future<List<DifficultyLevelHiveModel>?> getCachedDifficultyLevels(String primeMoverMuscleId) async {
    final box = await _hiveDb.openBox<List<dynamic>>('difficulty_levels_box');
    final raw = box.get('levels_$primeMoverMuscleId');
    if (raw == null) return null;
    return raw.whereType<DifficultyLevelHiveModel>().toList();
  }
 
  @override
  Future<void> appendCachedExercises(
    String primeMoverMuscleId,
    String difficultyLevelId,
    List<ExerciseHiveModel> newExercises,
  ) async {
    final key = 'exercises_${primeMoverMuscleId}_$difficultyLevelId';
    final box = await _hiveDb.openBox<List<dynamic>>('exercises_box');
 
    // نجيب اللي موجود ونضيف عليه
    final raw = box.get(key);
    final existing = raw?.whereType<ExerciseHiveModel>().toList() ?? [];
    final merged = [...existing, ...newExercises];
 
    await box.put(key, merged);
    await _saveTimestamp(key);
  }
 
  @override
  Future<void> clearCachedExercises(String primeMoverMuscleId, String difficultyLevelId) async {
    final key = 'exercises_${primeMoverMuscleId}_$difficultyLevelId';
    final box = await _hiveDb.openBox<List<dynamic>>('exercises_box');
    await box.delete(key);
    final metaBox = await _hiveDb.openBox<dynamic>(_metadataBox);
    await metaBox.delete('ts_$key');
  }
 
  @override
  Future<List<ExerciseHiveModel>?> getCachedExercises(String primeMoverMuscleId, String difficultyLevelId) async {
    final key = 'exercises_${primeMoverMuscleId}_$difficultyLevelId';
    final box = await _hiveDb.openBox<List<dynamic>>('exercises_box');
    final raw = box.get(key);
    if (raw == null) return null;
    return raw.whereType<ExerciseHiveModel>().toList();
  }
 
  @override
  Future<bool> isCacheExpired(String key, Duration ttl) async {
    final box = await _hiveDb.openBox<dynamic>(_metadataBox);
    final lastUpdate = box.get('ts_$key') as int?;
 
    if (lastUpdate == null) return true;
 
    final lastUpdateTime = DateTime.fromMillisecondsSinceEpoch(lastUpdate);
    return DateTime.now().difference(lastUpdateTime) > ttl;
  }
 
  Future<void> _saveTimestamp(String key) async {
    final box = await _hiveDb.openBox<dynamic>(_metadataBox);
    await box.put('ts_$key', DateTime.now().millisecondsSinceEpoch);
  }
}
