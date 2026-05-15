import 'package:flutter_test/flutter_test.dart';
import 'package:fitness_app/Features/workouts/data/models/muscle_group_model.dart';
import 'package:fitness_app/Features/workouts/data/models/muscle_model.dart';
import 'package:fitness_app/Features/workouts/domain/entities/muscle_group_entity.dart';
import 'package:fitness_app/Features/workouts/domain/entities/muscle_entity.dart';
import 'package:fitness_app/Features/workouts/data/mapper/workouts_mappers.dart';

void main() {
  group('Workouts Mappers', () {
    test('should correctly map MuscleGroupModel to MuscleGroupEntity', () {
      final model = MuscleGroupModel(id: '1', name: 'Chest');
      final entity = model.toEntity();
      
      expect(entity, isA<MuscleGroupEntity>());
      expect(entity.id, '1');
      expect(entity.name, 'Chest');
    });

    test('should correctly map List<MuscleGroupModel> to List<MuscleGroupEntity>', () {
      final models = [MuscleGroupModel(id: '1', name: 'Chest')];
      final entities = models.toEntityList();
      
      expect(entities.length, 1);
      expect(entities.first.id, '1');
      expect(entities.first.name, 'Chest');
    });

    test('should correctly map MuscleModel to MuscleEntity', () {
      final model = MuscleModel(id: '1', name: 'Pectoralis', image: 'url');
      final entity = model.toEntity();
      
      expect(entity, isA<MuscleEntity>());
      expect(entity.id, '1');
      expect(entity.name, 'Pectoralis');
      expect(entity.image, 'url');
    });
    
    test('should correctly map List<MuscleModel> to List<MuscleEntity>', () {
      final models = [MuscleModel(id: '1', name: 'Pectoralis', image: 'url')];
      final entities = models.toEntityList();
      
      expect(entities.length, 1);
      expect(entities.first.id, '1');
    });

    test('should correctly handle null list mappings', () {
      List<MuscleGroupModel>? nullGroupModels;
      expect(nullGroupModels.toEntityList(), isEmpty);

      List<MuscleModel>? nullMuscleModels;
      expect(nullMuscleModels.toEntityList(), isEmpty);
    });
  });
}
