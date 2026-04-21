sealed class ExercisesEvents {}

class GetLevels extends ExercisesEvents {
  final String primeMoverMuscleId;
  GetLevels({required this.primeMoverMuscleId});
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