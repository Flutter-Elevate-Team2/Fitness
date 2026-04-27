import 'package:flutter_test/flutter_test.dart';
import 'package:fitness_app/Features/workouts/data/models/muscle_group_model.dart';
import 'package:hive_ce/hive.dart';

void main() {
  group('MuscleGroupModel Tests', () {
    const tId = '65f123abc';
    const tName = 'Chest';

    final tModel = MuscleGroupModel(
      id: tId,
      name: tName,
    );

    final tJson = {
      '_id': tId,
       'name': tName,
    };

    test('1. fromJson should return a valid model when provided with valid JSON', () {
      // Act
      final result = MuscleGroupModel.fromJson(tJson);

      // Assert
      expect(result.id, tId);
      expect(result.name, tName);
    });

    test('2. toJson should return a JSON map containing the proper data', () {
      // Act
      final result = tModel.toJson();

      // Assert
      final expectedJson = {
        '_id': tId,
        'name': tName,
      };
      expect(result, expectedJson);
    });

    test('3. should be a subclass of HiveObject', () {
      // Assert
       expect(tModel, isA<HiveObject>());
    });

    test('4. should initialize with required values', () {
      // Assert
      expect(tModel.id, tId);
      expect(tModel.name, tName);
    });
  });
}