import 'package:fitness_app/Features/workouts/api/data_source_imple/workouts_local_data_source_imple.dart';
import 'package:fitness_app/Features/workouts/data/models/muscle_group_model.dart';
import 'package:fitness_app/Features/workouts/data/models/muscle_model.dart';
import 'package:fitness_app/core/data_base/hive_database_service.dart';

import 'package:flutter_test/flutter_test.dart';
import 'package:hive_ce/hive.dart';
import 'package:mocktail/mocktail.dart';

class MockHiveDatabaseService extends Mock implements HiveDatabaseService {}

class MockBox extends Mock implements Box {}

void main() {
  late WorkoutsLocalDataSourceImple dataSource;
  late MockHiveDatabaseService mockHiveDb;
  late MockBox mockBox;

  setUp(() {
    mockHiveDb = MockHiveDatabaseService();
    mockBox = MockBox();
    dataSource = WorkoutsLocalDataSourceImple(mockHiveDb);
  });

  group('WorkoutsLocalDataSourceImple - Muscle Groups', () {
    test('saveMuscleGroups should put data into Box with the correct key', () async {
      // arrange
      final tGroups = [MuscleGroupModel(id: '1', name: 'Chest')];
      when(() => mockHiveDb.openBox(any())).thenAnswer((_) async => mockBox);
      when(() => mockBox.put(any(), any())).thenAnswer((_) async {});

      // act
      await dataSource.saveMuscleGroups(tGroups);

      // assert
      verify(() => mockBox.put('muscle_groups', tGroups)).called(1);
    });

    test('getMuscleGroups should return null when no data cached', () async {
      // arrange
      when(() => mockHiveDb.openBox(any())).thenAnswer((_) async => mockBox);
      when(() => mockBox.get(any())).thenReturn(null);

      // act
      final result = await dataSource.getMuscleGroups();

      // assert
      expect(result, isNull);
    });

    test('getMuscleGroups should return cached data when available', () async {
      // arrange
      final tGroups = [MuscleGroupModel(id: '1', name: 'Chest')];
      when(() => mockHiveDb.openBox(any())).thenAnswer((_) async => mockBox);
      when(() => mockBox.get('muscle_groups')).thenReturn(tGroups);

      // act
      final result = await dataSource.getMuscleGroups();

      // assert
      expect(result, isNotNull);
      expect(result!.length, 1);
      expect(result.first.id, '1');
    });

    test('saveMuscles should put sub-muscles with formatted groupId key', () async {
      // arrange
      final tMuscles = [MuscleModel(id: '10', name: 'Pectoralis Major')];
      when(() => mockHiveDb.openBox(any())).thenAnswer((_) async => mockBox);
      when(() => mockBox.put(any(), any())).thenAnswer((_) async {});

      // act
      await dataSource.saveMuscles('1', tMuscles);

      // assert
      verify(() => mockBox.put('muscles_1', tMuscles)).called(1);
    });

    test('getMuscles should return null when no sub-muscles cached', () async {
      // arrange
      when(() => mockHiveDb.openBox(any())).thenAnswer((_) async => mockBox);
      when(() => mockBox.get(any())).thenReturn(null);

      // act
      final result = await dataSource.getMuscles('1');

      // assert
      expect(result, isNull);
    });

    test('getMuscles should return cached sub-muscles when available', () async {
      // arrange
      final tMuscles = [MuscleModel(id: '10', name: 'Pectoralis Major')];
      when(() => mockHiveDb.openBox(any())).thenAnswer((_) async => mockBox);
      when(() => mockBox.get('muscles_1')).thenReturn(tMuscles);

      // act
      final result = await dataSource.getMuscles('1');

      // assert
      expect(result, isNotNull);
      expect(result!.length, 1);
      expect(result.first.name, 'Pectoralis Major');
    });
  });
}
