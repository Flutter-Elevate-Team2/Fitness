import 'package:fitness_app/Features/home/domain/entities/popular_tranning_entity.dart';
import 'package:fitness_app/Features/workouts/domain/entities/exercise_entity.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('PopularWorkoutEntity Tests', () {
    final mockExercises = [
      const ExerciseEntity(
        id: 'e1',
        title: '',
        description: '',
        sets: 0,
        reps: 0,
        thumbnailUrl: '',
      ),
      const ExerciseEntity(
        id: 'e2',
        title: '',
        description: '',
        sets: 0,
        reps: 0,
        thumbnailUrl: '',
      ),
    ];

    test(
      'should correctly calculate totalExercises from the list of exercises',
      () {
        // Arrange
        final entity = PopularWorkoutEntity(
          muscleId: '1',
          muscleName: 'Chest',
          muscleImage: 'url',
          levelId: '10',
          levelName: 'Hard',
          exercises: mockExercises,
        );

        // Act & Assert
        expect(entity.totalExercises, 2);
      },
    );

    test(
      'should consider two objects equal if they have the same muscleId and levelId (based on props)',
      () {
        // Arrange
        final entity1 = PopularWorkoutEntity(
          muscleId: '1',
          muscleName: 'Chest',
          muscleImage: 'url1',
          levelId: '10',
          levelName: 'Hard',
          exercises: mockExercises,
        );

        final entity2 = PopularWorkoutEntity(
          muscleId: '1',
          muscleName: 'Back',
          muscleImage: 'url2',
          levelId: '10',
          levelName: 'Easy',
          exercises: const [],
        );

        // Assert
        expect(entity1, equals(entity2));
      },
    );

    test(
      'should contain only the specified fields (muscleId, levelId) in props',
      () {
        // Arrange
        const entity = PopularWorkoutEntity(
          muscleId: '1',
          muscleName: 'X',
          muscleImage: 'Y',
          levelId: '10',
          levelName: 'Z',
          exercises: [],
        );

        // Assert
        expect(entity.props, ['1', '10']);
      },
    );
  });
}
