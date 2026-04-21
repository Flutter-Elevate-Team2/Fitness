import 'package:fitness_app/core/data_base/constants.dart';
import 'package:hive_ce/hive.dart';
part 'difficulty_level_hive_model.g.dart';

@HiveType(typeId:HiveTypes.difficultyLevel) 
class DifficultyLevelHiveModel extends HiveObject {
  @HiveField(0)
  String id;

  @HiveField(1)
  String name;

  DifficultyLevelHiveModel({required this.id, required this.name});
}