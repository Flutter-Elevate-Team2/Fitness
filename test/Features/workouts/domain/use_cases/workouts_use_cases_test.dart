import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:fitness_app/core/base_response/base_response.dart';
import 'package:fitness_app/Features/workouts/domain/repo/workouts_repo_contract.dart';
import 'package:fitness_app/Features/workouts/domain/use_cases/get_muscle_groups_use_case.dart';
import 'package:fitness_app/Features/workouts/domain/use_cases/get_muscles_by_group_id_use_case.dart';
import 'package:fitness_app/Features/workouts/domain/entities/muscle_group_entity.dart';
import 'package:fitness_app/Features/workouts/domain/entities/muscle_entity.dart';

class MockWorkoutsRepo extends Mock implements WorkoutsRepoContract {}

void main() {
  late MockWorkoutsRepo mockRepo;
  late GetMuscleGroupsUseCase getMuscleGroupsUseCase;
  late GetMusclesByGroupIdUseCase getMusclesByGroupIdUseCase;

  setUp(() {
    mockRepo = MockWorkoutsRepo();
    getMuscleGroupsUseCase = GetMuscleGroupsUseCase(mockRepo);
    getMusclesByGroupIdUseCase = GetMusclesByGroupIdUseCase(mockRepo);
  });

  group('Workouts Use Cases', () {
    test('GetMuscleGroupsUseCase should successfully call getMuscleGroups from repository', () async {
      const expectedResponse = SuccessResponse<List<MuscleGroupEntity>>(data: []);
      when(() => mockRepo.getMuscleGroups()).thenAnswer((_) async => expectedResponse);

      final result = await getMuscleGroupsUseCase();

      expect(result, expectedResponse);
      verify(() => mockRepo.getMuscleGroups()).called(1);
    });

    test('GetMusclesByGroupIdUseCase should successfully call getMusclesByGroupId from repository', () async {
      const expectedResponse = SuccessResponse<List<MuscleEntity>>(data: []);
      final id = '123';
      when(() => mockRepo.getMusclesByGroupId(id)).thenAnswer((_) async => expectedResponse);

      final result = await getMusclesByGroupIdUseCase(id);

      expect(result, expectedResponse);
      verify(() => mockRepo.getMusclesByGroupId(id)).called(1);
    });
  });
}
