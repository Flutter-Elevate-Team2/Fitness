import 'package:fitness_app/Features/workouts/data/models/exercises_response/exercise.dart';
import 'package:fitness_app/Features/workouts/data/models/exercises_response/exercises_response.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('ExercisesResponse Model Tests', () {
    const tMessage = 'Success';
    const tTotalExercises = 100;
    const tTotalPages = 10;
    const tCurrentPage = 1;

    final tExercise = Exercise(
      id: '1',
      exercise: 'Push Up',
     );

    final tExercisesResponse = ExercisesResponse(
      message: tMessage,
      totalExercises: tTotalExercises,
      totalPages: tTotalPages,
      currentPage: tCurrentPage,
      exercises: [tExercise],
    );

    test('1. fromJson should return a valid model', () {
       final Map<String, dynamic> localJson = {
        'message': tMessage,
        'totalExercises': tTotalExercises,
        'totalPages': tTotalPages,
        'currentPage': tCurrentPage,
        'exercises': [
          {
            '_id': '1',
            'id': '1',
            'exercise': 'Push Up',
            'name': 'Push Up',
          }
        ],
      };

      // Act
      final result = ExercisesResponse.fromJson(localJson);

      // Assert
      expect(result.message, tMessage);
      expect(result.exercises, isNotNull);
      expect(result.exercises!.length, 1);

      expect(result.exercises!.first.id, '1');
    });
    test('2. toJson should return a map containing the proper data', () {
      // Act
      final result = tExercisesResponse.toJson();

      // Assert
      expect(result['message'], tMessage);
      expect(result['totalExercises'], tTotalExercises);
      expect(result['totalPages'], tTotalPages);

      final list = result['exercises'] as List;

       if (list.first is Map) {
        expect(list.first['id'], '1');
      } else {
        expect(list.first.id, '1');
      }
    });

    test('3. should handle null values gracefully', () {
      // Arrange
      final jsonWithNulls = <String, dynamic>{
        'message': null,
        'totalExercises': null,
        'totalPages': null,
        'currentPage': null,
        'exercises': null,
      };

      // Act
      final result = ExercisesResponse.fromJson(jsonWithNulls);

      // Assert
      expect(result.message, isNull);
      expect(result.exercises, isNull);
    });
  });
}