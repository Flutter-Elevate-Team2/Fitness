import 'package:fitness_app/Features/workouts/data/models/exercises_response/exercise.dart';
import 'package:fitness_app/Features/workouts/data/models/exercises_response/exercise_hive_model.dart';
import 'package:fitness_app/Features/workouts/domain/entities/exercise_entity.dart';

extension ExerciseRemoteMapper on Exercise {
  ExerciseHiveModel toHiveModel() {
    return ExerciseHiveModel(
      id: id ?? '', 
      title: exercise ?? 'Unknown Exercise', 
      description: targetMuscleGroup ?? 'No description available', 
      sets: 3, 
      reps: 15, 
      thumbnailUrl: shortYoutubeDemonstration ?? '', 
      videoUrl: shortYoutubeDemonstrationLink,
    );
  }
}

extension ExerciseHiveListMapper on ExerciseHiveModel {
  ExerciseEntity toEntity() {
    return ExerciseEntity(
      id: id,
      title: title,
      description: description,
      sets: sets,
      reps: reps,
      thumbnailUrl: thumbnailUrl,
      videoUrl: videoUrl,
    );
  }
}