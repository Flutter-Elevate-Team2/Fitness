import 'package:fitness_app/Features/workouts/data/data_source_contract/workouts_local_data_source_contract.dart';
import 'package:fitness_app/Features/workouts/data/data_source_contract/workouts_remote_data_source_contract.dart';
import 'package:fitness_app/Features/workouts/data/repo/workouts_repo_imple.dart';
import 'package:fitness_app/Features/workouts/data/models/difficulty_level_response/difficulty_level.dart';
import 'package:fitness_app/Features/workouts/data/models/difficulty_level_response/difficulty_level_response.dart';
import 'package:fitness_app/Features/workouts/data/models/exercises_response/exercise.dart';
import 'package:fitness_app/Features/workouts/data/models/exercises_response/exercise_hive_model.dart';
import 'package:fitness_app/Features/workouts/data/models/exercises_response/exercises_response.dart';
import 'package:fitness_app/Features/workouts/domain/entities/difficulty_level_entity.dart';
import 'package:fitness_app/Features/workouts/domain/entities/exercise_entity.dart';
import 'package:fitness_app/core/base_response/base_response.dart';
import 'package:fitness_app/core/network/network_info.dart';

import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

import 'workouts_repo_impl_test.mocks.dart';

@GenerateMocks([
  WorkoutsRemoteDataSourceContract,
  WorkoutsLocalDataSourceContract,
  NetworkInfo,
])
void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  late WorkoutsRepoImple repo;
  late MockWorkoutsRemoteDataSourceContract mockRemote;
  late MockWorkoutsLocalDataSourceContract mockLocal;
  late MockNetworkInfo mockNetworkInfo;

  setUp(() {
    mockRemote = MockWorkoutsRemoteDataSourceContract();
    mockLocal = MockWorkoutsLocalDataSourceContract();
    mockNetworkInfo = MockNetworkInfo();
    repo = WorkoutsRepoImple(mockRemote, mockLocal, mockNetworkInfo);
  });

  // ================= getExercisesByMuscleDifficulty =================
  group('getExercisesByMuscleDifficulty', () {
    const tPrimeMoverMuscleId = 'muscle_123';
    const tDifficultyLevelId = 'level_1';

    final tExercisesResponse = ExercisesResponse(
      message: 'Success',
      totalExercises: 1,
      totalPages: 1,
      currentPage: 1,
      exercises: [
        Exercise(
          id: 'ex_1',
          exercise: 'Bench Press',
          primeMoverMuscle: 'Chest',
          primaryEquipment: 'Barbell',
        ),
      ],
    );

    final tCachedExercises = [
      ExerciseHiveModel(
        id: 'ex_cached',
        title: 'Cached • Exercise',
        description: 'Cached Bench Press',
        sets: 3,
        reps: 15,
        thumbnailUrl: '',
        videoUrl: null,
      ),
    ];

    group('page 1 – cache first strategy', () {
      test(
        'returns cached data when cache is valid and not expired',
        () async {
          // arrange
          when(mockLocal.isCacheExpired(any, any))
              .thenAnswer((_) async => false);
          when(mockLocal.getCachedExercises(any, any))
              .thenAnswer((_) async => tCachedExercises);

          // act
          final result = await repo.getExercisesByMuscleDifficulty(
            tPrimeMoverMuscleId,
            tDifficultyLevelId,
            1,
          );

          // assert
          expect(result, isA<SuccessResponse<List<ExerciseEntity>>>());
          verifyNever(mockRemote.getExercisesByMuscleDifficulty(any, any, any));
        },
      );

      test(
        'fetches from remote and caches when cache is expired',
        () async {
          // arrange
          when(mockLocal.isCacheExpired(any, any))
              .thenAnswer((_) async => true);
          when(mockLocal.getCachedExercises(any, any))
              .thenAnswer((_) async => null);
          when(mockLocal.clearCachedExercises(any, any))
              .thenAnswer((_) async {});
          when(mockNetworkInfo.isConnected)
              .thenAnswer((_) async => true);
          when(mockRemote.getExercisesByMuscleDifficulty(any, any, any))
              .thenAnswer((_) async => tExercisesResponse);
          when(mockLocal.appendCachedExercises(any, any, any))
              .thenAnswer((_) async {});

          // act
          final result = await repo.getExercisesByMuscleDifficulty(
            tPrimeMoverMuscleId,
            tDifficultyLevelId,
            1,
          );

          // assert
          expect(result, isA<SuccessResponse<List<ExerciseEntity>>>());
          verify(mockRemote.getExercisesByMuscleDifficulty(
            tPrimeMoverMuscleId,
            tDifficultyLevelId,
            1,
          )).called(1);
        },
      );
    });

    group('offline behavior', () {
      test(
        'returns cached data as fallback when offline and cache exists',
        () async {
          // arrange – page > 1 bypasses page-1 cache check
          when(mockNetworkInfo.isConnected)
              .thenAnswer((_) async => false);
          when(mockLocal.getCachedExercises(any, any))
              .thenAnswer((_) async => tCachedExercises);

          // act
          final result = await repo.getExercisesByMuscleDifficulty(
            tPrimeMoverMuscleId,
            tDifficultyLevelId,
            2,
          );

          // assert
          expect(result, isA<SuccessResponse<List<ExerciseEntity>>>());
          verifyNever(mockRemote.getExercisesByMuscleDifficulty(any, any, any));
        },
      );

      test(
        'returns ErrorResponse when offline and cache is empty',
        () async {
          // arrange
          when(mockNetworkInfo.isConnected)
              .thenAnswer((_) async => false);
          when(mockLocal.getCachedExercises(any, any))
              .thenAnswer((_) async => null);

          // act
          final result = await repo.getExercisesByMuscleDifficulty(
            tPrimeMoverMuscleId,
            tDifficultyLevelId,
            2,
          );

          // assert
          expect(result, isA<ErrorResponse>());
        },
      );
    });

    group('remote failure fallback', () {
      test(
        'returns stale cache when API call throws and cache exists',
        () async {
          // arrange
          when(mockNetworkInfo.isConnected)
              .thenAnswer((_) async => true);
          when(mockRemote.getExercisesByMuscleDifficulty(any, any, any))
              .thenThrow(Exception('API Error'));
          when(mockLocal.getCachedExercises(any, any))
              .thenAnswer((_) async => tCachedExercises);

          // act
          final result = await repo.getExercisesByMuscleDifficulty(
            tPrimeMoverMuscleId,
            tDifficultyLevelId,
            2,
          );

          // assert
          expect(result, isA<SuccessResponse<List<ExerciseEntity>>>());
        },
      );

      test(
        'returns ErrorResponse when API call throws and no cache',
        () async {
          // arrange
          when(mockNetworkInfo.isConnected)
              .thenAnswer((_) async => true);
          when(mockRemote.getExercisesByMuscleDifficulty(any, any, any))
              .thenThrow(Exception('API Error'));
          when(mockLocal.getCachedExercises(any, any))
              .thenAnswer((_) async => null);

          // act
          final result = await repo.getExercisesByMuscleDifficulty(
            tPrimeMoverMuscleId,
            tDifficultyLevelId,
            2,
          );

          // assert
          expect(result, isA<ErrorResponse>());
        },
      );
    });
  });
}
