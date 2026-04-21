import 'package:fitness_app/Features/workouts/presentation/view_models/exercises/exercises_events.dart';
import 'package:fitness_app/Features/workouts/presentation/view_models/exercises/exercises_states.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';
import 'package:fitness_app/Features/workouts/domain/entities/difficulty_level_entity.dart';
import 'package:fitness_app/Features/workouts/domain/entities/exercise_entity.dart';
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
    }
  }

  Future<void> _handleGetLevels(GetLevels intent) async {
    emit(
      state.copyWith(
        levelsState: const BaseState<List<DifficultyLevelEntity>>(isLoading: true),
      ),
    );

    final response = await _getLevelsUseCase.call(intent.primeMoverMuscleId);

    switch (response) {
      case SuccessResponse<List<DifficultyLevelEntity>>():
        final levels = response.data;
        String? initialSelectedId;

        if (levels.isNotEmpty) {
          initialSelectedId = levels.first.id;
        }

        emit(
          state.copyWith(
            levelsState: BaseState(isLoading: false, data: levels),
            selectedLevelId: initialSelectedId,
          ),
        );

        if (initialSelectedId != null) {
          await _fetchExercises(intent.primeMoverMuscleId, initialSelectedId, page: 1);
        } else {
          emit(
            state.copyWith(
              exercisesState: const BaseState<List<ExerciseEntity>>(
                isLoading: false,
                data: [],
              ),
            ),
          );
        }
        break;

      case ErrorResponse<List<DifficultyLevelEntity>>():
        emit(
          state.copyWith(
            levelsState: BaseState(
              isLoading: false,
              errorMessage: response.errorMessage,
            ),
          ),
        );
        break;
    }
  }

  Future<void> _handleChangeLevel(ChangeLevel intent) async {
    if (state.selectedLevelId == intent.newDifficultyLevelId) return;

    // reset الـ pagination عند تغيير الـ level
    emit(state.copyWith(
      selectedLevelId: intent.newDifficultyLevelId,
      currentPage: 1,
      hasMore: true,
    ));

    await _fetchExercises(intent.primeMoverMuscleId, intent.newDifficultyLevelId, page: 1);
  }

  Future<void> _handleLoadMore(LoadMoreExercises intent) async {
    // لو مفيش more أو بنحمل دلوقتي، مترجعش
    if (!state.hasMore || state.isLoadingMore) return;

    final nextPage = state.currentPage + 1;

    emit(state.copyWith(isLoadingMore: true));

    final response = await _getExercisesUseCase.call(
      intent.primeMoverMuscleId,
      intent.difficultyLevelId,
      nextPage,
    );

    switch (response) {
      case SuccessResponse<List<ExerciseEntity>>():
        final newExercises = response.data;
        final existingExercises = state.exercisesState?.data ?? [];

        emit(state.copyWith(
          exercisesState: BaseState(
            isLoading: false,
            // append الجديد على القديم
            data: [...existingExercises, ...newExercises],
          ),
          currentPage: nextPage,
          // لو رجع أقل من المتوقع، معناه وصلنا للآخر
          hasMore: newExercises.isNotEmpty,
          isLoadingMore: false,
        ));
        break;

      case ErrorResponse<List<ExerciseEntity>>():
        emit(state.copyWith(
          isLoadingMore: false,
          exercisesState: BaseState(
            isLoading: false,
            errorMessage: response.errorMessage,
          ),
        ));
        break;
    }
  }

  Future<void> _fetchExercises(String primeMoverMuscleId, String levelId, {required int page}) async {
    emit(
      state.copyWith(
        exercisesState: const BaseState<List<ExerciseEntity>>(isLoading: true),
        currentPage: page,
        hasMore: true,
      ),
    );

    final response = await _getExercisesUseCase.call(primeMoverMuscleId, levelId, page);

    switch (response) {
      case SuccessResponse<List<ExerciseEntity>>():
        emit(
          state.copyWith(
            exercisesState: BaseState(isLoading: false, data: response.data),
            hasMore: response.data.isNotEmpty,
          ),
        );
        break;

      case ErrorResponse<List<ExerciseEntity>>():
        emit(
          state.copyWith(
            exercisesState: BaseState(
              isLoading: false,
              errorMessage: response.errorMessage,
            ),
          ),
        );
        break;
    }
  }
}