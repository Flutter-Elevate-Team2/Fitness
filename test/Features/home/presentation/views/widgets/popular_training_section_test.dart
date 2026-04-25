import 'package:fitness_app/Features/home/domain/entities/popular_tranning_entity.dart';
import 'package:fitness_app/Features/home/presentation/view_model/home_state.dart';
import 'package:fitness_app/Features/home/presentation/view_model/home_view_model.dart';
import 'package:fitness_app/Features/home/presentation/views/widgets/popular_training_section.dart';
import 'package:fitness_app/Features/workouts/domain/entities/exercise_entity.dart';
import 'package:fitness_app/core/base_state/base_state.dart';
import 'package:bloc_test/bloc_test.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:network_image_mock/network_image_mock.dart';

// ── Mocks ────────────────────────────────────────────────────────────────────
class MockHomeViewModel extends MockCubit<HomeState> implements HomeViewModel {}

// ── Test Data ────────────────────────────────────────────────────────────────
final _mockWorkouts = [
  PopularWorkoutEntity(
    muscleId: 'm1',
    muscleName: 'Biceps',
    muscleImage: 'https://example.com/biceps.jpg',
    levelId: 'l1',
    levelName: 'Beginner',
    exercises: const [
      ExerciseEntity(
        id: 'e1',
        title: 'Curl',
        description: 'Bicep curl',
        sets: 3,
        reps: 12,
        thumbnailUrl: 'https://example.com/thumb.jpg',
      ),
      ExerciseEntity(
        id: 'e2',
        title: 'Hammer Curl',
        description: 'Hammer curl',
        sets: 3,
        reps: 10,
        thumbnailUrl: 'https://example.com/thumb2.jpg',
      ),
    ],
  ),
  PopularWorkoutEntity(
    muscleId: 'm2',
    muscleName: 'Chest',
    muscleImage: 'https://example.com/chest.jpg',
    levelId: 'l2',
    levelName: 'Advanced',
    exercises: const [
      ExerciseEntity(
        id: 'e3',
        title: 'Bench Press',
        description: 'Flat bench press',
        sets: 4,
        reps: 8,
        thumbnailUrl: 'https://example.com/thumb3.jpg',
      ),
    ],
  ),
];

void main() {
  late MockHomeViewModel mockViewModel;

  setUp(() {
    final binding = TestWidgetsFlutterBinding.ensureInitialized();
    binding.platformDispatcher.implicitView!.physicalSize =
        const Size(1200, 800);
    binding.platformDispatcher.implicitView!.devicePixelRatio = 1.0;

    mockViewModel = MockHomeViewModel();
  });

  Widget createWidgetUnderTest() {
    return MaterialApp(
      home: Scaffold(
        body: BlocProvider<HomeViewModel>.value(
          value: mockViewModel,
          child: const PopularTrainingSection(),
        ),
      ),
    );
  }

  group('PopularTrainingSection', () {
    testWidgets('shows CircularProgressIndicator when loading',
        (WidgetTester tester) async {
      // Arrange
      when(() => mockViewModel.state).thenReturn(
        const HomeState(
          popularWorkoutsState: BaseState(isLoading: true),
        ),
      );

      // Act
      await tester.pumpWidget(createWidgetUnderTest());
      await tester.pump();

      // Assert
      expect(find.byType(CircularProgressIndicator), findsOneWidget);
      expect(find.text('Popular Training'), findsOneWidget);
    });

    testWidgets('shows error message when error occurs',
        (WidgetTester tester) async {
      // Arrange
      when(() => mockViewModel.state).thenReturn(
        const HomeState(
          popularWorkoutsState: BaseState(
            errorMessage: 'Failed to load workouts',
          ),
        ),
      );

      // Act
      await tester.pumpWidget(createWidgetUnderTest());
      await tester.pump();

      // Assert
      expect(find.text('Failed to load workouts'), findsOneWidget);
      expect(find.byType(CircularProgressIndicator), findsNothing);
    });

    testWidgets(
        'renders workout cards with correct data when workouts are loaded',
        (WidgetTester tester) async {
      // Arrange
      when(() => mockViewModel.state).thenReturn(
        HomeState(
          popularWorkoutsState: BaseState(data: _mockWorkouts),
        ),
      );

      // Act – mockNetworkImagesFor handles NetworkImage in tests
      await mockNetworkImagesFor(() async {
        await tester.pumpWidget(createWidgetUnderTest());
        await tester.pump();
      });

      // Assert – section header
      expect(find.text('Popular Training'), findsOneWidget);
      expect(find.text('See All'), findsOneWidget);

      // Assert – first card
      expect(find.text('Biceps'), findsOneWidget);
      expect(find.text('2 Tasks'), findsOneWidget); // 2 exercises
      expect(find.text('Beginner'), findsOneWidget);

      // Assert – second card
      expect(find.text('Chest'), findsOneWidget);
      expect(find.text('1 Tasks'), findsOneWidget); // 1 exercise
      expect(find.text('Advanced'), findsOneWidget);

      // Assert – no loading or error
      expect(find.byType(CircularProgressIndicator), findsNothing);
    });

    testWidgets('renders correct number of workout cards',
        (WidgetTester tester) async {
      // Arrange
      when(() => mockViewModel.state).thenReturn(
        HomeState(
          popularWorkoutsState: BaseState(data: _mockWorkouts),
        ),
      );

      // Act
      await mockNetworkImagesFor(() async {
        await tester.pumpWidget(createWidgetUnderTest());
        await tester.pump();
      });

      // Assert – ListView with 2 items identified by their unique muscle names
      expect(find.byType(ListView), findsOneWidget);
      expect(find.text('Biceps'), findsOneWidget);
      expect(find.text('Chest'), findsOneWidget);
    });

    testWidgets('shows loading spinner even with empty list',
        (WidgetTester tester) async {
      // Arrange – loading: true + data is empty list (not null)
      when(() => mockViewModel.state).thenReturn(
        const HomeState(
          popularWorkoutsState: BaseState(isLoading: true, data: []),
        ),
      );

      // Act
      await tester.pumpWidget(createWidgetUnderTest());
      await tester.pump();

      // Assert
      expect(find.byType(CircularProgressIndicator), findsOneWidget);
    });
  });
}
