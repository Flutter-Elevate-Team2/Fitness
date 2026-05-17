import 'package:fitness_app/Features/workouts/data/data_source_contract/workouts_local_data_source_contract.dart';
import 'package:fitness_app/Features/workouts/data/data_source_contract/workouts_remote_data_source_contract.dart';
import 'package:fitness_app/Features/workouts/data/models/difficulty_level_response/difficulty_level_response.dart';
import 'package:fitness_app/Features/workouts/data/models/exercises_response/exercises_response.dart';
import 'package:fitness_app/Features/workouts/data/models/random_muscles/response/random_muscles.dart';
import 'package:fitness_app/Features/workouts/data/models/responses/muscle_groups_response.dart';
import 'package:fitness_app/Features/workouts/data/models/responses/muscles_by_group_response.dart';
import 'package:fitness_app/Features/workouts/data/repo/workouts_repo_imple.dart';
 import 'package:fitness_app/core/base_response/base_response.dart';
import 'package:fitness_app/core/network/network_info.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

class MockRemoteDataSource extends Mock implements WorkoutsRemoteDataSourceContract {}
class MockLocalDataSource extends Mock implements WorkoutsLocalDataSourceContract {}
class MockNetworkInfo extends Mock implements NetworkInfo {}

void main() {
  late WorkoutsRepoImple repo;
  late MockRemoteDataSource mockRemote;
  late MockLocalDataSource mockLocal;
  late MockNetworkInfo mockNetwork;

  setUpAll(() {
    registerFallbackValue(const Duration(hours: 24));
    registerFallbackValue([]);
  });

  setUp(() {
    mockRemote = MockRemoteDataSource();
    mockLocal = MockLocalDataSource();
    mockNetwork = MockNetworkInfo();
    repo = WorkoutsRepoImple(mockRemote, mockLocal, mockNetwork);

    // 1. Stub NetworkInfo
    when(() => mockNetwork.isConnected).thenAnswer((_) async => true);

    // 2. Stub RemoteDataSource (Default empty responses)
    when(() => mockRemote.getDifficultyLevelsByPrimeMover(any()))
        .thenAnswer((_) async => DifficultyLevelResponse(difficultyLevels: []));
    when(() => mockRemote.getExercisesByMuscleDifficulty(any(), any(), any()))
        .thenAnswer((_) async => ExercisesResponse(exercises: []));
    when(() => mockRemote.getMuscleGroups())
        .thenAnswer((_) async => MuscleGroupsResponse(musclesGroup: []));
    when(() => mockRemote.getMusclesByGroupId(any()))
        .thenAnswer((_) async => MusclesByGroupResponse(muscles: []));
    when(() => mockRemote.getRandomMuscles())
        .thenAnswer((_) async => RandomMuscles(muscles: []));

    // 3. Stub LocalDataSource Void Methods
    when(() => mockLocal.cacheDifficultyLevels(any(), any())).thenAnswer((_) async => {});
    when(() => mockLocal.clearCachedExercises(any(), any())).thenAnswer((_) async => {});
    when(() => mockLocal.appendCachedExercises(any(), any(), any())).thenAnswer((_) async => {});
    when(() => mockLocal.saveMuscleGroups(any())).thenAnswer((_) async => {});
    when(() => mockLocal.saveMuscles(any(), any())).thenAnswer((_) async => {});
    when(() => mockLocal.cacheRandomMuscles(any())).thenAnswer((_) async => {});

    // 4. Stub LocalDataSource Getters
    when(() => mockLocal.getCachedDifficultyLevels(any())).thenAnswer((_) async => null);
    when(() => mockLocal.getCachedExercises(any(), any())).thenAnswer((_) async => null);
    when(() => mockLocal.getMuscleGroups()).thenAnswer((_) async => null);
    when(() => mockLocal.getMuscles(any())).thenAnswer((_) async => null);
    when(() => mockLocal.getCachedRandomMuscles()).thenAnswer((_) async => null);
    when(() => mockLocal.isCacheExpired(any(), any())).thenAnswer((_) async => true);
  });

  group('getDifficultyLevelsByPrimeMover', () {
    test('should return success response', () async {
      final result = await repo.getDifficultyLevelsByPrimeMover('1');
      expect(result, isA<SuccessResponse>());
    });
  });

  group('getExercisesByMuscleDifficulty', () {
    test('should return SuccessResponse from cache when valid (Page 1)', () async {
      when(() => mockLocal.isCacheExpired(any(), any())).thenAnswer((_) async => false);
      when(() => mockLocal.getCachedExercises(any(), any())).thenAnswer((_) async => []);

      final result = await repo.getExercisesByMuscleDifficulty('c', 'e', 1);

      expect(result, isA<SuccessResponse>());
    });

    test('should return error when offline and no cache', () async {
      when(() => mockNetwork.isConnected).thenAnswer((_) async => false);
      when(() => mockLocal.isCacheExpired(any(), any())).thenAnswer((_) async => true);
      when(() => mockLocal.getCachedExercises(any(), any())).thenAnswer((_) async => null);

      final result = await repo.getExercisesByMuscleDifficulty('c', 'e', 1);

      expect(result, isA<ErrorResponse>());
    });

    test('should return SuccessResponse when online (Remote fetch)', () async {
      when(() => mockNetwork.isConnected).thenAnswer((_) async => true);

      final result = await repo.getExercisesByMuscleDifficulty('c', 'e', 1);

      expect(result, isA<SuccessResponse>());
    });
  });

  group('Muscle Groups & Muscles', () {
    test('getMuscleGroups should return success', () async {
      final result = await repo.getMuscleGroups();
      expect(result, isA<SuccessResponse>());
    });

    test('getMusclesByGroupId should return success', () async {
      final result = await repo.getMusclesByGroupId('1');
      expect(result, isA<SuccessResponse>());
    });
  });

  group('getRandomMuscles', () {
    test('should return success response', () async {
      final result = await repo.getRandomMuscles();
      expect(result, isA<SuccessResponse>());
    });
  });

}
