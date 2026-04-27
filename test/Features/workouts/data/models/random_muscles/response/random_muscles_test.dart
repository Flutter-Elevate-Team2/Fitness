import 'package:fitness_app/Features/workouts/data/models/random_muscles/response/random_muscles.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('RandomMuscles Model Tests', () {
    const tMessage = 'Success';
    const tTotalMuscles = 1;
    const tId = 'm1';
    const tName = 'Biceps';
    const tImage = 'biceps_url';

    final tMusclesModel = Muscles(
      id: tId,
      name: tName,
      image: tImage,
    );

    final tRandomMusclesResponse = RandomMuscles(
      message: tMessage,
      totalMuscles: tTotalMuscles,
      muscles: [tMusclesModel],
    );

    final tJson = {
      'message': tMessage,
      'totalMuscles': tTotalMuscles,
      'muscles': [
        {
          '_id': tId,
           'name': tName,
          'image': tImage,
        }
      ],
    };

    test('1. fromJson should return a valid model', () {
      // Act
      final result = RandomMuscles.fromJson(tJson);

      // Assert
      expect(result.message, tMessage);
      expect(result.totalMuscles, tTotalMuscles);
      expect(result.muscles, isNotNull);
      expect(result.muscles!.length, 1);

       expect(result.muscles!.first.id, tId);
      expect(result.muscles!.first.name, tName);
    });

    test('2. toJson should return a map containing the proper data', () {
      // Act
      final result = tRandomMusclesResponse.toJson();

      // Assert
      expect(result['message'], tMessage);
      expect(result['totalMuscles'], tTotalMuscles);

      final list = result['muscles'] as List;
      final firstItem = list.first;

       if (firstItem is Map) {
        expect(firstItem['_id'], tId);
        expect(firstItem['name'], tName);
      } else {
        expect(firstItem.id, tId);
        expect(firstItem.name, tName);
      }
    });

    test('3. should handle null values gracefully', () {
      // Arrange
      final jsonWithNulls = <String, dynamic>{
        'message': null,
        'totalMuscles': null,
        'muscles': null,
      };

      // Act
      final result = RandomMuscles.fromJson(jsonWithNulls);

      // Assert
      expect(result.message, isNull);
      expect(result.totalMuscles, isNull);
      expect(result.muscles, isNull);
    });

    group('Muscles Sub-Model Tests', () {
      test('Muscles.fromJson should map _id to id correctly', () {
        final muscleJson = {'_id': '123', 'name': 'Chest', 'image': 'url'};
        final result = Muscles.fromJson(muscleJson);

        expect(result.id, '123');
        expect(result.name, 'Chest');
      });

      test('Muscles.toJson should output _id instead of id', () {
        final muscle = Muscles(id: '123', name: 'Chest', image: 'url');
        final result = muscle.toJson();

        expect(result['_id'], '123');
        expect(result.containsKey('id'), false);
      });
    });
  });
}