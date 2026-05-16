import 'package:fitness_app/Features/workouts/data/models/random_muscle_model.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:hive_ce/hive.dart';


void main() {
  group('RandomMuscleModel Tests', () {
    const tId = 'rm_789';
    const tName = 'Quadriceps';
    const tImage = 'https://fitness-app.com/images/quads.png';

    final tModel = RandomMuscleModel(
      id: tId,
      name: tName,
      image: tImage,
    );

    final tJson = {
      '_id': tId,
       'name': tName,
      'image': tImage,
    };

    test('1. fromJson should create a valid model from JSON', () {
      // Act
      final result = RandomMuscleModel.fromJson(tJson);

      // Assert
      expect(result.id, tId);
      expect(result.name, tName);
      expect(result.image, tImage);
    });

    test('2. toJson should return a map with correct keys (using _id)', () {
      // Act
      final result = tModel.toJson();

      // Assert
      expect(result['_id'], tId);
      expect(result['name'], tName);
      expect(result['image'], tImage);
    });

    test('3. should be a subclass of HiveObject', () {
       expect(tModel, isA<HiveObject>());
    });

    test('4. props check (Manual verification)', () {
       expect(tModel.id, isNotNull);
      expect(tModel.name, isNotEmpty);
      expect(tModel.image.startsWith('http'), true);
    });
  });
}