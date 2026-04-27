import 'package:fitness_app/Features/workouts/data/models/responses/muscle_groups_response.dart';
import 'package:flutter_test/flutter_test.dart';
 import 'package:fitness_app/Features/workouts/data/models/muscle_group_model.dart';

void main() {
  group('MuscleGroupsResponse Model Tests', () {
    const tMessage = 'Success';
    const tId = 'mg1';
    const tName = 'Upper Body';

    final tMuscleGroupModel = MuscleGroupModel(
      id: tId,
      name: tName,
    );

    final tMuscleGroupsResponse = MuscleGroupsResponse(
      message: tMessage,
      musclesGroup: [tMuscleGroupModel],
    );

    final tJson = {
      'message': tMessage,
      'musclesGroup': [
        {
          '_id': tId,
           'name': tName,
        }
      ],
    };

    test('1. fromJson should return a valid model with list of muscle groups', () {
      // Act
      final result = MuscleGroupsResponse.fromJson(tJson);

      // Assert
      expect(result.message, tMessage);
      expect(result.musclesGroup, isNotNull);
      expect(result.musclesGroup!.length, 1);
      expect(result.musclesGroup!.first.id, tId);
      expect(result.musclesGroup!.first.name, tName);
    });

    test('2. toJson should return a map containing the proper data', () {
      // Act
      final result = tMuscleGroupsResponse.toJson();

      // Assert
      expect(result['message'], tMessage);

      final list = result['musclesGroup'] as List;
      final firstItem = list.first;

       if (firstItem is Map) {
        expect(firstItem['_id'], tId);
        expect(firstItem['name'], tName);
      } else {
        expect(firstItem.id, tId);
        expect(firstItem.name, tName);
      }
    });

    test('3. should handle empty musclesGroup list gracefully', () {
      // Arrange
      final jsonWithEmptyList = {
        'message': tMessage,
        'musclesGroup': [],
      };

      // Act
      final result = MuscleGroupsResponse.fromJson(jsonWithEmptyList);

      // Assert
      expect(result.musclesGroup, isEmpty);
    });

    test('4. should handle null values gracefully', () {
      // Arrange
      final jsonWithNulls = <String, dynamic>{
        'message': null,
        'musclesGroup': null,
      };

      // Act
      final result = MuscleGroupsResponse.fromJson(jsonWithNulls);

      // Assert
      expect(result.message, isNull);
      expect(result.musclesGroup, isNull);
    });
  });
}