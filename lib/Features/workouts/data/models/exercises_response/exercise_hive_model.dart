import 'package:fitness_app/core/data_base/constants.dart';
import 'package:hive_ce/hive.dart';
part 'exercise_hive_model.g.dart';

@HiveType(typeId: HiveTypes.exercise) 
class ExerciseHiveModel extends HiveObject {
  @HiveField(0)
  String id;
  @HiveField(1)
  String title;
  @HiveField(2)
  String description;
  @HiveField(3)
  int sets;
  @HiveField(4)
  int reps;
  @HiveField(5)
  String thumbnailUrl;
  @HiveField(6)
  String? videoUrl;

  ExerciseHiveModel({
    required this.id,
    required this.title,
    required this.description,
    required this.sets,
    required this.reps,
    required this.thumbnailUrl,
    this.videoUrl,
  });
}