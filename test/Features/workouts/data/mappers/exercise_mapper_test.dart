import 'package:fitness_app/Features/workouts/data/mapper/exercise_mapper.dart';
import 'package:fitness_app/Features/workouts/data/models/exercises_response/exercise.dart';
import 'package:fitness_app/Features/workouts/data/models/exercises_response/exercise_hive_model.dart';
import 'package:fitness_app/Features/workouts/domain/entities/exercise_entity.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  // ================= Exercise → HiveModel =================
  group('ExerciseRemoteMapper - toHiveModel()', () {
    test(
      'should correctly map a fully-populated Exercise to ExerciseHiveModel',
      () {
        // ARRANGE
        final tExercise = Exercise(
          id: 'ex_1',
          exercise: 'Bench Press',
          primeMoverMuscle: 'Chest',
          primaryEquipment: 'Barbell',
          shortYoutubeDemonstrationLink: 'https://www.youtube.com/watch?v=abc123',
          inDepthYoutubeExplanationLink: 'https://www.youtube.com/watch?v=xyz789',
        );

        // ACT
        final result = tExercise.toHiveModel();

        // ASSERT
        expect(result.id, 'ex_1');
        expect(result.title, 'Chest • Barbell');
        expect(result.description, 'Bench Press');
        expect(result.sets, 3);
        expect(result.reps, 15);
        expect(result.videoUrl, 'https://www.youtube.com/watch?v=xyz789');
      },
    );

    test(
      'should use empty string fallback for id when it is null',
      () {
        // ARRANGE
        final tExercise = Exercise(id: null, exercise: 'Push Up');

        // ACT
        final result = tExercise.toHiveModel();

        // ASSERT
        expect(result.id, '');
      },
    );

    test(
      'should use "Unknown Exercise" fallback for description when exercise is null',
      () {
        // ARRANGE
        final tExercise = Exercise(id: '1', exercise: null);

        // ACT
        final result = tExercise.toHiveModel();

        // ASSERT
        expect(result.description, 'Unknown Exercise');
      },
    );

    test(
      'should build title from primeMoverMuscle and primaryEquipment, filtering nulls',
      () {
        // ARRANGE — only primeMoverMuscle
        final tExercise1 = Exercise(
          id: '1',
          exercise: 'Exercise',
          primeMoverMuscle: 'Chest',
          primaryEquipment: null,
        );

        // only primaryEquipment
        final tExercise2 = Exercise(
          id: '2',
          exercise: 'Exercise',
          primeMoverMuscle: null,
          primaryEquipment: 'Barbell',
        );

        // both null
        final tExercise3 = Exercise(
          id: '3',
          exercise: 'Exercise',
          primeMoverMuscle: null,
          primaryEquipment: null,
        );

        // ACT
        final result1 = tExercise1.toHiveModel();
        final result2 = tExercise2.toHiveModel();
        final result3 = tExercise3.toHiveModel();

        // ASSERT
        expect(result1.title, 'Chest');
        expect(result2.title, 'Barbell');
        expect(result3.title, '');
      },
    );

    test(
      'should filter out empty strings from title components',
      () {
        // ARRANGE
        final tExercise = Exercise(
          id: '1',
          exercise: 'Exercise',
          primeMoverMuscle: '',
          primaryEquipment: 'Barbell',
        );

        // ACT
        final result = tExercise.toHiveModel();

        // ASSERT
        expect(result.title, 'Barbell');
      },
    );

    test(
      'should use shortYoutubeDemonstrationLink when inDepthYoutubeExplanationLink is null',
      () {
        // ARRANGE
        final tExercise = Exercise(
          id: '1',
          exercise: 'Push Up',
          shortYoutubeDemonstrationLink: 'https://www.youtube.com/watch?v=short123',
          inDepthYoutubeExplanationLink: null,
        );

        // ACT
        final result = tExercise.toHiveModel();

        // ASSERT
        expect(result.videoUrl, 'https://www.youtube.com/watch?v=short123');
      },
    );

    test(
      'should set videoUrl to null when both youtube links are null',
      () {
        // ARRANGE
        final tExercise = Exercise(
          id: '1',
          exercise: 'Push Up',
          shortYoutubeDemonstrationLink: null,
          inDepthYoutubeExplanationLink: null,
        );

        // ACT
        final result = tExercise.toHiveModel();

        // ASSERT
        expect(result.videoUrl, isNull);
      },
    );

    test(
      'should always set sets to 3 and reps to 15',
      () {
        // ARRANGE
        final tExercise = Exercise(id: '1', exercise: 'Exercise');

        // ACT
        final result = tExercise.toHiveModel();

        // ASSERT
        expect(result.sets, 3);
        expect(result.reps, 15);
      },
    );
  });

  // ================= HiveModel → Entity =================
  group('ExerciseHiveListMapper - toEntity()', () {
    test(
      'should correctly map an ExerciseHiveModel to an ExerciseEntity',
      () {
        // ARRANGE
        final tHiveModel = ExerciseHiveModel(
          id: 'ex_1',
          title: 'Chest • Barbell',
          description: 'Bench Press',
          sets: 3,
          reps: 15,
          thumbnailUrl: 'https://img.youtube.com/vi/abc123/hqdefault.jpg',
          videoUrl: 'https://www.youtube.com/watch?v=abc123',
        );
        const tExpectedEntity = ExerciseEntity(
          id: 'ex_1',
          title: 'Chest • Barbell',
          description: 'Bench Press',
          sets: 3,
          reps: 15,
          thumbnailUrl: 'https://img.youtube.com/vi/abc123/hqdefault.jpg',
          videoUrl: 'https://www.youtube.com/watch?v=abc123',
        );

        // ACT
        final result = tHiveModel.toEntity();

        // ASSERT
        expect(result, tExpectedEntity);
      },
    );

    test(
      'should correctly map when videoUrl is null',
      () {
        // ARRANGE
        final tHiveModel = ExerciseHiveModel(
          id: 'ex_1',
          title: 'Chest',
          description: 'Push Up',
          sets: 3,
          reps: 15,
          thumbnailUrl: '',
          videoUrl: null,
        );

        // ACT
        final result = tHiveModel.toEntity();

        // ASSERT
        expect(result.videoUrl, isNull);
        expect(result.id, 'ex_1');
        expect(result.title, 'Chest');
        expect(result.description, 'Push Up');
        expect(result.sets, 3);
        expect(result.reps, 15);
        expect(result.thumbnailUrl, '');
      },
    );
  });
}
