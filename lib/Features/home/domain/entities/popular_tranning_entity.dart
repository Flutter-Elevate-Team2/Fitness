
import 'package:equatable/equatable.dart';
import 'package:fitness_app/Features/workouts/domain/entities/exercise_entity.dart';
class PopularWorkoutEntity extends Equatable {
  final String muscleId;
  final String muscleName;
  final String muscleImage;
  final String levelId;
  final String levelName;
  final List<ExerciseEntity> exercises;

  const PopularWorkoutEntity({
    required this.muscleId,
    required this.muscleName,
    required this.muscleImage,
    required this.levelId,
    required this.levelName,
    required this.exercises,
  });

  int get totalExercises => exercises.length;

  @override
  List<Object?> get props => [muscleId, levelId];
}
