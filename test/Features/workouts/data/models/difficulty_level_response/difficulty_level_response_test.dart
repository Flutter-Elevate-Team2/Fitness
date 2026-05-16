import 'package:fitness_app/Features/workouts/data/models/difficulty_level_response/difficulty_level.dart';
import 'package:fitness_app/Features/workouts/data/models/difficulty_level_response/difficulty_level_response.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('DifficultyLevelResponse Model Tests', () {
     final tDifficultyLevel = DifficultyLevel(
      id: '1',
      name: 'Beginner',
    );

    final tDifficultyLevelResponse = DifficultyLevelResponse(
      message: 'Success',
      totalLevels: 1,
      difficultyLevels: [tDifficultyLevel],
    );

    final tJson = {
      'message': 'Success',
      'totalLevels': 1,
      'difficulty_levels': [
        {'id': '1', 'levelName': 'Beginner'}
      ],
    };

    test('fromJson should return a valid model', () {
      // Act
      final result = DifficultyLevelResponse.fromJson(tJson);

      // Assert
      expect(result.message, tDifficultyLevelResponse.message);
      expect(result.totalLevels, tDifficultyLevelResponse.totalLevels);
      expect(result.difficultyLevels?.first.id, tDifficultyLevel.id);
      expect(result.difficultyLevels?.length, 1);
    });

     test('2. toJson should return a JSON map containing the proper data', () {
       // Act
       final result = tDifficultyLevelResponse.toJson();

       // Assert
       expect(result['message'], 'Success');
       expect(result['totalLevels'], 1);

       final list = result['difficulty_levels'] as List;

        expect(list[0], isA<DifficultyLevel>());
       expect(list[0].id, tDifficultyLevel.id);
        expect(list[0].name,tDifficultyLevel.name );
     });

     test('should handle null values gracefully', () {
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
      expect(result.totalLevels, isNull);
      expect(result.difficultyLevels, isNull);
    });
  });
}