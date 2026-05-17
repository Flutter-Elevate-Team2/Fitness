import 'package:fitness_app/Features/workouts/domain/entities/random_muscles_entity.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('RandomMusclesEntity Tests', () {
    const tId = '1';
    const tName = 'Chest';
    const tImage = 'chest_image_url';

    const tMuscle = RandomMusclesEntity(
      id: tId,
      name: tName,
      image: tImage,
    );

    test('should initialize with correct values', () {
      // Assert
      expect(tMuscle.id, tId);
      expect(tMuscle.name, tName);
      expect(tMuscle.image, tImage);
    });

    test('should support value equality', () {
      // Arrange
      const tMuscle2 = RandomMusclesEntity(
        id: tId,
        name: tName,
        image: tImage,
      );

      // Assert
      // بما أنها تستخدم Equatable، يجب أن تتطابق الكائنات إذا كانت القيم متطابقة
      expect(tMuscle, equals(tMuscle2));
    });

    test('should not be equal when properties are different', () {
      // Arrange
      const tMuscleDifferent = RandomMusclesEntity(
        id: '2',
        name: 'Back',
        image: tImage,
      );

      // Assert
      expect(tMuscle, isNot(equals(tMuscleDifferent)));
    });

    test('props should contain all fields', () {
      // Arrange
      final expectedProps = [tId, tName, tImage];

      // Assert
      expect(tMuscle.props, expectedProps);
    });
  });
}