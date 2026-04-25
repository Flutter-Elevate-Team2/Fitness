import 'package:fitness_app/Features/workouts/data/models/difficulty_level_response/difficulty_level.dart';
import 'package:fitness_app/Features/workouts/data/models/difficulty_level_response/difficulty_level_response.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('DifficultyLevelResponse Model Tests', () {
    const tMessage = 'Success';
    const tTotalLevels = 2;

    final tDifficultyLevelList = [
      DifficultyLevel(id: '1', name: 'Beginner'),
      DifficultyLevel(id: '2', name: 'Expert'),
    ];

    final tDifficultyLevelResponse = DifficultyLevelResponse(
      message: tMessage,
      totalLevels: tTotalLevels,
      difficultyLevels: tDifficultyLevelList,
    );

    final tJson = {
      'message': tMessage,
      'totalLevels': tTotalLevels,
      'difficulty_levels': [
        {'id': '1', 'name': 'Beginner'},
        {'id': '2', 'name': 'Expert'},
      ],
    };

    test('fromJson should return a valid model with nested difficulty levels', () {
      // Act
      final result = DifficultyLevelResponse.fromJson(tJson);

      // Assert
      expect(result.message, equals(tMessage));
      expect(result.totalLevels, equals(tTotalLevels));
      expect(result.difficultyLevels, isA<List<DifficultyLevel>>());
      expect(result.difficultyLevels?.length, equals(2));
      expect(result.difficultyLevels?[0].name, equals('Beginner'));
    });


    test('should handle null fields in response', () {
      // Arrange
      final jsonWithNulls = <String, dynamic>{
        'message': null,
        'totalLevels': null,
        'difficulty_levels': null,
      };

      // Act
      final result = DifficultyLevelResponse.fromJson(jsonWithNulls);

      // Assert
      expect(result.message, isNull);
      expect(result.difficultyLevels, isNull);
    });

    test('should correctly parse numeric types (num)', () {
      // Arrange
      final jsonWithInt = {'totalLevels': 5};
      final jsonWithDouble = {'totalLevels': 5.5};

      // Act
      final resultInt = DifficultyLevelResponse.fromJson(jsonWithInt);
      final resultDouble = DifficultyLevelResponse.fromJson(jsonWithDouble);

      // Assert
      expect(resultInt.totalLevels, equals(5));
      expect(resultDouble.totalLevels, equals(5.5));
    });
  });
}