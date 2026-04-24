import 'package:bloc_test/bloc_test.dart';
import 'package:fitness_app/Features/workouts/domain/entities/difficulty_level_entity.dart';
import 'package:fitness_app/Features/workouts/domain/entities/exercise_entity.dart';
import 'package:fitness_app/Features/workouts/domain/use_cases/get_difficulty_level_use_case.dart';
import 'package:fitness_app/Features/workouts/domain/use_cases/get_exercises_by_level_prime_mover_muscle.dart';
import 'package:fitness_app/Features/workouts/presentation/view_models/exercises/exercises_events.dart';
import 'package:fitness_app/Features/workouts/presentation/view_models/exercises/exercises_states.dart';
import 'package:fitness_app/Features/workouts/presentation/view_models/exercises/exercises_view_model.dart';
import 'package:fitness_app/core/base_response/base_response.dart';
import 'package:fitness_app/core/base_state/base_state.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

import 'exercises_view_model_test.mocks.dart';

@GenerateMocks([
  GetDifficultyLevelUseCase,
  GetExercisesByLevelPrimeMoverMuscleUseCase,
])
void main() {
  late ExercisesViewModel viewModel;
  late MockGetDifficultyLevelUseCase mockGetLevelsUseCase;
  late MockGetExercisesByLevelPrimeMoverMuscleUseCase mockGetExercisesUseCase;

  // ── Shared fixtures ──
  const tPrimeMoverMuscleId = 'muscle_123';
  const tLevels = [
    DifficultyLevelEntity(id: 'lvl_1', name: 'Beginner'),
    DifficultyLevelEntity(id: 'lvl_2', name: 'Advanced'),
  ];
  const tExercises = [
    ExerciseEntity(
      id: 'ex_1',
      title: 'Chest • Barbell',
      description: 'Bench Press',
      sets: 3,
      reps: 15,
      thumbnailUrl: 'https://img.youtube.com/vi/abc/hqdefault.jpg',
      videoUrl: 'https://www.youtube.com/watch?v=abc',
    ),
  ];
  const tExercisesPage2 = [
    ExerciseEntity(
      id: 'ex_2',
      title: 'Chest • Dumbbell',
      description: 'Incline Press',
      sets: 3,
      reps: 15,
      thumbnailUrl: 'https://img.youtube.com/vi/xyz/hqdefault.jpg',
      videoUrl: 'https://www.youtube.com/watch?v=xyz',
    ),
  ];

  // Provide sealed-class dummies before any test runs
  provideDummy<BaseResponse<List<DifficultyLevelEntity>>>(
    const SuccessResponse<List<DifficultyLevelEntity>>(data: []),
  );
  provideDummy<BaseResponse<List<ExerciseEntity>>>(
    const SuccessResponse<List<ExerciseEntity>>(data: []),
  );

  setUp(() {
    mockGetLevelsUseCase = MockGetDifficultyLevelUseCase();
    mockGetExercisesUseCase =
        MockGetExercisesByLevelPrimeMoverMuscleUseCase();
    viewModel = ExercisesViewModel(
      mockGetLevelsUseCase,
      mockGetExercisesUseCase,
    );
  });

  group('ExercisesViewModel Tests', () {
    test('initial state should be default ExercisesState', () {
      expect(viewModel.state, const ExercisesState());
    });

    // ─────────────────────────────────────────────
    // GetLevels
    // ─────────────────────────────────────────────
    blocTest<ExercisesViewModel, ExercisesState>(
      'emits [levelsLoading, levelsSuccess + exercisesLoading, exercisesSuccess] when GetLevels succeeds',
      build: () {
        when(mockGetLevelsUseCase.call(any)).thenAnswer(
          (_) async =>
              const SuccessResponse<List<DifficultyLevelEntity>>(data: tLevels),
        );
        when(mockGetExercisesUseCase.call(any, any, any)).thenAnswer(
          (_) async =>
              const SuccessResponse<List<ExerciseEntity>>(data: tExercises),
        );
        return viewModel;
      },
      act: (bloc) => bloc.doIntent(
        GetLevels(primeMoverMuscleId: tPrimeMoverMuscleId),
      ),
      expect: () => [
        // 1st: levels loading
        isA<ExercisesState>().having(
          (s) => s.levelsState?.isLoading,
          'levelsLoading',
          true,
        ),
        // 2nd: levels loaded + selectedLevelId set + exercises loading started
        isA<ExercisesState>()
            .having((s) => s.levelsState?.data, 'levelsData', tLevels)
            .having((s) => s.selectedLevelId, 'selectedLevelId', 'lvl_1'),
        // 3rd: exercises loading
        isA<ExercisesState>().having(
          (s) => s.exercisesState?.isLoading,
          'exercisesLoading',
          true,
        ),
        // 4th: exercises loaded
        isA<ExercisesState>().having(
          (s) => s.exercisesState?.data,
          'exercisesData',
          tExercises,
        ),
      ],
      verify: (_) {
        verify(mockGetLevelsUseCase.call(tPrimeMoverMuscleId)).called(1);
        verify(mockGetExercisesUseCase.call(tPrimeMoverMuscleId, 'lvl_1', 1))
            .called(1);
      },
    );

    blocTest<ExercisesViewModel, ExercisesState>(
      'emits [levelsLoading, levelsError] when GetLevels fails',
      build: () {
        when(mockGetLevelsUseCase.call(any)).thenAnswer(
          (_) async => const ErrorResponse<List<DifficultyLevelEntity>>(
            errorMessage: 'Network Error',
          ),
        );
        return viewModel;
      },
      act: (bloc) => bloc.doIntent(
        GetLevels(primeMoverMuscleId: tPrimeMoverMuscleId),
      ),
      expect: () => [
        isA<ExercisesState>().having(
          (s) => s.levelsState?.isLoading,
          'levelsLoading',
          true,
        ),
        isA<ExercisesState>().having(
          (s) => s.levelsState?.errorMessage,
          'errorMessage',
          'Network Error',
        ),
      ],
    );

    blocTest<ExercisesViewModel, ExercisesState>(
      'uses fixedLevelId when provided in GetLevels event',
      build: () {
        when(mockGetLevelsUseCase.call(any)).thenAnswer(
          (_) async =>
              const SuccessResponse<List<DifficultyLevelEntity>>(data: tLevels),
        );
        when(mockGetExercisesUseCase.call(any, any, any)).thenAnswer(
          (_) async =>
              const SuccessResponse<List<ExerciseEntity>>(data: tExercises),
        );
        return viewModel;
      },
      act: (bloc) => bloc.doIntent(
        GetLevels(
          primeMoverMuscleId: tPrimeMoverMuscleId,
          fixedLevelId: 'lvl_2',
        ),
      ),
      verify: (_) {
        verify(mockGetExercisesUseCase.call(tPrimeMoverMuscleId, 'lvl_2', 1))
            .called(1);
      },
    );

    // ─────────────────────────────────────────────
    // ChangeLevel
    // ─────────────────────────────────────────────
    blocTest<ExercisesViewModel, ExercisesState>(
      'emits updated selectedLevelId and fresh exercises when ChangeLevel is dispatched',
      build: () {
        when(mockGetExercisesUseCase.call(any, any, any)).thenAnswer(
          (_) async =>
              const SuccessResponse<List<ExerciseEntity>>(data: tExercises),
        );
        return viewModel;
      },
      seed: () => const ExercisesState(
        levelsState: BaseState(data: tLevels),
        selectedLevelId: 'lvl_1',
      ),
      act: (bloc) => bloc.doIntent(
        ChangeLevel(
          primeMoverMuscleId: tPrimeMoverMuscleId,
          newDifficultyLevelId: 'lvl_2',
        ),
      ),
      expect: () => [
        // 1st: selectedLevelId changes
        isA<ExercisesState>().having(
          (s) => s.selectedLevelId,
          'selectedLevelId',
          'lvl_2',
        ),
        // 2nd: exercises loading
        isA<ExercisesState>().having(
          (s) => s.exercisesState?.isLoading,
          'exercisesLoading',
          true,
        ),
        // 3rd: exercises loaded
        isA<ExercisesState>().having(
          (s) => s.exercisesState?.data,
          'exercisesData',
          tExercises,
        ),
      ],
    );

    blocTest<ExercisesViewModel, ExercisesState>(
      'does NOT emit when ChangeLevel is called with the same level',
      build: () => viewModel,
      seed: () => const ExercisesState(selectedLevelId: 'lvl_1'),
      act: (bloc) => bloc.doIntent(
        ChangeLevel(
          primeMoverMuscleId: tPrimeMoverMuscleId,
          newDifficultyLevelId: 'lvl_1',
        ),
      ),
      expect: () => [],
    );

    // ─────────────────────────────────────────────
    // LoadMoreExercises (Pagination)
    // ─────────────────────────────────────────────
    blocTest<ExercisesViewModel, ExercisesState>(
      'emits [loadingMore, appended exercises] when LoadMoreExercises succeeds',
      build: () {
        when(mockGetExercisesUseCase.call(any, any, any)).thenAnswer(
          (_) async => const SuccessResponse<List<ExerciseEntity>>(
            data: tExercisesPage2,
          ),
        );
        return viewModel;
      },
      seed: () => const ExercisesState(
        selectedLevelId: 'lvl_1',
        exercisesState: BaseState(data: tExercises),
        currentPage: 1,
        hasMore: true,
        isLoadingMore: false,
      ),
      act: (bloc) => bloc.doIntent(
        LoadMoreExercises(
          primeMoverMuscleId: tPrimeMoverMuscleId,
          difficultyLevelId: 'lvl_1',
        ),
      ),
      expect: () => [
        // 1st: isLoadingMore = true
        isA<ExercisesState>().having(
          (s) => s.isLoadingMore,
          'isLoadingMore',
          true,
        ),
        // 2nd: appended exercises + page 2
        isA<ExercisesState>()
            .having(
              (s) => s.exercisesState?.data?.length,
              'totalExercises',
              2,
            )
            .having((s) => s.currentPage, 'currentPage', 2)
            .having((s) => s.isLoadingMore, 'isLoadingMore', false),
      ],
    );

    blocTest<ExercisesViewModel, ExercisesState>(
      'does NOT emit when hasMore is false',
      build: () => viewModel,
      seed: () => const ExercisesState(
        selectedLevelId: 'lvl_1',
        hasMore: false,
        isLoadingMore: false,
      ),
      act: (bloc) => bloc.doIntent(
        LoadMoreExercises(
          primeMoverMuscleId: tPrimeMoverMuscleId,
          difficultyLevelId: 'lvl_1',
        ),
      ),
      expect: () => [],
    );

    blocTest<ExercisesViewModel, ExercisesState>(
      'does NOT emit when isLoadingMore is true (debounce)',
      build: () => viewModel,
      seed: () => const ExercisesState(
        selectedLevelId: 'lvl_1',
        hasMore: true,
        isLoadingMore: true,
      ),
      act: (bloc) => bloc.doIntent(
        LoadMoreExercises(
          primeMoverMuscleId: tPrimeMoverMuscleId,
          difficultyLevelId: 'lvl_1',
        ),
      ),
      expect: () => [],
    );

    blocTest<ExercisesViewModel, ExercisesState>(
      'does NOT emit when difficultyLevelId does not match selectedLevelId',
      build: () => viewModel,
      seed: () => const ExercisesState(
        selectedLevelId: 'lvl_1',
        hasMore: true,
        isLoadingMore: false,
      ),
      act: (bloc) => bloc.doIntent(
        LoadMoreExercises(
          primeMoverMuscleId: tPrimeMoverMuscleId,
          difficultyLevelId: 'lvl_DIFFERENT',
        ),
      ),
      expect: () => [],
    );

    blocTest<ExercisesViewModel, ExercisesState>(
      'emits [loadingMore, error] when LoadMoreExercises fails',
      build: () {
        when(mockGetExercisesUseCase.call(any, any, any)).thenAnswer(
          (_) async => const ErrorResponse<List<ExerciseEntity>>(
            errorMessage: 'Page load failed',
          ),
        );
        return viewModel;
      },
      seed: () => const ExercisesState(
        selectedLevelId: 'lvl_1',
        exercisesState: BaseState(data: tExercises),
        currentPage: 1,
        hasMore: true,
        isLoadingMore: false,
      ),
      act: (bloc) => bloc.doIntent(
        LoadMoreExercises(
          primeMoverMuscleId: tPrimeMoverMuscleId,
          difficultyLevelId: 'lvl_1',
        ),
      ),
      expect: () => [
        isA<ExercisesState>().having(
          (s) => s.isLoadingMore,
          'isLoadingMore',
          true,
        ),
        isA<ExercisesState>()
            .having((s) => s.isLoadingMore, 'isLoadingMore', false)
            .having(
              (s) => s.exercisesState?.errorMessage,
              'errorMessage',
              'Page load failed',
            ),
      ],
    );

    // ─────────────────────────────────────────────
    // LoadPreloadedExercises
    // ─────────────────────────────────────────────
    blocTest<ExercisesViewModel, ExercisesState>(
      'emits exercisesState with preloaded data and hasMore=false',
      build: () => viewModel,
      act: (bloc) => bloc.doIntent(
        LoadPreloadedExercises(exercises: tExercises),
      ),
      expect: () => [
        isA<ExercisesState>()
            .having(
              (s) => s.exercisesState?.data,
              'preloadedData',
              tExercises,
            )
            .having((s) => s.hasMore, 'hasMore', false)
            .having((s) => s.currentPage, 'currentPage', 1),
      ],
    );

    // ─────────────────────────────────────────────
    // State copyWith
    // ─────────────────────────────────────────────
    test(
      'copyWith should return identical state when no arguments are passed',
      () {
        const state = ExercisesState();
        expect(state.copyWith(), state);
      },
    );
  });
}
