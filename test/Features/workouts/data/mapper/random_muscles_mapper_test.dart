import 'package:fitness_app/Features/workouts/data/mapper/random_muscles_mapper.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:fitness_app/Features/workouts/data/models/random_muscle_model.dart';
import 'package:fitness_app/Features/workouts/data/models/random_muscles/response/random_muscles.dart';
import 'package:fitness_app/Features/workouts/domain/entities/random_muscles_entity.dart';

void main() {
  group('RandomMuscle Mappers Tests', () {

    group('RandomMuscleRemoteMapper (Muscles -> RandomMuscleModel)', () {
      test('should map Muscles model to RandomMuscleModel correctly', () {
        // Arrange
        final remoteModel = Muscles(
          id: '123',
          name: 'Biceps',
          image: 'image_url',
        );

        // Act
        final result = remoteModel.toHiveModel();

        // Assert
        expect(result, isA<RandomMuscleModel>());
        expect(result.id, '123');
        expect(result.name, 'Biceps');
        expect(result.image, 'image_url');
      });

      test('should return empty strings when Muscles fields are null', () {
        // Arrange
        final remoteModelWithNulls = Muscles(
          id: null,
          name: null,
          image: null,
        );

        // Act
        final result = remoteModelWithNulls.toHiveModel();

        // Assert
        expect(result.id, '');
        expect(result.name, '');
        expect(result.image, '');
      });
    });

    group('RandomMuscleHiveMapper (RandomMuscleModel -> RandomMusclesEntity)', () {
      test('should map RandomMuscleModel to RandomMusclesEntity correctly', () {
        // Arrange
        final hiveModel = RandomMuscleModel(
          id: '456',
          name: 'Triceps',
          image: 'triceps_url',
        );

        // Act
        final entity = hiveModel.toEntity();

        // Assert
        expect(entity, isA<RandomMusclesEntity>());
        expect(entity.id, '456');
        expect(entity.name, 'Triceps');
        expect(entity.image, 'triceps_url');
      });
    });
  });
}