import 'package:fitness_app/Features/home/data/models/levels_respones/level.dart';
import 'package:fitness_app/Features/home/data/models/levels_respones/levels_respones.dart';
import 'package:fitness_app/Features/workouts/domain/entities/difficulty_level_entity.dart';

extension DifficultyLevelModelMapper on LevelsRespones {
  List<DifficultyLevelEntity> toEntity() {
    return (levels ?? []).map((e) => e.toEntity()).toList();
  }
}

extension LevelModelMapper on Level {
  DifficultyLevelEntity toEntity() {
    return DifficultyLevelEntity(
      id: id,
      name: name,
    );
  }
}
