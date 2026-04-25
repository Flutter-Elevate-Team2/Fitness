import 'dart:math';
import 'package:fitness_app/Features/home/domain/entities/popular_tranning_entity.dart';
import 'package:fitness_app/Features/home/domain/repo/home_repo_contract.dart';
import 'package:fitness_app/Features/workouts/domain/entities/exercise_entity.dart';
import 'package:fitness_app/Features/workouts/domain/entities/random_muscles_entity.dart';
import 'package:fitness_app/Features/workouts/domain/entities/difficulty_level_entity.dart';
import 'package:fitness_app/Features/workouts/domain/repo/workouts_repo_contract.dart';
import 'package:fitness_app/core/base_response/base_response.dart';
import 'package:injectable/injectable.dart';

@injectable
class GetPopularWorkoutsUseCase {
  final HomeRepoContract _homeRepo;
  final WorkoutsRepoContract _workoutsRepo;

  static const int _targetCount = 5;
  static const int _candidatesCount = 15;

  GetPopularWorkoutsUseCase(this._homeRepo, this._workoutsRepo);

  Future<BaseResponse<List<PopularWorkoutEntity>>> call() async {
    // PHASE 1: Parallel fetch for Levels and Muscles
    final foundationResults = await Future.wait([
      _homeRepo.getLevels(),
      _workoutsRepo.getRandomMuscles(),
    ]);

    final levelsResult = foundationResults[0];
    final musclesResult = foundationResults[1];

    if (levelsResult is ErrorResponse) {
     return ErrorResponse(
    errorMessage: (levelsResult as ErrorResponse).errorMessage,
  );
    }
    if (musclesResult is ErrorResponse) {
      return ErrorResponse(errorMessage: (musclesResult as ErrorResponse).errorMessage);
    }

    final levels = (levelsResult as SuccessResponse<List<DifficultyLevelEntity>>).data;
    final muscles = (musclesResult as SuccessResponse<List<RandomMusclesEntity>>).data;

    if (levels.isEmpty || muscles.isEmpty) {
      return const ErrorResponse(errorMessage: 'لا توجد بيانات متاحة');
    }

    // ═══════════════════════════════════════════
    // PHASE 2: generate 15 random pairs
    // ═══════════════════════════════════════════
    final pairs = _generateUniquePairs(
      muscles: muscles,
      levels: levels,
      count: _candidatesCount,
    );

    // PHASE 3: Parallel fetch for 15 pairs
    final exerciseResults = await Future.wait(
      pairs.map(
        (pair) => _workoutsRepo.getExercisesByMuscleDifficulty(
          pair.muscleId,
          pair.levelId,
          1,
        ),
      ),
      eagerError: false,
    );

    // PHASE 4: build final workout Entities
    final popularWorkouts = _buildPopularWorkouts(
      results: exerciseResults,
      pairs: pairs,
      muscles: muscles,
      levels: levels,
    );

    if (popularWorkouts.isEmpty) {
      return const ErrorResponse(errorMessage: 'لا توجد تمارين متاحة حالياً');
    }

    return SuccessResponse(data: popularWorkouts);
  }

  // Helper: generate random pairs
  List<MuscleLevelPair> _generateUniquePairs({
    required List<RandomMusclesEntity> muscles,
    required List<DifficultyLevelEntity> levels,
    required int count,
  }) {
    final random = Random();
    final seen = <String>{};
    final pairs = <MuscleLevelPair>[];

    final shuffledMuscles = List<RandomMusclesEntity>.from(muscles)
      ..shuffle(random);
    final shuffledLevels = List<DifficultyLevelEntity>.from(levels)
      ..shuffle(random);

    for (final muscle in shuffledMuscles) {
      for (final level in shuffledLevels) {
        final key = '${muscle.id}_${level.id}';
        if (!seen.contains(key)) {
          seen.add(key);
          pairs.add(
            MuscleLevelPair(
              muscleId: muscle.id,
              levelId: level.id,
            ),
          );
          if (pairs.length >= count) return pairs;
        }
      }
    }

    return pairs;
  }

  // Helper: build final popular entities
  List<PopularWorkoutEntity> _buildPopularWorkouts({
    required List<BaseResponse<List<ExerciseEntity>>> results,
    required List<MuscleLevelPair> pairs,
    required List<RandomMusclesEntity> muscles,
    required List<DifficultyLevelEntity> levels,
  }) {
    final selected = <PopularWorkoutEntity>[];

    for (int i = 0; i < results.length; i++) {
      if (selected.length >= _targetCount) break;

      final result = results[i];

      if (result is! SuccessResponse<List<ExerciseEntity>>) continue;
      if (result.data.isEmpty) continue;

      final pair = pairs[i];

      final muscle = muscles.firstWhere((m) => m.id == pair.muscleId);
      final level = levels.firstWhere((l) => l.id == pair.levelId);

      selected.add(
        PopularWorkoutEntity(
          muscleId: muscle.id,
          muscleName: muscle.name,
          muscleImage: muscle.image,
          levelId: level.id,
          levelName: level.name,
          exercises: result.data,
        ),
      );
    }

    return selected;
  }
}


class MuscleLevelPair {
  final String muscleId;
  final String levelId;

  const MuscleLevelPair({
    required this.muscleId,
    required this.levelId,
  });
}
