import 'package:fitness_app/Features/workouts/domain/entities/exercise_entity.dart';

sealed class ExercisesEvents {}

class GetLevels extends ExercisesEvents {
  final String primeMoverMuscleId;
  final String? fixedLevelId;

  GetLevels({
    required this.primeMoverMuscleId,
    this.fixedLevelId,
  });
}

class ChangeLevel extends ExercisesEvents {
  final String primeMoverMuscleId;
  final String newDifficultyLevelId;

  ChangeLevel({
    required this.primeMoverMuscleId,
    required this.newDifficultyLevelId,
  });
}

class LoadMoreExercises extends ExercisesEvents {
  final String primeMoverMuscleId;
  final String difficultyLevelId;

  LoadMoreExercises({
    required this.primeMoverMuscleId,
    required this.difficultyLevelId,
  });
}

class LoadPreloadedExercises extends ExercisesEvents {
  final List<ExerciseEntity> exercises;

  LoadPreloadedExercises({required this.exercises});
}
