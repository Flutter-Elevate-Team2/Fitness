import 'package:fitness_app/Features/workouts/data/models/exercises_response/exercise.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('Exercise Model Tests', () {
    final Map<String, dynamic> tExerciseJson = {
      '_id': '65a123',
      'exercise': 'Push Up',
      'short_youtube_demonstration': 'vid_id_1',
      'in_depth_youtube_explanation': 'vid_id_2',
      'difficulty_level': 'Beginner',
      'target_muscle_group': 'Chest',
      'prime_mover_muscle': 'Pectoralis Major',
      'secondary_muscle': 'Triceps',
      'tertiary_muscle': 'Deltoids',
      'primary_equipment': 'Bodyweight',
      '_primary_items': 1,
      'secondary_equipment': null,
      '_secondary_items': 0,
      'posture': 'Prone',
      'single_or_double_arm': 'Double',
      'continuous_or_alternating_arms': 'Continuous',
      'grip': 'Overhand',
      'load_position_ending': 'Chest',
      'continuous_or_alternating_legs': 'Continuous',
      'foot_elevation': 'Floor',
      'combination_exercises': 'No',
      'movement_pattern_1': 'Push',
      'movement_pattern_2': null,
      'movement_pattern_3': null,
      'plane_of_motion_1': 'Sagittal',
      'plane_of_motion_2': null,
      'plane_of_motion_3': null,
      'body_region': 'Upper Body',
      'force_type': 'Push',
      'mechanics': 'Compound',
      'laterality': 'Bilateral',
      'primary_exercise_classification': 'Strength',
      'short_youtube_demonstration_link': 'https://link1.com',
      'in_depth_youtube_explanation_link': 'https://link2.com',
    };

    test('should return a valid model from JSON', () {
      final result = Exercise.fromJson(tExerciseJson);

      expect(result, isA<Exercise>());
      expect(result.id, '65a123');
      expect(result.exercise, 'Push Up');
      expect(result.shortYoutubeDemonstration, 'vid_id_1');
      expect(result.primaryItems, 1);
      expect(result.shortYoutubeDemonstrationLink, 'https://link1.com');
    });

    test('should return a JSON map containing proper data', () {
      final model = Exercise(
        id: '65a123',
        exercise: 'Push Up',
        shortYoutubeDemonstration: 'vid_id_1',
        primaryItems: 1,
        shortYoutubeDemonstrationLink: 'https://link1.com',
      );

      final result = model.toJson();

      expect(result['_id'], '65a123');
      expect(result['exercise'], 'Push Up');
      expect(result['short_youtube_demonstration'], 'vid_id_1');
      expect(result['_primary_items'], 1);
      expect(result['short_youtube_demonstration_link'], 'https://link1.com');
    });

    test('should handle null values correctly', () {
      final jsonWithNulls = <String, dynamic>{'_id': '123'};

      final result = Exercise.fromJson(jsonWithNulls);

      expect(result.id, '123');
      expect(result.exercise, isNull);
      expect(result.primaryItems, isNull);
    });

    test('should support dynamic types for specific fields', () {
      final Map<String, dynamic> jsonWithDynamic = {
        'secondary_equipment': 'Dumbbell',
        'movement_pattern_2': 5, // Testing dynamic can take int
      };

      final result = Exercise.fromJson(jsonWithDynamic);

      expect(result.secondaryEquipment, 'Dumbbell');
      expect(result.movementPattern2, 5);
    });
  });
}