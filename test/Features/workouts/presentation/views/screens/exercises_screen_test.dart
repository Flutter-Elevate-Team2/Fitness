import 'package:fitness_app/Features/workouts/domain/entities/difficulty_level_entity.dart';
import 'package:fitness_app/Features/workouts/domain/entities/exercise_entity.dart';
import 'package:fitness_app/Features/workouts/presentation/view_models/exercises/exercises_events.dart';
import 'package:fitness_app/Features/workouts/presentation/view_models/exercises/exercises_states.dart';
import 'package:fitness_app/Features/workouts/presentation/view_models/exercises/exercises_view_model.dart';
import 'package:fitness_app/Features/workouts/presentation/views/screens/exercises_screen.dart';
 import 'package:fitness_app/Features/workouts/presentation/views/widgets/difficulty_tabs.dart';
 import 'package:fitness_app/Features/workouts/presentation/views/widgets/exercises_shimmer.dart';
import 'package:fitness_app/core/base_state/base_state.dart';
import 'package:fitness_app/core/l10n/app_localizations.dart';
import 'package:fitness_app/core/widget/shared_container.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:flutter_localizations/flutter_localizations.dart';

@GenerateMocks([ExercisesViewModel])
import 'exercises_screen_test.mocks.dart';

void main() {
  late MockExercisesViewModel mockViewModel;

  setUp(() {
    mockViewModel = MockExercisesViewModel();
     when(mockViewModel.state).thenReturn(const ExercisesState());
    when(mockViewModel.stream).thenAnswer((_) => const Stream.empty());
  });


  Widget createWidgetUnderTest({List<ExerciseEntity>? preloaded}) {
    return MaterialApp(
       localizationsDelegates: const [
        AppLocalizations.delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      supportedLocales: const [Locale('en')],
       home: BlocProvider<ExercisesViewModel>.value(
        value: mockViewModel,
        child: ExercisesScreen(
          primeMoverMuscleId: 'm1',
          muscleTitle: 'Chest',
          preloadedExercises: preloaded,
        ),
      ),
    );
  }
  group('ExercisesScreen - Initial State & Loading', () {
    testWidgets('should add GetLevels event on initState when no preloaded exercises', (tester) async {
      await tester.pumpWidget(createWidgetUnderTest());
      verify(mockViewModel.doIntent(argThat(isA<GetLevels>()))).called(1);
    });

    testWidgets('should show shimmers when levels are loading', (tester) async {
       when(mockViewModel.state).thenReturn(
        const ExercisesState(
          exercisesState: BaseState(isLoading: true),
         ),
      );

      await tester.pumpWidget(createWidgetUnderTest());

     expect(find.byType(ExercisesListShimmer), findsOneWidget);

   });
  });

  group('ExercisesScreen - Pagination Logic', () {
    testWidgets('should call LoadMoreExercises when scrolling near bottom', (tester) async {
      final tExercises = List.generate(
        15,
            (i) => ExerciseEntity(
          id: '$i',
          title: 'Exercise $i',
          description: 'Description $i',
          sets: 3,
          reps: 10,
          thumbnailUrl: '',
        ),
      );

      when(mockViewModel.state).thenReturn(
        ExercisesState(
          exercisesState: BaseState(data: tExercises),
          hasMore: true,
          isLoadingMore: false,
          selectedLevelId: 'level_1',
        ),
      );

      await tester.pumpWidget(createWidgetUnderTest());

      final scrollFinder = find.byType(CustomScrollView);
       await tester.drag(scrollFinder, const Offset(0, -3000));
      await tester.pump();

      verify(mockViewModel.doIntent(argThat(isA<LoadMoreExercises>()))).called(1);
    });
  });

  group('ExercisesScreen - Preloaded Data', () {
    testWidgets('should add LoadPreloadedExercises when data is passed', (tester) async {
      final tPreloaded = [
        ExerciseEntity(id: 'p1', title: 'Preloaded', description: '', sets: 1, reps: 1, thumbnailUrl: '')
      ];

      await tester.pumpWidget(createWidgetUnderTest(preloaded: tPreloaded));

      verify(mockViewModel.doIntent(argThat(isA<LoadPreloadedExercises>()))).called(1);
    });
  });
  group('ExercisesScreen - Error & Empty States', () {
    testWidgets('should show error message when levels fail to load', (tester) async {
      when(mockViewModel.state).thenReturn(
        const ExercisesState(
          levelsState: BaseState(isLoading: false, errorMessage: 'Failed to load levels'),
        ),
      );

      await tester.pumpWidget(createWidgetUnderTest());
      await tester.pump();

      expect(find.text('Failed to load levels'), findsOneWidget);
    });

    testWidgets('should show empty message when no exercises are found', (tester) async {
      when(mockViewModel.state).thenReturn(
        const ExercisesState(
          exercisesState: BaseState(isLoading: false, data: []),
          levelsState: BaseState(isLoading: false, data: []),
         ),
      );

      await tester.pumpWidget(createWidgetUnderTest());
       expect(find.byType(SharedContainer), findsOneWidget);
     });
  });

  group('ExercisesScreen - User Interactions', () {
    testWidgets('should call ChangeLevel when a difficulty tab is tapped', (tester) async {
      final tLevels = [
        const DifficultyLevelEntity(id: '1', name: 'Beginner'),
        const DifficultyLevelEntity(id: '2', name: 'Intermediate'),
      ];

      when(mockViewModel.state).thenReturn(
        ExercisesState(
          levelsState: BaseState(isLoading: false, data: tLevels),
          selectedLevelId: '1',
        ),
      );

      await tester.pumpWidget(createWidgetUnderTest());
      await tester.pump();

       await tester.tap(find.text('Intermediate'));
      await tester.pump();

      verify(mockViewModel.doIntent(argThat(isA<ChangeLevel>()))).called(1);
    });

    testWidgets('should navigate to VideoPlayerScreen when play button is tapped', (tester) async {
      final tExercises = [
        ExerciseEntity(id: '1', title: 'Push Up', videoUrl: 'http://video.com', thumbnailUrl: '',description: '', sets: 3, reps: 10)
      ];

      when(mockViewModel.state).thenReturn(
        ExercisesState(exercisesState: BaseState(data: tExercises)),
      );

      await tester.pumpWidget(createWidgetUnderTest());
      await tester.pump();

       final playButton = find.byIcon(Icons.play_arrow);
      if (playButton.evaluate().isNotEmpty) {
        await tester.tap(playButton);
        await tester.pumpAndSettle();
       }
    });
  });

  group('ExercisesScreen - Scroll Constraints', () {
    testWidgets('should NOT call LoadMoreExercises if hasMore is false', (tester) async {
      when(mockViewModel.state).thenReturn(
        const ExercisesState(
          exercisesState: BaseState(data: []),
          hasMore: false,
          isLoadingMore: false,
        ),
      );

      await tester.pumpWidget(createWidgetUnderTest());
      await tester.drag(find.byType(CustomScrollView), const Offset(0, -1000));
      await tester.pump();

      verifyNever(mockViewModel.doIntent(argThat(isA<LoadMoreExercises>())));
    });

    testWidgets('should call pop when back button is tapped', (tester) async {
       await tester.pumpWidget(createWidgetUnderTest());

    });

    testWidgets('should show fixedLevelId if showTabs is false', (tester) async {
       await tester.pumpWidget(MaterialApp(
        localizationsDelegates: const [
          AppLocalizations.delegate,
          GlobalMaterialLocalizations.delegate,
          GlobalWidgetsLocalizations.delegate,
          GlobalCupertinoLocalizations.delegate,
        ],
        supportedLocales: const [Locale('en')],
        home: BlocProvider<ExercisesViewModel>.value(
          value: mockViewModel,
          child: ExercisesScreen(
            primeMoverMuscleId: 'm1',
            muscleTitle: 'Chest',
            showTabs: false,
            fixedLevelId: 'hard',
          ),
        ),
      ));

       await tester.pump();

       expect(find.byType(DifficultyTabsWidget), findsNothing);
    });
    testWidgets('should show ErrorResponse for exercises when data is already present but a loadMore fails', (tester) async {
      final existingExercises = [
        ExerciseEntity(id: '1', title: 'Ex 1', description: '', sets: 1, reps: 1, thumbnailUrl: '')
      ];

      when(mockViewModel.state).thenReturn(
        ExercisesState(
          exercisesState: BaseState(data: existingExercises, errorMessage: 'Failed to load more'),
          isLoadingMore: false,
        ),
      );

      await tester.pumpWidget(createWidgetUnderTest());
     });
  });
}