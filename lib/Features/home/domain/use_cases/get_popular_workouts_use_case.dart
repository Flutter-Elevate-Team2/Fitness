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

  static const int _targetCount = 4;
  static const int _batchSize = 4;

  GetPopularWorkoutsUseCase(this._homeRepo, this._workoutsRepo);

  Stream<BaseResponse<List<PopularWorkoutEntity>>> call() async* {

    final foundationResults = await Future.wait([
      _homeRepo.getLevels(),
      _workoutsRepo.getRandomMuscles(),
    ]);

    final levelsResult = foundationResults[0];
    final musclesResult = foundationResults[1];

    if (levelsResult is ErrorResponse) {
      yield ErrorResponse(
          errorMessage: (levelsResult as ErrorResponse).errorMessage);
      return;
    }
    if (musclesResult is ErrorResponse) {
      yield ErrorResponse(
          errorMessage: (musclesResult as ErrorResponse).errorMessage);
      return;
    }

    final levels =
        (levelsResult as SuccessResponse<List<DifficultyLevelEntity>>).data;
    final muscles =
        (musclesResult as SuccessResponse<List<RandomMusclesEntity>>).data;

    if (levels.isEmpty || muscles.isEmpty) {
      yield const ErrorResponse(errorMessage: 'No data available');
      return;
    }


    final queue = _buildRoundRobinQueue(muscles: muscles, levels: levels);

    final selected = <PopularWorkoutEntity>[];
    final usedMuscleIds = <String>{};
    int queueIndex = 0;


    while (selected.length < _targetCount && queueIndex < queue.length) {


      final batchPairs = <MuscleLevelPair>[];
      final batchMuscleIds = <String>{}; 

      while (batchPairs.length < _batchSize && queueIndex < queue.length) {
        final pair = queue[queueIndex];
        queueIndex++;


        if (usedMuscleIds.contains(pair.muscleId)) continue;


        if (batchMuscleIds.contains(pair.muscleId)) continue;

        batchPairs.add(pair);
        batchMuscleIds.add(pair.muscleId); 
      }

      if (batchPairs.isEmpty) break;


      final batchResults = await Future.wait(
        batchPairs.map(
          (pair) => _workoutsRepo.getExercisesByMuscleDifficulty(
            pair.muscleId,
            pair.levelId,
            1,
          ),
        ),
        eagerError: false,
      );

      bool hasNewItems = false;

      for (int i = 0; i < batchResults.length; i++) {
        if (selected.length >= _targetCount) break;

        final result = batchResults[i];
        final pair = batchPairs[i];

        if (result is! SuccessResponse<List<ExerciseEntity>>) continue;
        if (result.data.isEmpty) continue;

        final muscle = muscles.firstWhere((m) => m.id == pair.muscleId);
        final level = levels.firstWhere((l) => l.id == pair.levelId);

        selected.add(PopularWorkoutEntity(
          muscleId: muscle.id,
          muscleName: muscle.name,
          muscleImage: muscle.image,
          levelId: level.id,
          levelName: level.name,
          exercises: result.data,
        ));

        usedMuscleIds.add(pair.muscleId);
        hasNewItems = true;
      }


      if (hasNewItems) {
        yield SuccessResponse(data: List.from(selected));
      }
    }

    if (selected.isEmpty) {
      yield const ErrorResponse(errorMessage: 'No workouts available');
    }
  }

  List<MuscleLevelPair> _buildRoundRobinQueue({
    required List<RandomMusclesEntity> muscles,
    required List<DifficultyLevelEntity> levels,
  }) {
    final random = Random();
    final shuffledMuscles = List<RandomMusclesEntity>.from(muscles)
      ..shuffle(random);
    final shuffledLevels = List<DifficultyLevelEntity>.from(levels)
      ..shuffle(random);

    final queue = <MuscleLevelPair>[];


    for (final level in shuffledLevels) {
      for (final muscle in shuffledMuscles) {
        queue.add(MuscleLevelPair(muscleId: muscle.id, levelId: level.id));
      }
    }

    return queue;
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
