import 'package:fitness_app/Features/workouts/data/models/muscle_group_model.dart';
import 'package:fitness_app/Features/workouts/data/models/muscle_model.dart';

abstract class WorkoutsLocalDataSourceContract {
  Future<void> saveMuscleGroups(List<MuscleGroupModel> groups);
  Future<List<MuscleGroupModel>?> getMuscleGroups();

  Future<void> saveMuscles(String groupId, List<MuscleModel> muscles);
  Future<List<MuscleModel>?> getMuscles(String groupId);
}
