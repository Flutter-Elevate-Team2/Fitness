import 'package:fitness_app/Features/workouts/domain/entities/difficulty_level_entity.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('DifficultyLevelEntity Tests', () {
    const id = '1';
    const name = 'Beginner';

    test(
      'should consider two objects equal if they have the same data (Value Equality)',
      () {
        // Arrange & Act
        const entity1 = DifficultyLevelEntity(id: id, name: name);
        const entity2 = DifficultyLevelEntity(id: id, name: name);

        // Assert
        expect(entity1, equals(entity2));
      },
    );

    test('should not be equal if the data is different', () {
      // Arrange
      const entity1 = DifficultyLevelEntity(id: '1', name: 'Easy');
      const entity2 = DifficultyLevelEntity(id: '2', name: 'Easy');

      // Assert
      expect(entity1, isNot(equals(entity2)));
    });

    test('should contain all fields (id, name) in props', () {
      // Arrange
      const entity = DifficultyLevelEntity(id: id, name: name);

      // Assert
      expect(entity.props, [id, name]);
    });
  });
}
