import 'dart:async';

import 'package:bloc_test/bloc_test.dart';
import 'package:fitness_app/Features/workouts/domain/entities/muscle_entity.dart';
import 'package:fitness_app/Features/workouts/domain/entities/muscle_group_entity.dart';
import 'package:fitness_app/Features/workouts/presentation/view_models/workouts_events.dart';
import 'package:fitness_app/Features/workouts/presentation/view_models/workouts_states.dart';
import 'package:fitness_app/Features/workouts/presentation/view_models/workouts_view_model.dart';
import 'package:fitness_app/Features/workouts/presentation/views/widgets/grid/workouts_grid.dart';
import 'package:fitness_app/Features/workouts/presentation/views/widgets/tabs/workouts_tabs_list.dart';
import 'package:fitness_app/Features/workouts/presentation/views/widgets/workouts_screen_body.dart';
import 'package:fitness_app/core/base_state/base_state.dart';
import 'package:fitness_app/core/widget/shared_scaffold.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

// ─── Mocks ──────────────────────────────────────────────────────────────────
class MockWorkoutsViewModel extends MockCubit<WorkoutsStates>
    implements WorkoutsViewModel {}

// ─── Test Data ──────────────────────────────────────────────────────────────
const _tMuscleGroups = [
  MuscleGroupEntity(id: '1', name: 'Chest'),
  MuscleGroupEntity(id: '2', name: 'Back'),
];

const _tMuscles = [
  MuscleEntity(id: 'm1', name: 'Pectoralis Major', image: 'https://example.com/pec.png'),
];

// ─── Helpers ────────────────────────────────────────────────────────────────
Widget makeTestableWidget(WorkoutsViewModel mockViewModel) {
  return MaterialApp(
    home: BlocProvider<WorkoutsViewModel>.value(
      value: mockViewModel,
      child: const WorkoutsScreenBody(),
    ),
  );
}

void main() {
  late MockWorkoutsViewModel mockViewModel;

  setUpAll(() {
    registerFallbackValue(FetchMuscleGroupsEvent());
  });

  setUp(() {
    mockViewModel = MockWorkoutsViewModel();
    when(() => mockViewModel.doIntent(any())).thenReturn(null);
  });

  // ═══════════════════════════════════════════════════════════════════════════
  // 1. Initial Auto-Fetch Interaction
  // ═══════════════════════════════════════════════════════════════════════════
  group('Initial Auto-Fetch Interaction', () {
    testWidgets(
      'listener auto-selects first group and dispatches FetchMusclesByGroupEvent',
      (tester) async {
        final initialState = WorkoutsStates(
          muscleGroupsState: const BaseState(isLoading: true),
          musclesState: const BaseState(),
        );

        final loadedState = WorkoutsStates(
          muscleGroupsState: const BaseState(
            isLoading: false,
            data: _tMuscleGroups,
          ),
          musclesState: const BaseState(isLoading: true),
        );

        // Use whenListen to properly simulate state transitions for BlocConsumer.
        whenListen(
          mockViewModel,
          Stream.fromIterable([loadedState]),
          initialState: initialState,
        );

        await tester.pumpWidget(makeTestableWidget(mockViewModel));
        // Pump once to process the stream emission (avoid pumpAndSettle due to Shimmer animation).
        await tester.pump();

        verify(
          () => mockViewModel.doIntent(
            any(
              that: isA<FetchMusclesByGroupEvent>()
                  .having((e) => e.groupId, 'groupId', '1'),
            ),
          ),
        ).called(1);

        expect(find.byType(WorkoutsTabsList), findsOneWidget);
      },
    );

    testWidgets(
      'listener does NOT re-dispatch when selectedGroupId is already set',
      (tester) async {
        final initialState = WorkoutsStates(
          muscleGroupsState: const BaseState(isLoading: true),
          musclesState: const BaseState(),
        );

        final loadedState = WorkoutsStates(
          muscleGroupsState: const BaseState(
            isLoading: false,
            data: _tMuscleGroups,
          ),
          musclesState: const BaseState(isLoading: true),
        );

        // A second state where muscleGroupsState differs (isLoading toggled)
        // so listenWhen returns true, but selectedGroupId is already set.
        final reloadingState = WorkoutsStates(
          muscleGroupsState: const BaseState(
            isLoading: true,
            data: _tMuscleGroups,
          ),
          musclesState: const BaseState(isLoading: true),
        );

        whenListen(
          mockViewModel,
          Stream.fromIterable([loadedState, reloadingState]),
          initialState: initialState,
        );

        await tester.pumpWidget(makeTestableWidget(mockViewModel));
        await tester.pump(); // processes loadedState → auto-selects group '1'
        await tester.pump(); // processes reloadingState → guard blocks

        // Should be called exactly once because after the first call,
        // selectedGroupId is set and the guard prevents re-dispatch.
        verify(
          () => mockViewModel.doIntent(
            any(that: isA<FetchMusclesByGroupEvent>()),
          ),
        ).called(1);
      },
    );
  });

  // ═══════════════════════════════════════════════════════════════════════════
  // 2. UI Composition Check
  // ═══════════════════════════════════════════════════════════════════════════
  group('UI Composition', () {
    late WorkoutsStates loadingState;

    setUp(() {
      loadingState = WorkoutsStates(
        muscleGroupsState: const BaseState(isLoading: true),
        musclesState: const BaseState(),
      );

      whenListen(
        mockViewModel,
        const Stream<WorkoutsStates>.empty(),
        initialState: loadingState,
      );
    });

    testWidgets('renders SharedScaffold', (tester) async {
      await tester.pumpWidget(makeTestableWidget(mockViewModel));
      expect(find.byType(SharedScaffold), findsOneWidget);
    });

    testWidgets('renders "Workouts" title text', (tester) async {
      await tester.pumpWidget(makeTestableWidget(mockViewModel));
      expect(find.text('Workouts'), findsOneWidget);
    });

    testWidgets('renders exactly one WorkoutsTabsList', (tester) async {
      await tester.pumpWidget(makeTestableWidget(mockViewModel));
      expect(find.byType(WorkoutsTabsList), findsOneWidget);
    });

    testWidgets('renders exactly one WorkoutsGrid', (tester) async {
      await tester.pumpWidget(makeTestableWidget(mockViewModel));
      expect(find.byType(WorkoutsGrid), findsOneWidget);
    });
  });

  // ═══════════════════════════════════════════════════════════════════════════
  // 3. Tab Tap Interaction
  // ═══════════════════════════════════════════════════════════════════════════
  group('Tab Tap Interaction', () {
    // Both tap tests need the auto-select to have fired first,
    // so we start from a loading initialState to let listenWhen pass.
    testWidgets(
      'tapping a tab dispatches FetchMusclesByGroupEvent with correct ID',
      (tester) async {
        final initialState = WorkoutsStates(
          muscleGroupsState: const BaseState(isLoading: true),
          musclesState: const BaseState(),
        );

        final loadedState = WorkoutsStates(
          muscleGroupsState: const BaseState(
            isLoading: false,
            data: _tMuscleGroups,
          ),
          musclesState: const BaseState(
            isLoading: false,
            data: _tMuscles,
          ),
        );

        whenListen(
          mockViewModel,
          Stream.fromIterable([loadedState]),
          initialState: initialState,
        );

        await tester.pumpWidget(makeTestableWidget(mockViewModel));
        await tester.pump(); // listener auto-selects group '1'

        // Clear the auto-fetch interaction so we only verify the tap.
        clearInteractions(mockViewModel);
        when(() => mockViewModel.doIntent(any())).thenReturn(null);

        // Tap the 'Back' tab (id: '2')
        await tester.tap(find.text('Back'));
        await tester.pump();

        verify(
          () => mockViewModel.doIntent(
            any(
              that: isA<FetchMusclesByGroupEvent>()
                  .having((e) => e.groupId, 'groupId', '2'),
            ),
          ),
        ).called(1);
      },
    );

    testWidgets(
      'tapping the already-selected tab does NOT dispatch a new event',
      (tester) async {
        final initialState = WorkoutsStates(
          muscleGroupsState: const BaseState(isLoading: true),
          musclesState: const BaseState(),
        );

        final loadedState = WorkoutsStates(
          muscleGroupsState: const BaseState(
            isLoading: false,
            data: _tMuscleGroups,
          ),
          musclesState: const BaseState(
            isLoading: false,
            data: _tMuscles,
          ),
        );

        whenListen(
          mockViewModel,
          Stream.fromIterable([loadedState]),
          initialState: initialState,
        );

        await tester.pumpWidget(makeTestableWidget(mockViewModel));
        await tester.pump(); // listener auto-selects group '1'

        // Clear the auto-fetch interaction.
        clearInteractions(mockViewModel);
        when(() => mockViewModel.doIntent(any())).thenReturn(null);

        // Tap 'Chest' which is already selected (id: '1')
        await tester.tap(find.text('Chest'));
        await tester.pump();

        verifyNever(() => mockViewModel.doIntent(any()));
      },
    );
  });
}
