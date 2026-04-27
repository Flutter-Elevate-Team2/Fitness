import 'package:fitness_app/Features/home/data/models/levels_respones/level.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('Level Model Tests', () {
    const mockId = '123';
    const mockName = 'Beginner';

    final mockJson = {
      '_id': mockId,
      'name': mockName,
    };

    test('should successfully convert JSON to Level Object (fromJson)', () {
      // Act
      final result = Level.fromJson(mockJson);

      // Assert
      expect(result.id, mockId);
      expect(result.name, mockName);
    });

    test('should successfully convert Level Object to JSON (toJson)', () {
      // Arrange
      final level = Level(id: mockId, name: mockName);

      // Act
      final result = level.toJson();

      // Assert
      expect(result['_id'], mockId);
      expect(result['name'], mockName);
    });

    test('should maintain data integrity during Round Trip conversion', () {
      // Arrange
      final originalLevel = Level(id: mockId, name: mockName);

      // Act
      final json = originalLevel.toJson();
      final resultLevel = Level.fromJson(json);

      // Assert
      expect(resultLevel.id, originalLevel.id);
      expect(resultLevel.name, originalLevel.name);
    });
  });
}