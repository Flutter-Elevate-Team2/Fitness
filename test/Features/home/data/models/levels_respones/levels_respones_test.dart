import 'package:fitness_app/Features/home/data/models/levels_respones/level.dart';
import 'package:fitness_app/Features/home/data/models/levels_respones/levels_respones.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('LevelsRespones Model Tests', () {

    final mockLevelsJson = [
      {'_id': '1', 'name': 'Beginner'},
      {'_id': '2', 'name': 'Intermediate'},
    ];

    final mockResponseJson = {
      'message': 'Success',
      'levels': mockLevelsJson,
    };

    test('should successfully convert JSON to LevelsRespones object (fromJson)', () {
      // Act
      final result = LevelsRespones.fromJson(mockResponseJson);

      // Assert
      expect(result.message, 'Success');
      expect(result.levels, isA<List<Level>>());
      expect(result.levels?.length, 2);
      expect(result.levels?[0].id, '1');
      expect(result.levels?[0].name, 'Beginner');
    });

    test('should successfully convert LevelsRespones object to JSON (toJson)', () {
      // Arrange
      final response = LevelsRespones(
        message: 'Done',
        levels: [
          Level(id: '10', name: 'Pro'),
        ],
      );

      // Act
      final result = response.toJson();

      // Assert
      expect(result['message'], 'Done');
      expect(result['levels'], isA<List>());

      // Note: Cast depends on how your toJson is implemented (returning Map or List of Objects)
      final firstLevel = result['levels'][0];
      expect(firstLevel.id, '10');
      expect(firstLevel.name, 'Pro');
    });

    test('should handle null or empty values gracefully (Null Safety)', () {
      // Arrange
      final emptyJson = <String, dynamic>{};

      // Act
      final result = LevelsRespones.fromJson(emptyJson);

      // Assert
      expect(result.message, isNull);
      expect(result.levels, isNull);
    });
  });
}