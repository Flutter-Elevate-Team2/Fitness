import 'package:fitness_app/Features/workouts/domain/entities/exercise_entity.dart';
import 'package:fitness_app/Features/workouts/presentation/view_models/exercises/exercises_events.dart';
import 'package:fitness_app/Features/workouts/presentation/view_models/exercises/exercises_states.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';
import 'package:fitness_app/Features/workouts/domain/entities/difficulty_level_entity.dart';
import 'package:fitness_app/Features/workouts/domain/use_cases/get_difficulty_level_use_case.dart';
import 'package:fitness_app/Features/workouts/domain/use_cases/get_exercises_by_level_prime_mover_muscle.dart';
import 'package:fitness_app/core/base_response/base_response.dart';
import 'package:fitness_app/core/base_state/base_state.dart';

@injectable
class ExercisesViewModel extends Cubit<ExercisesState> {
  final GetDifficultyLevelUseCase _getLevelsUseCase;
  final GetExercisesByLevelPrimeMoverMuscleUseCase _getExercisesUseCase;

  ExercisesViewModel(
    this._getLevelsUseCase,
    this._getExercisesUseCase,
  ) : super(const ExercisesState());

  Future<void> doIntent(ExercisesEvents event) async {
    switch (event) {
      case GetLevels():
        await _handleGetLevels(event);
        break;
      case ChangeLevel():
        await _handleChangeLevel(event);
        break;
      case LoadMoreExercises():
        await _handleLoadMore(event);
        break;
      case LoadPreloadedExercises():
        _handleLoadPreloaded(event);
        break;
    }
  }

  // ─────────────────────────────────────────────
  // LoadPreloadedExercises
  // ─────────────────────────────────────────────
  void _handleLoadPreloaded(LoadPreloadedExercises intent) {
    if (isClosed) return;
    emit(
      state.copyWith(
        exercisesState: BaseState(
          isLoading: false,
          data: intent.exercises,
        ),
        hasMore: false,
        currentPage: 1,
      ),
    );
  }

  // ─────────────────────────────────────────────
  // GetLevels
  // ─────────────────────────────────────────────
  Future<void> _handleGetLevels(GetLevels intent) async {
    if (isClosed) return;
    emit(
      state.copyWith(
        levelsState: const BaseState<List<DifficultyLevelEntity>>(
          isLoading: true,
        ),
      ),
    );

    final response = await _getLevelsUseCase.call(intent.primeMoverMuscleId);
    if (isClosed) return;

    switch (response) {
      case SuccessResponse<List<DifficultyLevelEntity>>():
        final levels = response.data;
        final initialSelectedId =
            intent.fixedLevelId ?? (levels.isNotEmpty ? levels.first.id : null);

        emit(
          state.copyWith(
            levelsState: BaseState(isLoading: false, data: levels),
            selectedLevelId: initialSelectedId,
          ),
        );

        if (initialSelectedId != null) {
          await _fetchExercises(
            intent.primeMoverMuscleId,
            initialSelectedId,
            page: 1,
          );
        } else {
          if (isClosed) return;
          emit(
            state.copyWith(
              exercisesState: const BaseState<List<ExerciseEntity>>(
                isLoading: false,
                data: [],
              ),
            ),
          );
        }

      case ErrorResponse<List<DifficultyLevelEntity>>():
        if (isClosed) return;
        emit(
          state.copyWith(
            levelsState: BaseState(
              isLoading: false,
              errorMessage: response.errorMessage,
            ),
          ),
        );
    }
  }

  // ─────────────────────────────────────────────
  // ChangeLevel
  // ─────────────────────────────────────────────
  Future<void> _handleChangeLevel(ChangeLevel intent) async {
    if (isClosed) return;
    if (state.selectedLevelId == intent.newDifficultyLevelId) return;

    emit(
      state.copyWith(
        selectedLevelId: intent.newDifficultyLevelId,
        currentPage: 1,
        hasMore: true,
        isLoadingMore: false,
        exercisesState: const BaseState<List<ExerciseEntity>>(isLoading: true),
      ),
    );

    await _fetchExercises(
      intent.primeMoverMuscleId,
      intent.newDifficultyLevelId,
      page: 1,
    );
  }

  // ─────────────────────────────────────────────
  // LoadMore (Pagination)
  // ─────────────────────────────────────────────
  Future<void> _handleLoadMore(LoadMoreExercises intent) async {
    if (isClosed) return;
    if (state.selectedLevelId != intent.difficultyLevelId) return;
    if (!state.hasMore || state.isLoadingMore) return;

    final nextPage = state.currentPage + 1;

    emit(state.copyWith(isLoadingMore: true));

    final response = await _getExercisesUseCase.call(
      intent.primeMoverMuscleId,
      intent.difficultyLevelId,
      nextPage,
    );

    if (isClosed) return;

    switch (response) {
      case SuccessResponse<List<ExerciseEntity>>():
        final newExercises = response.data;
        final existingExercises = state.exercisesState?.data ?? [];

        emit(
          state.copyWith(
            exercisesState: BaseState(
              isLoading: false,
              data: [...existingExercises, ...newExercises],
            ),
            currentPage: nextPage,
            hasMore: newExercises.isNotEmpty,
            isLoadingMore: false,
          ),
        );

      case ErrorResponse<List<ExerciseEntity>>():
        emit(
          state.copyWith(
            isLoadingMore: false,
            exercisesState: state.exercisesState?.copyWith(
              isLoading: false,
              errorMessage: response.errorMessage,
            ),
          ),
        );
    }
  }

  // ─────────────────────────────────────────────
  // Private: Fetch First Page
  // ─────────────────────────────────────────────
  Future<void> _fetchExercises(
    String primeMoverMuscleId,
    String levelId, {
    required int page,
  }) async {
    if (isClosed) return;
    emit(
      state.copyWith(
        exercisesState: const BaseState<List<ExerciseEntity>>(isLoading: true),
        currentPage: page,
        hasMore: true,
        isLoadingMore: false,
      ),
    );

    final response = await _getExercisesUseCase.call(
      primeMoverMuscleId,
      levelId,
      page,
    );

    if (isClosed) return;

    switch (response) {
      case SuccessResponse<List<ExerciseEntity>>():
        emit(
          state.copyWith(
            exercisesState: BaseState(
              isLoading: false,
              data: response.data,
            ),
            hasMore: response.data.isNotEmpty,
          ),
        );

      case ErrorResponse<List<ExerciseEntity>>():
        emit(
          state.copyWith(
            exercisesState: BaseState(
              isLoading: false,
              errorMessage: response.errorMessage,
            ),
          ),
        );
    }
  }
}
