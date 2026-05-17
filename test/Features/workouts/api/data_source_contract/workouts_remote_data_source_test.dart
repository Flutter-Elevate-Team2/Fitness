import 'package:fitness_app/Features/workouts/api/api_client/workouts_api.dart';
import 'package:fitness_app/Features/workouts/api/data_source_imple/workouts_remote_data_source_imple.dart';
import 'package:fitness_app/Features/workouts/data/models/responses/muscle_groups_response.dart';
import 'package:fitness_app/Features/workouts/data/models/responses/muscles_by_group_response.dart';

import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

class MockWorkoutsApi extends Mock implements WorkoutsApi {}

void main() {
  late WorkoutsRemoteDataSourceImple dataSource;
  late MockWorkoutsApi mockApi;

  setUp(() {
    mockApi = MockWorkoutsApi();
    dataSource = WorkoutsRemoteDataSourceImple(mockApi);
  });

  group('WorkoutsRemoteDataSourceImple - Muscle Groups', () {
    test('getMuscleGroups should fetch and return MuscleGroupsResponse', () async {
      // arrange
      final response = MuscleGroupsResponse(message: 'success', musclesGroup: []);
      when(() => mockApi.getMuscleGroups()).thenAnswer((_) async => response);

      // act
      final result = await dataSource.getMuscleGroups();

      // assert
      expect(result, equals(response));
      verify(() => mockApi.getMuscleGroups()).called(1);
    });

    test('getMusclesByGroupId should fetch and return MusclesByGroupResponse', () async {
      // arrange
      final response = MusclesByGroupResponse(message: 'success', muscles: []);
      when(() => mockApi.getMusclesByGroupId(any())).thenAnswer((_) async => response);

      // act
      final result = await dataSource.getMusclesByGroupId('1');

      // assert
      expect(result, equals(response));
      verify(() => mockApi.getMusclesByGroupId('1')).called(1);
    });
  });
}
