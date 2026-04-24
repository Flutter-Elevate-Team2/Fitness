import 'package:fitness_app/Features/workouts/data/data_source_contract/workouts_local_data_source_contract.dart';
import 'package:fitness_app/Features/workouts/data/models/difficulty_level_response/difficulty_level_hive_model.dart';
import 'package:fitness_app/Features/workouts/data/models/exercises_response/exercise_hive_model.dart';
import 'package:fitness_app/Features/workouts/data/models/muscle_group_model.dart';
import 'package:fitness_app/Features/workouts/data/models/muscle_model.dart';
import 'package:fitness_app/core/data_base/hive_database_service.dart';
import 'package:hive_ce/hive.dart';
import 'package:injectable/injectable.dart';

@Injectable(as: WorkoutsLocalDataSourceContract)
class WorkoutsLocalDataSourceImple implements WorkoutsLocalDataSourceContract {
  final HiveDatabaseService _hiveDb;
  static const String _boxName = "workouts_box";
  static const String _muscleGroupsKey = "muscle_groups";
  static const String _metadataBoxName = 'cache_metadata_box';
  static const String _difficultyLevelsBoxName = 'difficulty_levels_box';
  static const String _exercisesBoxName = 'exercises_box';

  WorkoutsLocalDataSourceImple(this._hiveDb);

  // ─────────────────────────────────────────────
  // Lazy Box Getters
  // ─────────────────────────────────────────────
  Future<Box<List<dynamic>>> get _levelsBox =>
      _hiveDb.openBox<List<dynamic>>(_difficultyLevelsBoxName);

  Future<Box<List<dynamic>>> get _exercisesBox =>
      _hiveDb.openBox<List<dynamic>>(_exercisesBoxName);

  Future<Box<dynamic>> get _metaBox =>
      _hiveDb.openBox<dynamic>(_metadataBoxName);

  // ─────────────────────────────────────────────
  // Difficulty Levels
  // ─────────────────────────────────────────────
  @override
  Future<void> cacheDifficultyLevels(
    String primeMoverMuscleId,
    List<DifficultyLevelHiveModel> levels,
  ) async {
    final key = _levelsKey(primeMoverMuscleId);
    final box = await _levelsBox;
    await box.put(key, levels);
    await _saveTimestamp(key);
  }

  @override
  Future<List<DifficultyLevelHiveModel>?> getCachedDifficultyLevels(
    String primeMoverMuscleId,
  ) async {
    final box = await _levelsBox;
    final raw = box.get(_levelsKey(primeMoverMuscleId));
    if (raw == null) return null;
    return raw.whereType<DifficultyLevelHiveModel>().toList();
  }

  // ─────────────────────────────────────────────
  // Exercises
  // ─────────────────────────────────────────────
  @override
  Future<void> appendCachedExercises(
    String primeMoverMuscleId,
    String difficultyLevelId,
    List<ExerciseHiveModel> newExercises,
  ) async {
    if (newExercises.isEmpty) return;

    final key = _exercisesKey(primeMoverMuscleId, difficultyLevelId);
    final box = await _exercisesBox;

    final raw = box.get(key);
    final existing = raw?.whereType<ExerciseHiveModel>().toList() ?? [];

    final existingIds = existing.map((e) => e.id).toSet();
    final uniqueNew =
        newExercises.where((e) => !existingIds.contains(e.id)).toList();

    if (uniqueNew.isEmpty) return;

    final merged = [...existing, ...uniqueNew];
    await box.put(key, merged);
    await _saveTimestamp(key);
  }

  @override
  Future<void> clearCachedExercises(
    String primeMoverMuscleId,
    String difficultyLevelId,
  ) async {
    final key = _exercisesKey(primeMoverMuscleId, difficultyLevelId);
    final box = await _exercisesBox;
    await box.delete(key);

    final meta = await _metaBox;
    await meta.delete('ts_$key');
  }

  @override
  Future<List<ExerciseHiveModel>?> getCachedExercises(
    String primeMoverMuscleId,
    String difficultyLevelId,
  ) async {
    final box = await _exercisesBox;
    final raw = box.get(_exercisesKey(primeMoverMuscleId, difficultyLevelId));
    if (raw == null) return null;
    return raw.whereType<ExerciseHiveModel>().toList();
  }

  // ─────────────────────────────────────────────
  // Cache Expiry
  // ─────────────────────────────────────────────
  @override
  Future<bool> isCacheExpired(String key, Duration ttl) async {
    final meta = await _metaBox;
    final lastUpdate = meta.get('ts_$key') as int?;
    if (lastUpdate == null) return true;

    final lastUpdateTime = DateTime.fromMillisecondsSinceEpoch(lastUpdate);
    return DateTime.now().difference(lastUpdateTime) > ttl;
  }

  // ─────────────────────────────────────────────
  // Private Helpers
  // ─────────────────────────────────────────────
  Future<void> _saveTimestamp(String key) async {
    final meta = await _metaBox;
    await meta.put('ts_$key', DateTime.now().millisecondsSinceEpoch);
  }
   Future<Box> _getBox() async {
    return await _hiveDb.openBox(_boxName);
  }

  @override
  Future<void> saveMuscleGroups(List<MuscleGroupModel> groups) async {
    final box = await _getBox();
    await box.put(_muscleGroupsKey, groups);
  }

  @override
  Future<List<MuscleGroupModel>?> getMuscleGroups() async {
    final box = await _getBox();
    final data = box.get(_muscleGroupsKey);
    if (data != null) {
      return List<MuscleGroupModel>.from(data);
    }
    return null;
  }

  @override
  Future<void> saveMuscles(String groupId, List<MuscleModel> muscles) async {
    final box = await _getBox();
    await box.put("muscles_$groupId", muscles);
  }

  @override
  Future<List<MuscleModel>?> getMuscles(String groupId) async {
    final box = await _getBox();
    final data = box.get("muscles_$groupId");
    if (data != null) {
      return List<MuscleModel>.from(data);
    }
    return null;
  }

  String _sanitize(String input) =>
      input.replaceAll(RegExp(r'[^a-zA-Z0-9]'), '_');

  String _levelsKey(String primeMoverMuscleId) =>
      'levels_${_sanitize(primeMoverMuscleId)}';

  String _exercisesKey(String primeMoverMuscleId, String difficultyLevelId) =>
      'exercises_${_sanitize(primeMoverMuscleId)}_${_sanitize(difficultyLevelId)}';
}
