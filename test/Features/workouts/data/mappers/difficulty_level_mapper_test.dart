import 'package:fitness_app/Features/workouts/data/mapper/difficulty_level_mapper.dart';
import 'package:fitness_app/Features/workouts/data/models/difficulty_level_response/difficulty_level.dart';
import 'package:fitness_app/Features/workouts/data/models/difficulty_level_response/difficulty_level_hive_model.dart';
import 'package:fitness_app/Features/workouts/domain/entities/difficulty_level_entity.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  // ================= DifficultyLevel → HiveModel =================
  group('DifficultyLevelRemoteMapper - toHiveModel()', () {
    test(
      'should correctly map a fully-populated DifficultyLevel to DifficultyLevelHiveModel',
      () {
        // ARRANGE
        final tDifficultyLevel = DifficultyLevel(
          id: '1',
          name: 'Beginner',
        );
        final tExpectedHiveModel = DifficultyLevelHiveModel(
          id: '1',
          name: 'Beginner',
        );

        // ACT
        final result = tDifficultyLevel.toHiveModel();

        // ASSERT
        expect(result.id, tExpectedHiveModel.id);
        expect(result.name, tExpectedHiveModel.name);
      },
    );

    test(
      'should use empty string fallback for id when it is null',
      () {
        // ARRANGE
        final tDifficultyLevel = DifficultyLevel(id: null, name: 'Advanced');

        // ACT
        final result = tDifficultyLevel.toHiveModel();

        // ASSERT
        expect(result.id, '');
        expect(result.name, 'Advanced');
      },
    );

    test(
      'should use "Unknown" fallback for name when it is null',
      () {
        // ARRANGE
        final tDifficultyLevel = DifficultyLevel(id: '2', name: null);

        // ACT
        final result = tDifficultyLevel.toHiveModel();

        // ASSERT
        expect(result.id, '2');
        expect(result.name, 'Unknown');
      },
    );

    test(
      'should use all fallback values when both id and name are null',
      () {
        // ARRANGE
        final tDifficultyLevel = DifficultyLevel(id: null, name: null);

        // ACT
        final result = tDifficultyLevel.toHiveModel();

        // ASSERT
        expect(result.id, '');
        expect(result.name, 'Unknown');
      },
    );
  });

  // ================= HiveModel → Entity =================
  group('DifficultyLevelHiveMapper - toEntity()', () {
    test(
      'should correctly map a DifficultyLevelHiveModel to a DifficultyLevelEntity',
      () {
        // ARRANGE
        final tHiveModel = DifficultyLevelHiveModel(
          id: '1',
          name: 'Beginner',
        );
        const tExpectedEntity = DifficultyLevelEntity(
          id: '1',
          name: 'Beginner',
        );

        // ACT
        final result = tHiveModel.toEntity();

        // ASSERT
        expect(result, tExpectedEntity);
      },
    );

    test(
      'should correctly map when id is an empty string',
      () {
        // ARRANGE
        final tHiveModel = DifficultyLevelHiveModel(id: '', name: 'Unknown');

        // ACT
        final result = tHiveModel.toEntity();

        // ASSERT
        expect(result.id, '');
        expect(result.name, 'Unknown');
      },
    );
  });
}
