import 'package:fitness_app/core/data_base/hive_database_service.dart';
import 'package:fitness_app/Features/workouts/data/data_sources/workouts_local_data_source_contract.dart';
import 'package:fitness_app/Features/workouts/data/models/muscle_group_model.dart';
import 'package:fitness_app/Features/workouts/data/models/muscle_model.dart';
import 'package:hive_ce/hive.dart';
import 'package:injectable/injectable.dart';

@Injectable(as: WorkoutsLocalDataSourceContract)
class WorkoutsLocalDataSourceImpl implements WorkoutsLocalDataSourceContract {
  static const String _boxName = "workouts_box";
  static const String _muscleGroupsKey = "muscle_groups";

  Future<Box> _getBox() async {
    return await HiveDatabaseService.instance.openBox(_boxName);
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
}
