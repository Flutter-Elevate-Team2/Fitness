import 'package:fitness_app/Features/workouts/api/data_source_imple/workouts_local_data_source_imple.dart';
 import 'package:fitness_app/Features/workouts/data/models/difficulty_level_response/difficulty_level_hive_model.dart';
import 'package:fitness_app/Features/workouts/data/models/exercises_response/exercise_hive_model.dart';
import 'package:fitness_app/Features/workouts/data/models/muscle_group_model.dart';
import 'package:fitness_app/Features/workouts/data/models/muscle_model.dart';
import 'package:fitness_app/Features/workouts/data/models/random_muscle_model.dart';
import 'package:fitness_app/core/data_base/hive_database_service.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:hive_ce/hive.dart';
import 'package:mocktail/mocktail.dart';

class MockHiveDatabaseService extends Mock implements HiveDatabaseService {}
class MockBox<T> extends Mock implements Box<T> {}

void main() {
  late WorkoutsLocalDataSourceImple dataSource;
  late MockHiveDatabaseService mockHiveDb;
  late MockBox<List<dynamic>> mockListBox;
  late MockBox<dynamic> mockBox;

  setUp(() {
    mockHiveDb = MockHiveDatabaseService();
    mockListBox = MockBox<List<dynamic>>();
    mockBox = MockBox<dynamic>();
    dataSource = WorkoutsLocalDataSourceImple(mockHiveDb);

    registerFallbackValue([]);

    when(() => mockHiveDb.openBox<List<dynamic>>(any())).thenAnswer((_) async => mockListBox);
    when(() => mockHiveDb.openBox<dynamic>(any())).thenAnswer((_) async => mockBox);
    when(() => mockHiveDb.openBox(any())).thenAnswer((_) async => mockBox);
  });

  group('Difficulty Levels Tests', () {
    test('should cache difficulty levels and save timestamp', () async {
      when(() => mockListBox.put(any(), any())).thenAnswer((_) async => {});
      when(() => mockBox.put(any(), any())).thenAnswer((_) async => {});

      await dataSource.cacheDifficultyLevels('chest', []);

      verify(() => mockListBox.put('levels_chest', any())).called(1);
    });

    test('should return cached levels when they exist', () async {
      final levels = [DifficultyLevelHiveModel(id: '1', name: 'Easy')];
      when(() => mockListBox.get(any())).thenReturn(levels);

      final result = await dataSource.getCachedDifficultyLevels('chest');

      expect(result, isNotNull);
      expect(result!.length, 1);
    });

    test('should return null when levels do not exist', () async {
      when(() => mockListBox.get(any())).thenReturn(null);
      final result = await dataSource.getCachedDifficultyLevels('chest');
      expect(result, isNull);
    });
  });

  group('Exercises Tests', () {
    test('should return early if new exercises list is empty', () async {
      await dataSource.appendCachedExercises('chest', 'easy', []);
      verifyNever(() => mockListBox.put(any(), any()));
    });

    test('should merge new exercises with existing ones uniquely', () async {
      final existing = [ExerciseHiveModel(id: '1', title: 'Ex 1', description: '', sets: 1, reps: 1, thumbnailUrl: '')];
      final newData = [
        ExerciseHiveModel(id: '1', title: 'Ex 1',  description: '', sets: 1, reps: 1, thumbnailUrl: ''), // Duplicate
        ExerciseHiveModel(id: '2', title: 'Ex 2', description: '', sets: 1, reps: 1, thumbnailUrl: ''), // New
      ];

      when(() => mockListBox.get(any())).thenReturn(existing);
      when(() => mockListBox.put(any(), any())).thenAnswer((_) async => {});
      when(() => mockBox.put(any(), any())).thenAnswer((_) async => {});

      await dataSource.appendCachedExercises('chest', 'easy', newData);

      verify(() => mockListBox.put(any(), any(that: isA<List>().having((l) => l.length, 'length', 2)))).called(1);
    });

    test('should clear cached exercises and its metadata', () async {
      when(() => mockListBox.delete(any())).thenAnswer((_) async => {});
      when(() => mockBox.delete(any())).thenAnswer((_) async => {});

      await dataSource.clearCachedExercises('chest', 'easy');

      verify(() => mockListBox.delete(any())).called(1);
      verify(() => mockBox.delete(any())).called(1);
    });

    test('should return cached exercises or null if empty', () async {
      when(() => mockListBox.get(any())).thenReturn(null);
      expect(await dataSource.getCachedExercises('c', 'e'), isNull);

      final data = [ExerciseHiveModel(id: '1', title: 'ex', description: '', sets: 1, reps: 1, thumbnailUrl: '')];
      when(() => mockListBox.get(any())).thenReturn(data);
      expect((await dataSource.getCachedExercises('c', 'e'))!.length, 1);
    });
  });

  group('Muscle Groups and Muscles Tests', () {
    test('should save and get muscle groups', () async {
      final groups = [MuscleGroupModel(id: '1', name: 'Upper Body')];
      when(() => mockBox.put(any(), any())).thenAnswer((_) async => {});
      when(() => mockBox.get(any())).thenReturn(groups);

      await dataSource.saveMuscleGroups(groups);
      final result = await dataSource.getMuscleGroups();

      expect(result!.length, 1);
      verify(() => mockBox.put('muscle_groups', groups)).called(1);
    });

    test('should return null if muscle groups not found', () async {
      when(() => mockBox.get(any())).thenReturn(null);
      expect(await dataSource.getMuscleGroups(), isNull);
    });

    test('should save and get muscles for a group', () async {
      final muscles = [MuscleModel(id: '1', name: 'Biceps')];
      when(() => mockBox.put(any(), any())).thenAnswer((_) async => {});
      when(() => mockBox.get(any())).thenReturn(muscles);

      await dataSource.saveMuscles('g1', muscles);
      final result = await dataSource.getMuscles('g1');

      expect(result!.first.name, 'Biceps');
      verify(() => mockBox.put('muscles_g1', muscles)).called(1);
    });
  });

  group('Random Muscles Tests', () {
    test('should cache and get random muscles', () async {
      final muscles = [RandomMuscleModel(id: '1', name: 'Triceps', image: '')];
      when(() => mockListBox.put(any(), any())).thenAnswer((_) async => {});
      when(() => mockListBox.get(any())).thenReturn(muscles);
      when(() => mockBox.put(any(), any())).thenAnswer((_) async => {});

      await dataSource.cacheRandomMuscles(muscles);
      final result = await dataSource.getCachedRandomMuscles();

      expect(result!.length, 1);
      verify(() => mockListBox.put('random_muscles_list', muscles)).called(1);
    });

    test('should return null if random muscles not cached', () async {
      when(() => mockListBox.get(any())).thenReturn(null);
      expect(await dataSource.getCachedRandomMuscles(), isNull);
    });
  });

  group('Cache Expiry Tests', () {
    test('should return true if no timestamp found', () async {
      when(() => mockBox.get(any())).thenReturn(null);
      final result = await dataSource.isCacheExpired('key', Duration(days: 1));
      expect(result, isTrue);
    });
  });
}