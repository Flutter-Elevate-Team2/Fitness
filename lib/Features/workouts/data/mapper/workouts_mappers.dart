import 'package:fitness_app/Features/workouts/data/models/muscle_group_model.dart';
import 'package:fitness_app/Features/workouts/data/models/muscle_model.dart';
import 'package:fitness_app/Features/workouts/domain/entities/muscle_group_entity.dart';
import 'package:fitness_app/Features/workouts/domain/entities/muscle_entity.dart';

extension MuscleGroupModelMapper on MuscleGroupModel {
  MuscleGroupEntity toEntity() {
    return MuscleGroupEntity(
      id: id,
      name: name,
    );
  }
}

extension MuscleGroupModelListMapper on List<MuscleGroupModel>? {
  List<MuscleGroupEntity> toEntityList() {
    return this?.map((model) => model.toEntity()).toList() ?? [];
  }
}

extension MuscleModelMapper on MuscleModel {
  MuscleEntity toEntity() {
    return MuscleEntity(
      id: id,
      name: name,
      image: image,
    );
  }
}

extension MuscleModelListMapper on List<MuscleModel>? {
  List<MuscleEntity> toEntityList() {
    return this?.map((model) => model.toEntity()).toList() ?? [];
  }
}
