import 'package:fitness_app/Features/home/data/mapper/mappers.dart';
import 'package:fitness_app/Features/home/data/models/levels_respones/level.dart';
import 'package:fitness_app/Features/home/data/models/levels_respones/levels_respones.dart';
import 'package:fitness_app/Features/workouts/domain/entities/difficulty_level_entity.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('Mappers Unit Tests', () {
    group('LevelModelMapper Test', () {
      test('should successfully map Level model to DifficultyLevelEntity', () {
        // Arrange
        final model = Level(id: '123', name: 'Beginner');

        // Act
        final entity = model.toEntity();

        // Assert
        expect(entity, isA<DifficultyLevelEntity>());
        expect(entity.id, model.id);
        expect(entity.name, model.name);
      });
    });

    group('DifficultyLevelModelMapper Test', () {
      test(
        'should successfully map LevelsResponse to a list of DifficultyLevelEntity',
        () {
          // Arrange
          final response = LevelsRespones(
            levels: [
              Level(id: '1', name: 'Easy'),
              Level(id: '2', name: 'Hard'),
            ],
          );

          // Act
          final entities = response.toEntity();

          // Assert
          expect(entities.length, 2);
          expect(entities[0].id, '1');
          expect(entities[1].name, 'Hard');
          expect(entities, isA<List<DifficultyLevelEntity>>());
        },
      );

      test('should return an empty list if levels is null', () {
        // Arrange
        final response = LevelsRespones(levels: null);

        // Act
        final entities = response.toEntity();

        // Assert
        expect(entities, isEmpty);
        expect(entities, isA<List<DifficultyLevelEntity>>());
      });
    });
  });
}
