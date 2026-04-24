import 'package:bloc_test/bloc_test.dart';
import 'package:fitness_app/Features/workouts/domain/entities/difficulty_level_entity.dart';
import 'package:fitness_app/Features/workouts/domain/entities/exercise_entity.dart';
import 'package:fitness_app/Features/workouts/presentation/view_models/exercises/exercises_events.dart';
import 'package:fitness_app/Features/workouts/presentation/view_models/exercises/exercises_states.dart';
import 'package:fitness_app/Features/workouts/presentation/view_models/exercises/exercises_view_model.dart';
import 'package:fitness_app/Features/workouts/presentation/views/screens/exercises_screen.dart';
import 'package:fitness_app/Features/workouts/presentation/views/widgets/exercise_card.dart';
import 'package:fitness_app/core/base_state/base_state.dart';
import 'package:fitness_app/core/l10n/app_localizations.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:network_image_mock/network_image_mock.dart';

class MockExercisesViewModel extends MockCubit<ExercisesState>
    implements ExercisesViewModel {}

void main() {
  late MockExercisesViewModel mockViewModel;

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

  setUpAll(() {
    // Register fallback values for sealed ExercisesEvents
    registerFallbackValue(GetLevels(primeMoverMuscleId: ''));
    registerFallbackValue(
      ChangeLevel(primeMoverMuscleId: '', newDifficultyLevelId: ''),
    );
    registerFallbackValue(
      LoadMoreExercises(primeMoverMuscleId: '', difficultyLevelId: ''),
    );
    registerFallbackValue(LoadPreloadedExercises(exercises: []));
  });

  setUp(() {
    mockViewModel = MockExercisesViewModel();
    // Stub doIntent so that initState calls don't throw
    when(() => mockViewModel.doIntent(any())).thenAnswer((_) async {});
  });

  Widget createTestableWidget({
    bool showTabs = true,
    List<ExerciseEntity>? preloadedExercises,
  }) {
    return MaterialApp(
      localizationsDelegates: AppLocalizations.localizationsDelegates,
      supportedLocales: AppLocalizations.supportedLocales,
      locale: const Locale('en'),
      home: BlocProvider<ExercisesViewModel>.value(
        value: mockViewModel,
        child: ExercisesScreen(
          primeMoverMuscleId: 'muscle_123',
          muscleTitle: 'Chest',
          showTabs: showTabs,
          preloadedExercises: preloadedExercises,
        ),
      ),
    );
  }

  group('ExercisesScreen Widget Tests', () {
    testWidgets(
      'should show loading indicator when levelsState is loading',
      (tester) async {
        when(() => mockViewModel.state).thenReturn(
          const ExercisesState(
            levelsState: BaseState<List<DifficultyLevelEntity>>(
              isLoading: true,
            ),
          ),
        );
        when(() => mockViewModel.stream)
            .thenAnswer((_) => const Stream.empty());

        await mockNetworkImagesFor(() async {
          await tester.pumpWidget(createTestableWidget());
          await tester.pump();
        });

        expect(find.byType(CircularProgressIndicator), findsWidgets);
      },
    );

    testWidgets(
      'should show error text when levelsState has errorMessage',
      (tester) async {
        when(() => mockViewModel.state).thenReturn(
          const ExercisesState(
            levelsState: BaseState<List<DifficultyLevelEntity>>(
              isLoading: false,
              errorMessage: 'Failed to load levels',
            ),
            selectedLevelId: 'lvl_1',
            exercisesState: BaseState<List<ExerciseEntity>>(
              isLoading: false,
              errorMessage: 'No data',
            ),
          ),
        );
        when(() => mockViewModel.stream)
            .thenAnswer((_) => const Stream.empty());

        await mockNetworkImagesFor(() async {
          await tester.pumpWidget(createTestableWidget());
          await tester.pump();
        });

        expect(find.text('Failed to load levels'), findsOneWidget);
      },
    );

    testWidgets(
      'should show exercises list when exercises are loaded',
      (tester) async {
        when(() => mockViewModel.state).thenReturn(
          const ExercisesState(
            levelsState: BaseState(data: tLevels),
            exercisesState: BaseState(data: tExercises),
            selectedLevelId: 'lvl_1',
          ),
        );
        when(() => mockViewModel.stream)
            .thenAnswer((_) => const Stream.empty());

        await mockNetworkImagesFor(() async {
          await tester.pumpWidget(createTestableWidget());
          await tester.pump();
        });

        expect(find.text('Bench Press'), findsOneWidget);
        expect(find.text('Chest • Barbell'), findsOneWidget);
      },
    );

    testWidgets(
      'should show pagination loading indicator when isLoadingMore is true',
      (tester) async {
        when(() => mockViewModel.state).thenReturn(
          const ExercisesState(
            levelsState: BaseState(data: tLevels),
            exercisesState: BaseState(data: tExercises),
            selectedLevelId: 'lvl_1',
            isLoadingMore: true,
          ),
        );
        when(() => mockViewModel.stream)
            .thenAnswer((_) => const Stream.empty());

        await mockNetworkImagesFor(() async {
          await tester.pumpWidget(createTestableWidget());
          await tester.pump();
        });

        // Should show the pagination loading indicator
        expect(find.byType(CircularProgressIndicator), findsWidgets);
      },
    );

    testWidgets(
      'should render with preloadedExercises and no tabs',
      (tester) async {
        when(() => mockViewModel.state).thenReturn(
          const ExercisesState(
            exercisesState: BaseState(data: tExercises),
            hasMore: false,
          ),
        );
        when(() => mockViewModel.stream)
            .thenAnswer((_) => const Stream.empty());

        await mockNetworkImagesFor(() async {
          await tester.pumpWidget(
            createTestableWidget(
              showTabs: false,
              preloadedExercises: tExercises,
            ),
          );
          await tester.pump();
        });

        expect(find.text('Bench Press'), findsOneWidget);
        expect(find.byType(ExerciseCardWidget), findsOneWidget);
      },
    );

    testWidgets(
      'should call doIntent with GetLevels on initState when no preloadedExercises',
      (tester) async {
        when(() => mockViewModel.state).thenReturn(const ExercisesState());
        when(() => mockViewModel.stream)
            .thenAnswer((_) => const Stream.empty());

        await mockNetworkImagesFor(() async {
          await tester.pumpWidget(createTestableWidget());
          await tester.pump();
        });

        verify(
          () => mockViewModel.doIntent(any(that: isA<GetLevels>())),
        ).called(1);
      },
    );

    testWidgets(
      'should call doIntent with LoadPreloadedExercises on initState when preloadedExercises provided',
      (tester) async {
        when(() => mockViewModel.state).thenReturn(
          const ExercisesState(
            exercisesState: BaseState(data: tExercises),
            hasMore: false,
          ),
        );
        when(() => mockViewModel.stream)
            .thenAnswer((_) => const Stream.empty());

        await mockNetworkImagesFor(() async {
          await tester.pumpWidget(
            createTestableWidget(
              showTabs: false,
              preloadedExercises: tExercises,
            ),
          );
          await tester.pump();
        });

        verify(
          () => mockViewModel
              .doIntent(any(that: isA<LoadPreloadedExercises>())),
        ).called(1);
      },
    );
  });
}
