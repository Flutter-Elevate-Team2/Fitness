import 'package:fitness_app/Features/workouts/data/models/difficulty_level_response/difficulty_level.dart';
import 'package:fitness_app/Features/workouts/data/models/difficulty_level_response/difficulty_level_hive_model.dart';
import 'package:fitness_app/Features/workouts/domain/entities/difficulty_level_entity.dart';

extension DifficultyLevelRemoteMapper on DifficultyLevel {
  DifficultyLevelHiveModel toHiveModel() {
    return DifficultyLevelHiveModel(
      id: id ?? '', 
      name: name ?? 'Unknown',
    );
  }
}

extension DifficultyLevelHiveMapper on DifficultyLevelHiveModel {
  DifficultyLevelEntity toEntity() {
    return DifficultyLevelEntity(
      id: id, 
      name: name,
    );
  }
}