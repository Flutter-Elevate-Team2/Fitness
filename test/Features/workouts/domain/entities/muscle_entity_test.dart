import 'package:flutter_test/flutter_test.dart';
// Replace with the actual path to your entity
import 'package:fitness_app/Features/workouts/domain/entities/muscle_entity.dart';

void main() {
  group('MuscleEntity', () {
    const tId = '1';
    const tName = 'Triceps';
    const tImage = 'https://example.com/triceps.png';

    const tMuscle = MuscleEntity(
      id: tId,
      name: tName,
      image: tImage,
    );

    test('should support value equality', () {
      // Arrange
      const otherMuscle = MuscleEntity(
        id: tId,
        name: tName,
        image: tImage,
      );

      // Assert
      expect(tMuscle, equals(otherMuscle));
    });

    test('should be equal even if image is null for both instances', () {
      // Arrange
      const muscle1 = MuscleEntity(id: tId, name: tName, image: null);
      const muscle2 = MuscleEntity(id: tId, name: tName, image: null);

      // Assert
      expect(muscle1, equals(muscle2));
    });

    test('props should contain correct values including nullable image', () {
      // Assert
      expect(
        tMuscle.props,
        equals([tId, tName, tImage]),
      );
    });

    test('should not be equal when image differs (one null, one provided)', () {
      // Arrange
      const muscleWithNoImage = MuscleEntity(
        id: tId,
        name: tName,
        image: null,
      );

      // Assert
      expect(tMuscle, isNot(equals(muscleWithNoImage)));
    });

    test('should not be equal when ID or name is different', () {
      // Arrange
      const differentMuscle = MuscleEntity(
        id: '2',
        name: 'Biceps',
        image: tImage,
      );

      // Assert
      expect(tMuscle, isNot(equals(differentMuscle)));
    });
  });
}