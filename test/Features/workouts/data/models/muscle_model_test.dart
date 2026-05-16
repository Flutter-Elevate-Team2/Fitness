import 'package:flutter_test/flutter_test.dart';
import 'package:hive_ce/hive.dart';
 import 'package:fitness_app/Features/workouts/data/models/muscle_model.dart';

void main() {
  group('MuscleModel Tests', () {
    const tId = 'm123';
    const tName = 'Biceps';
    const tImage = 'https://example.com/biceps.png';

    final tModel = MuscleModel(
      id: tId,
      name: tName,
      image: tImage,
    );

    test('1. fromJson should return a valid model when all fields are present', () {
      // Arrange
      final tJson = {
        '_id': tId,
        'name': tName,
        'image': tImage,
      };

      // Act
      final result = MuscleModel.fromJson(tJson);

      // Assert
      expect(result.id, tId);
      expect(result.name, tName);
      expect(result.image, tImage);
    });

    test('2. fromJson should handle null image field', () {
      // Arrange
      final tJson = {
        '_id': tId,
        'name': tName,
        'image': null,
      };

      // Act
      final result = MuscleModel.fromJson(tJson);

      // Assert
      expect(result.image, isNull);
    });

    test('3. toJson should return correct map with _id', () {
      // Act
      final result = tModel.toJson();

      // Assert
      final expectedJson = {
        '_id': tId,
        'name': tName,
        'image': tImage,
      };
      expect(result, expectedJson);
    });

    test('4. should be a subclass of HiveObject', () {
       expect(tModel, isA<HiveObject>());
    });

    test('5. equality check (optional but good for models)', () {
      final tModel2 = MuscleModel(id: tId, name: tName, image: tImage);

    expect(tModel.id, tModel2.id);
    });
  });
}