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
import 'package:shimmer/shimmer.dart';


class MockHomeViewModel extends MockCubit<HomeState> implements HomeViewModel {}

final _mockWorkouts = [
  PopularWorkoutEntity(
    muscleId: 'm1',
    muscleName: 'Biceps',
    muscleImage: 'https://example.com/biceps.jpg',
    levelId: 'l1',
    levelName: 'Beginner',
    exercises: const [
      ExerciseEntity(id: 'e1', title: 'Curl', description: '', sets: 3, reps: 12, thumbnailUrl: ''),
      ExerciseEntity(id: 'e2', title: 'Hammer', description: '', sets: 3, reps: 10, thumbnailUrl: ''),
    ],
  ),
  PopularWorkoutEntity(
    muscleId: 'm2',
    muscleName: 'Chest',
    muscleImage: 'https://example.com/chest.jpg',
    levelId: 'l2',
    levelName: 'Advanced',
    exercises: const [
      ExerciseEntity(id: 'e3', title: 'Bench', description: '', sets: 4, reps: 8, thumbnailUrl: ''),
    ],
  ),
];

void main() {
  late MockHomeViewModel mockViewModel;

  setUp(() {
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
    testWidgets('Should show Shimmer when loading and data is empty', (tester) async {
      // Arrange
      when(() => mockViewModel.state).thenReturn(
        const HomeState(
          popularWorkoutsState: BaseState(isLoading: true, data: []),
        ),
      );

      // Act
      await tester.pumpWidget(createWidgetUnderTest());

      // Assert
       expect(find.byType(Shimmer), findsAtLeastNWidgets(1));
      expect(find.text('Popular Training'), findsOneWidget);
    });

    testWidgets('Should show error message when error occurs', (tester) async {
      // Arrange
      when(() => mockViewModel.state).thenReturn(
        const HomeState(
          popularWorkoutsState: BaseState(
            errorMessage: 'Failed to load workouts',
            data: [],
          ),
        ),
      );

      // Act
      await tester.pumpWidget(createWidgetUnderTest());
      await tester.pump();

      // Assert
      expect(find.text('Failed to load workouts'), findsOneWidget);
    });

    testWidgets('Should render workout cards with correct data', (tester) async {
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

      // Assert
      expect(find.text('Popular Training'), findsOneWidget);

       expect(find.text('See All'), findsNothing);

       expect(find.text('Biceps'), findsOneWidget);
      expect(find.text('2 Tasks'), findsOneWidget);
      expect(find.text('Beginner'), findsOneWidget);

      expect(find.text('Chest'), findsOneWidget);
      expect(find.text('1 Tasks'), findsOneWidget);
    });

   });
}