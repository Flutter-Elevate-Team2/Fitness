import 'package:equatable/equatable.dart';
import 'package:fitness_app/Features/workouts/domain/entities/difficulty_level_entity.dart';
import 'package:fitness_app/Features/workouts/domain/entities/exercise_entity.dart';
import 'package:fitness_app/core/base_state/base_state.dart';

class ExercisesState extends Equatable {
  final BaseState<List<DifficultyLevelEntity>>? levelsState;
  final BaseState<List<ExerciseEntity>>? exercisesState;
  final String? selectedLevelId;
  final int currentPage;
  final bool hasMore;
  final bool isLoadingMore;

  const ExercisesState({
    this.levelsState,
    this.exercisesState,
    this.selectedLevelId,
    this.currentPage = 1,
    this.hasMore = true,
    this.isLoadingMore = false,
  });

  ExercisesState copyWith({
    BaseState<List<DifficultyLevelEntity>>? levelsState,
    BaseState<List<ExerciseEntity>>? exercisesState,
    String? selectedLevelId,
    int? currentPage,
    bool? hasMore,
    bool? isLoadingMore,
  }) {
    return ExercisesState(
      levelsState: levelsState ?? this.levelsState,
      exercisesState: exercisesState ?? this.exercisesState,
      selectedLevelId: selectedLevelId ?? this.selectedLevelId,
      currentPage: currentPage ?? this.currentPage,
      hasMore: hasMore ?? this.hasMore,
      isLoadingMore: isLoadingMore ?? this.isLoadingMore,
    );
  }

  @override
  List<Object?> get props => [
        levelsState,
        exercisesState,
        selectedLevelId,
        currentPage,
        hasMore,
        isLoadingMore,
      ];
}