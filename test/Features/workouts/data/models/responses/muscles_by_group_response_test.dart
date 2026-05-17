import 'package:fitness_app/Features/workouts/data/models/responses/muscles_by_group_response.dart';
import 'package:flutter_test/flutter_test.dart';
 import 'package:fitness_app/Features/workouts/data/models/muscle_group_model.dart';
import 'package:fitness_app/Features/workouts/data/models/muscle_model.dart';

void main() {
  group('MusclesByGroupResponse Model Tests', () {
    const tMessage = 'Success';

     const tGroupId = 'g1';
    const tGroupName = 'Chest';

     const tMuscleId = 'm1';
    const tMuscleName = 'Pectoralis Major';

    final tMuscleGroup = MuscleGroupModel(id: tGroupId, name: tGroupName);
    final tMuscleModel = MuscleModel(id: tMuscleId, name: tMuscleName);

    final tResponse = MusclesByGroupResponse(
      message: tMessage,
      muscleGroup: tMuscleGroup,
      muscles: [tMuscleModel],
    );

    final tJson = {
      'message': tMessage,
      'muscleGroup': {
        '_id': tGroupId,
        'name': tGroupName,
      },
      'muscles': [
        {
          '_id': tMuscleId,
          'name': tMuscleName,
        }
      ],
    };

    test('1. fromJson should return a valid model with nested objects', () {
      // Act
      final result = MusclesByGroupResponse.fromJson(tJson);

      // Assert
      expect(result.message, tMessage);

       expect(result.muscleGroup, isNotNull);
      expect(result.muscleGroup!.id, tGroupId);

       expect(result.muscles, isNotNull);
      expect(result.muscles!.length, 1);
      expect(result.muscles!.first.id, tMuscleId);
    });

    test('2. toJson should return a map containing the proper data', () {
      // Act
      final result = tResponse.toJson();

      // Assert
      expect(result['message'], tMessage);

       final groupData = result['muscleGroup'];
      if (groupData is Map) {
        expect(groupData['_id'], tGroupId);
      } else {
        expect(groupData.id, tGroupId);
      }

       final list = result['muscles'] as List;
      if (list.first is Map) {
        expect(list.first['_id'], tMuscleId);
      } else {
        expect(list.first.id, tMuscleId);
      }
    });

    test('3. should handle null fields gracefully', () {
      // Arrange
      final jsonWithNulls = <String, dynamic>{
        'message': null,
        'muscleGroup': null,
        'muscles': null,
      };

      // Act
      final result = MusclesByGroupResponse.fromJson(jsonWithNulls);

      // Assert
      expect(result.message, isNull);
      expect(result.muscleGroup, isNull);
      expect(result.muscles, isNull);
    });
  });
}