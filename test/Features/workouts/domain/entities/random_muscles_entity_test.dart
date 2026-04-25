import 'package:flutter_test/flutter_test.dart';
// Replace with your actual path
import 'package:fitness_app/Features/workouts/domain/entities/random_muscles_entity.dart';

void main() {
  group('RandomMusclesEntity', () {
    const tId = '1';
    const tName = 'Biceps';
    const tImage = 'https://example.com/image.png';

    const tRandomMuscle = RandomMusclesEntity(
      id: tId,
      name: tName,
      image: tImage,
    );

    test('should support value equality', () {
      // Arrange
      const otherMuscle = RandomMusclesEntity(
        id: tId,
        name: tName,
        image: tImage,
      );

      // Assert
      // Objects with the same properties should be equal thanks to Equatable
      expect(tRandomMuscle, equals(otherMuscle));
    });

    test('props should contain correct values', () {
      // Assert
      // Ensure all fields are included in the props list for comparison
      expect(
        tRandomMuscle.props,
        equals([tId, tName, tImage]),
      );
    });

    test('should not be equal when properties are different', () {
      // Arrange
      const differentMuscle = RandomMusclesEntity(
        id: '2', // Different ID
        name: tName,
        image: tImage,
      );

      // Assert
      expect(tRandomMuscle, isNot(equals(differentMuscle)));
    });

    test('should be a subclass of Equatable', () {
      // Assert
      expect(tRandomMuscle, isA<RandomMusclesEntity>());
    });
  });
}