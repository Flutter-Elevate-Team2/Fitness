import 'package:bloc_test/bloc_test.dart';
import 'package:fitness_app/Features/workouts/domain/entities/muscle_entity.dart';
import 'package:fitness_app/Features/workouts/domain/entities/muscle_group_entity.dart';
import 'package:fitness_app/Features/workouts/presentation/view_models/workouts_events.dart';
import 'package:fitness_app/Features/workouts/presentation/view_models/workouts_states.dart';
import 'package:fitness_app/Features/workouts/presentation/view_models/workouts_view_model.dart';
import 'package:fitness_app/Features/workouts/presentation/views/widgets/grid/workouts_grid.dart';
import 'package:fitness_app/Features/workouts/presentation/views/widgets/muscle_card.dart';
import 'package:fitness_app/Features/workouts/presentation/views/widgets/muscle_group_tab.dart';
import 'package:fitness_app/Features/workouts/presentation/views/widgets/tabs/workouts_tabs_list.dart';
import 'package:fitness_app/core/base_state/base_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:network_image_mock/network_image_mock.dart';
import 'package:shimmer/shimmer.dart';

// ─── Mocks ──────────────────────────────────────────────────────────────────
class MockWorkoutsViewModel extends MockCubit<WorkoutsStates>
    implements WorkoutsViewModel {}

// ─── Test Data ──────────────────────────────────────────────────────────────
const _tMuscleGroups = [
  MuscleGroupEntity(id: '1', name: 'Chest'),
  MuscleGroupEntity(id: '2', name: 'Back'),
  MuscleGroupEntity(id: '3', name: 'Legs'),
];

const _tMuscles = [
  MuscleEntity(id: 'm1', name: 'Pectoralis Major', image: 'https://example.com/pec.png'),
  MuscleEntity(id: 'm2', name: 'Pectoralis Minor', image: 'https://example.com/pec_minor.png'),
];

// ─── Helpers ────────────────────────────────────────────────────────────────
Widget makeTestableWidget(Widget child) {
  return MaterialApp(
    home: Scaffold(
      body: child,
    ),
  );
}

Widget makeTestableSliver(Widget sliver) {
  return MaterialApp(
    home: Scaffold(
      body: CustomScrollView(
        slivers: [sliver],
      ),
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
  });

  // ═══════════════════════════════════════════════════════════════════════════
  // WorkoutsTabsList Tests
  // ═══════════════════════════════════════════════════════════════════════════
  group('WorkoutsTabsList', () {
    testWidgets('renders Shimmer placeholders when muscleGroupsState is loading',
        (tester) async {
      await tester.pumpWidget(
        makeTestableWidget(
          SizedBox(
            height: 48,
            child: WorkoutsTabsList(
              muscleGroupsState: const BaseState(isLoading: true),
              selectedGroupId: null,
              onTabSelected: (_) {},
            ),
          ),
        ),
      );

      expect(find.byType(Shimmer), findsWidgets);
      expect(find.byType(MuscleGroupTab), findsNothing);
    });

    testWidgets('renders error text when muscleGroupsState has error',
        (tester) async {
      await tester.pumpWidget(
        makeTestableWidget(
          SizedBox(
            height: 48,
            child: WorkoutsTabsList(
              muscleGroupsState: const BaseState(
                isLoading: false,
                errorMessage: 'Network error',
              ),
              selectedGroupId: null,
              onTabSelected: (_) {},
            ),
          ),
        ),
      );

      expect(find.text('Network error'), findsOneWidget);
      expect(find.byType(Shimmer), findsNothing);
      expect(find.byType(MuscleGroupTab), findsNothing);
    });

    testWidgets('renders MuscleGroupTab widgets when muscleGroupsState has data',
        (tester) async {
      await tester.pumpWidget(
        makeTestableWidget(
          SizedBox(
            height: 48,
            child: WorkoutsTabsList(
              muscleGroupsState: const BaseState(
                isLoading: false,
                data: _tMuscleGroups,
              ),
              selectedGroupId: '1',
              onTabSelected: (_) {},
            ),
          ),
        ),
      );

      expect(find.byType(MuscleGroupTab), findsNWidgets(_tMuscleGroups.length));
      expect(find.text('Chest'), findsOneWidget);
      expect(find.text('Back'), findsOneWidget);
      expect(find.text('Legs'), findsOneWidget);
    });

    testWidgets('calls onTabSelected when a MuscleGroupTab is tapped',
        (tester) async {
      String? tappedId;

      await tester.pumpWidget(
        makeTestableWidget(
          SizedBox(
            height: 48,
            child: WorkoutsTabsList(
              muscleGroupsState: const BaseState(
                isLoading: false,
                data: _tMuscleGroups,
              ),
              selectedGroupId: '1',
              onTabSelected: (id) => tappedId = id,
            ),
          ),
        ),
      );

      await tester.tap(find.text('Back'));
      expect(tappedId, '2');
    });
  });

  // ═══════════════════════════════════════════════════════════════════════════
  // WorkoutsGrid Tests
  // ═══════════════════════════════════════════════════════════════════════════
  group('WorkoutsGrid', () {
    testWidgets('renders Shimmer placeholders when musclesState is loading',
        (tester) async {
      await tester.pumpWidget(
        makeTestableSliver(
          WorkoutsGrid(
            musclesState: const BaseState(isLoading: true),
          ),
        ),
      );

      expect(find.byType(Shimmer), findsWidgets);
      expect(find.byType(MuscleCard), findsNothing);
    });

    testWidgets('renders error text when musclesState has error',
        (tester) async {
      await tester.pumpWidget(
        makeTestableSliver(
          WorkoutsGrid(
            musclesState: const BaseState(
              isLoading: false,
              errorMessage: 'Failed to load muscles',
            ),
          ),
        ),
      );

      expect(find.text('Failed to load muscles'), findsOneWidget);
      expect(find.byType(Shimmer), findsNothing);
      expect(find.byType(MuscleCard), findsNothing);
    });

    testWidgets('renders MuscleCard widgets when musclesState has data',
        (tester) async {
      await mockNetworkImagesFor(() async {
        await tester.pumpWidget(
          makeTestableSliver(
            WorkoutsGrid(
              musclesState: const BaseState(
                isLoading: false,
                data: _tMuscles,
              ),
            ),
          ),
        );

        expect(find.byType(MuscleCard), findsNWidgets(_tMuscles.length));
      });
    });

    testWidgets('renders empty state text when musclesState data is empty',
        (tester) async {
      await tester.pumpWidget(
        makeTestableSliver(
          WorkoutsGrid(
            musclesState: const BaseState(
              isLoading: false,
              data: <MuscleEntity>[],
            ),
          ),
        ),
      );

      expect(
        find.text('No exercise routines found for this muscle group.'),
        findsOneWidget,
      );
      expect(find.byType(MuscleCard), findsNothing);
    });
  });

  // ═══════════════════════════════════════════════════════════════════════════
  // Integration: Tabs + ViewModel Interaction
  // ═══════════════════════════════════════════════════════════════════════════
  group('WorkoutsTabsList + ViewModel interaction', () {
    testWidgets(
        'tapping a MuscleGroupTab calls doIntent(FetchMusclesByGroupEvent) on the ViewModel',
        (tester) async {
      // Stub the initial state with loaded groups and muscles.
      when(() => mockViewModel.state).thenReturn(
        WorkoutsStates(
          muscleGroupsState: const BaseState(
            isLoading: false,
            data: _tMuscleGroups,
          ),
          musclesState: const BaseState(
            isLoading: false,
            data: _tMuscles,
          ),
        ),
      );

      // Stream emits no further states for this test.
      when(() => mockViewModel.doIntent(any())).thenReturn(null);

      when(() => mockViewModel.stream).thenAnswer(
        (_) => const Stream<WorkoutsStates>.empty(),
      );

      await mockNetworkImagesFor(() async {
        await tester.pumpWidget(
          MaterialApp(
            home: Scaffold(
              body: BlocProvider<WorkoutsViewModel>.value(
                value: mockViewModel,
                child: Builder(
                  builder: (context) {
                    final state = context.watch<WorkoutsViewModel>().state;
                    return CustomScrollView(
                      slivers: [
                        SliverToBoxAdapter(
                          child: SizedBox(
                            height: 48,
                            child: WorkoutsTabsList(
                              muscleGroupsState: state.muscleGroupsState,
                              selectedGroupId: '1',
                              onTabSelected: (id) {
                                context
                                    .read<WorkoutsViewModel>()
                                    .doIntent(FetchMusclesByGroupEvent(id));
                              },
                            ),
                          ),
                        ),
                        WorkoutsGrid(musclesState: state.musclesState),
                      ],
                    );
                  },
                ),
              ),
            ),
          ),
        );
      });

      // Tap the 'Back' tab (id: '2')
      await tester.tap(find.text('Back'));
      await tester.pump();

      // Verify that doIntent was called with FetchMusclesByGroupEvent('2')
      verify(
        () => mockViewModel.doIntent(
          any(that: isA<FetchMusclesByGroupEvent>().having(
            (e) => e.groupId,
            'groupId',
            '2',
          )),
        ),
      ).called(1);
    });
  });
}
