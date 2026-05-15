import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:fitness_app/core/base_response/base_response.dart';
import 'package:fitness_app/core/network/network_info.dart';
import 'package:fitness_app/core/errors/error_strings.dart';
import 'package:fitness_app/Features/workouts/data/repo/workouts_repo_impl.dart';
import 'package:fitness_app/Features/workouts/data/data_source_contract/workouts_remote_data_source_contract.dart';
import 'package:fitness_app/Features/workouts/data/data_source_contract/workouts_local_data_source_contract.dart';
import 'package:fitness_app/Features/workouts/data/models/responses/muscle_groups_response.dart';
import 'package:fitness_app/Features/workouts/data/models/muscle_group_model.dart';
import 'package:fitness_app/Features/workouts/domain/entities/muscle_group_entity.dart';

class MockRemoteDataSource extends Mock implements WorkoutsRemoteDataSourceContract {}
class MockLocalDataSource extends Mock implements WorkoutsLocalDataSourceContract {}
class MockNetworkInfo extends Mock implements NetworkInfo {}

void main() {
  late WorkoutsRepoImpl repository;
  late MockRemoteDataSource mockRemote;
  late MockLocalDataSource mockLocal;
  late MockNetworkInfo mockNetworkInfo;

  setUp(() {
    mockRemote = MockRemoteDataSource();
    mockLocal = MockLocalDataSource();
    mockNetworkInfo = MockNetworkInfo();
    repository = WorkoutsRepoImpl(mockRemote, mockLocal, mockNetworkInfo);
  });

  group('WorkoutsRepoImpl getMuscleGroups via CacheExecutionMixin', () {
    final tModel = MuscleGroupModel(id: '1', name: 'Chest');
    final tModels = [tModel];
    final tResponse = MuscleGroupsResponse(musclesGroup: tModels);

    test('1. Device Online + Cache Empty: Fetches from remote, saves to local, returns remote data', () async {
      when(() => mockNetworkInfo.isConnected).thenAnswer((_) async => true);
      when(() => mockLocal.getMuscleGroups()).thenAnswer((_) async => null); // Empty Cache
      when(() => mockRemote.getMuscleGroups()).thenAnswer((_) async => tResponse);
      when(() => mockLocal.saveMuscleGroups(any())).thenAnswer((_) async {});

      final result = await repository.getMuscleGroups();

      expect(result, isA<SuccessResponse<List<MuscleGroupEntity>>>());
      final data = (result as SuccessResponse<List<MuscleGroupEntity>>).data;
      expect(data.length, 1);
      expect(data.first.id, '1');

      verify(() => mockNetworkInfo.isConnected).called(1);
      verify(() => mockLocal.getMuscleGroups()).called(1);
      verify(() => mockRemote.getMuscleGroups()).called(1);
      verify(() => mockLocal.saveMuscleGroups(tModels)).called(1);
    });

    test('2. Device Online + Cache Has Data: Returns cache data instantly, then fetches from remote in the background', () async {
      when(() => mockNetworkInfo.isConnected).thenAnswer((_) async => true);
      when(() => mockLocal.getMuscleGroups()).thenAnswer((_) async => tModels); // Has Cache
      when(() => mockRemote.getMuscleGroups()).thenAnswer((_) async => tResponse);
      when(() => mockLocal.saveMuscleGroups(any())).thenAnswer((_) async {});

      final result = await repository.getMuscleGroups();

      expect(result, isA<SuccessResponse<List<MuscleGroupEntity>>>());
      final data = (result as SuccessResponse<List<MuscleGroupEntity>>).data;
      expect(data.length, 1);

      verify(() => mockLocal.getMuscleGroups()).called(1);

      // Allow the unawaited _syncWithServer to execute
      await Future.delayed(const Duration(milliseconds: 100));

      verify(() => mockRemote.getMuscleGroups()).called(1);
      verify(() => mockLocal.saveMuscleGroups(tModels)).called(1);
    });

    test('3. Device Offline + Cache Has Data: Returns cache data, no remote call', () async {
      when(() => mockNetworkInfo.isConnected).thenAnswer((_) async => false);
      when(() => mockLocal.getMuscleGroups()).thenAnswer((_) async => tModels); // Has Cache

      final result = await repository.getMuscleGroups();

      expect(result, isA<SuccessResponse<List<MuscleGroupEntity>>>());
      final data = (result as SuccessResponse<List<MuscleGroupEntity>>).data;
      expect(data.length, 1);

      verify(() => mockLocal.getMuscleGroups()).called(1);
      verifyNever(() => mockRemote.getMuscleGroups());
      verifyNever(() => mockLocal.saveMuscleGroups(any()));
    });

    test('4. Device Offline + Cache Empty: Returns ErrorResponse', () async {
      when(() => mockNetworkInfo.isConnected).thenAnswer((_) async => false);
      when(() => mockLocal.getMuscleGroups()).thenAnswer((_) async => null); // Empty Cache

      final result = await repository.getMuscleGroups();

      expect(result, isA<ErrorResponse<List<MuscleGroupEntity>>>());
      expect((result as ErrorResponse).errorMessage, ErrorStrings.emptyCacheError);

      verify(() => mockLocal.getMuscleGroups()).called(1);
      verifyNever(() => mockRemote.getMuscleGroups());
    });
  });
}
