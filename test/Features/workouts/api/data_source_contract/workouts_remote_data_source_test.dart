import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:fitness_app/Features/workouts/api/api_client/workouts_api.dart';
import 'package:fitness_app/Features/workouts/api/data_sources/workouts_remote_data_source_impl.dart';
import 'package:fitness_app/Features/workouts/data/models/responses/muscle_groups_response.dart';
import 'package:fitness_app/Features/workouts/data/models/responses/muscles_by_group_response.dart';

class MockWorkoutsApi extends Mock implements WorkoutsApi {}

void main() {
  late WorkoutsRemoteDataSourceImpl dataSource;
  late MockWorkoutsApi mockApi;

  setUp(() {
    mockApi = MockWorkoutsApi();
    dataSource = WorkoutsRemoteDataSourceImpl(mockApi);
  });

  group('WorkoutsRemoteDataSourceImpl', () {
    test('getMuscleGroups should fetch and return MuscleGroupsResponse', () async {
      final response = MuscleGroupsResponse(message: 'success', musclesGroup: []);
      when(() => mockApi.getMuscleGroups()).thenAnswer((_) async => response);

      final result = await dataSource.getMuscleGroups();

      expect(result, equals(response));
      verify(() => mockApi.getMuscleGroups()).called(1);
    });

    test('getMusclesByGroupId should fetch and return MusclesByGroupResponse', () async {
      final response = MusclesByGroupResponse(message: 'success', muscles: []);
      when(() => mockApi.getMusclesByGroupId(any())).thenAnswer((_) async => response);

      final result = await dataSource.getMusclesByGroupId('1');

      expect(result, equals(response));
      verify(() => mockApi.getMusclesByGroupId('1')).called(1);
    });
  });
}
