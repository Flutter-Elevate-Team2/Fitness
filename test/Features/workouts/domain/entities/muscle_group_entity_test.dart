import 'package:flutter_test/flutter_test.dart';
// Replace with the actual path to your entity
import 'package:fitness_app/Features/workouts/domain/entities/muscle_group_entity.dart';

void main() {
  group('MuscleGroupEntity', () {
    const tId = '1';
    const tName = 'Chest';

    const tMuscleGroup = MuscleGroupEntity(
      id: tId,
      name: tName,
    );

    test('should support value equality', () {
      // Arrange
      const otherMuscleGroup = MuscleGroupEntity(
        id: tId,
        name: tName,
      );

      // Assert
      // Because of Equatable, these two separate instances should be equal
      expect(tMuscleGroup, equals(otherMuscleGroup));
    });

    test('props should contain correct values', () {
      // Assert
      // Verification that all fields are part of the props list
      expect(
        tMuscleGroup.props,
        equals([tId, tName]),
      );
    });

    test('should not be equal when properties are different', () {
      // Arrange
      const differentMuscleGroup = MuscleGroupEntity(
        id: '2',
        name: tName,
      );

      // Assert
      expect(tMuscleGroup, isNot(equals(differentMuscleGroup)));
    });
  });
}