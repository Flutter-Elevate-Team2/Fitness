import 'package:fitness_app/Features/workouts/data/models/random_muscle_model.dart';
import 'package:fitness_app/Features/workouts/data/models/random_muscles/response/random_muscles.dart';
import 'package:fitness_app/Features/workouts/domain/entities/random_muscles_entity.dart';

extension RandomMuscleRemoteMapper on Muscles {
  RandomMuscleModel toHiveModel() {
    return RandomMuscleModel(
      id: id ?? '',
      name: name ?? '',
      image: image ?? '',
    );
  }
}

extension RandomMuscleHiveMapper on RandomMuscleModel {
  RandomMusclesEntity toEntity() {
    return RandomMusclesEntity(
      id: id,
      name: name,
      image: image,
    );
  }
}