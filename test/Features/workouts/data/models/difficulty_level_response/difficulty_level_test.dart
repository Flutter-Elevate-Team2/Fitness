import 'package:fitness_app/Features/workouts/data/models/difficulty_level_response/difficulty_level.dart';
import 'package:flutter_test/flutter_test.dart';
// Replace with the actual path to your model

void main() {
  group('DifficultyLevel Model Tests', () {
    const tId = '1';
    const tName = 'Beginner';

    final tDifficultyLevel = DifficultyLevel(
      id: tId,
      name: tName,
    );

    final tJson = {
      'id': tId,
      'name': tName,
    };

    test('fromJson should return a valid model when JSON is provided', () {
      // Act
      final result = DifficultyLevel.fromJson(tJson);

      // Assert
      expect(result.id, equals(tId));
      expect(result.name, equals(tName));
    });

    test('toJson should return a JSON map containing the proper data', () {
      // Act
      final result = tDifficultyLevel.toJson();

      // Assert
      expect(result, equals(tJson));
    });

    test('should handle null values correctly', () {
      // Arrange
      final jsonWithNulls = <String, dynamic>{
        'id': null,
        'name': null,
      };

      // Act
      final result = DifficultyLevel.fromJson(jsonWithNulls);

      // Assert
      expect(result.id, isNull);
      expect(result.name, isNull);
    });

    test('toJson should include null fields when values are null', () {
      // Arrange
      final modelWithNulls = DifficultyLevel(id: null, name: null);

      // Act
      final result = modelWithNulls.toJson();

      // Assert
      expect(result.containsKey('id'), true);
      expect(result.containsKey('name'), true);
      expect(result['id'], isNull);
    });
  });
}