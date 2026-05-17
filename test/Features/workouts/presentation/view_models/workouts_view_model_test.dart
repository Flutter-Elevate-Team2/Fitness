import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:fitness_app/core/base_response/base_response.dart';
import 'package:fitness_app/Features/workouts/domain/entities/muscle_group_entity.dart';
import 'package:fitness_app/Features/workouts/domain/entities/muscle_entity.dart';
import 'package:fitness_app/Features/workouts/domain/use_cases/get_muscle_groups_use_case.dart';
import 'package:fitness_app/Features/workouts/domain/use_cases/get_muscles_by_group_id_use_case.dart';
import 'package:fitness_app/Features/workouts/presentation/view_models/workouts_events.dart';
import 'package:fitness_app/Features/workouts/presentation/view_models/workouts_states.dart';
import 'package:fitness_app/Features/workouts/presentation/view_models/workouts_view_model.dart';

class MockGetMuscleGroupsUseCase extends Mock implements GetMuscleGroupsUseCase {}
class MockGetMusclesByGroupIdUseCase extends Mock implements GetMusclesByGroupIdUseCase {}

void main() {
  late WorkoutsViewModel viewModel;
  late MockGetMuscleGroupsUseCase mockGetMuscleGroupsUseCase;
  late MockGetMusclesByGroupIdUseCase mockGetMusclesByGroupIdUseCase;

  setUp(() {
    mockGetMuscleGroupsUseCase = MockGetMuscleGroupsUseCase();
    mockGetMusclesByGroupIdUseCase = MockGetMusclesByGroupIdUseCase();
    viewModel = WorkoutsViewModel(
      mockGetMuscleGroupsUseCase,
      mockGetMusclesByGroupIdUseCase,
    );
  });

  tearDown(() {
    viewModel.close();
  });

  group('WorkoutsViewModel', () {
    final tMuscleGroups = [const MuscleGroupEntity(id: '1', name: 'Chest')];
    final tMuscles = [const MuscleEntity(id: '1', name: 'Pectoralis', image: 'url')];
    const tError = 'Something went wrong';

    blocTest<WorkoutsViewModel, WorkoutsStates>(
      'emits [Loading, Success] when FetchMuscleGroupsEvent succeeds',
      build: () {
        when(() => mockGetMuscleGroupsUseCase()).thenAnswer(
          (_) async => SuccessResponse(data: tMuscleGroups),
        );
        return viewModel;
      },
      act: (bloc) => bloc.doIntent(FetchMuscleGroupsEvent()),
      expect: () => [
        isA<WorkoutsStates>().having((s) => s.muscleGroupsState.isLoading, 'isLoading', true),
        isA<WorkoutsStates>()
            .having((s) => s.muscleGroupsState.isLoading, 'isLoading', false)
            .having((s) => s.muscleGroupsState.data, 'data', tMuscleGroups),
      ],
      verify: (_) {
        verify(() => mockGetMuscleGroupsUseCase()).called(1);
      },
    );

    blocTest<WorkoutsViewModel, WorkoutsStates>(
      'emits [Loading, Error] when FetchMuscleGroupsEvent fails',
      build: () {
        when(() => mockGetMuscleGroupsUseCase()).thenAnswer(
          (_) async => const ErrorResponse(errorMessage: tError),
        );
        return viewModel;
      },
      act: (bloc) => bloc.doIntent(FetchMuscleGroupsEvent()),
      expect: () => [
        isA<WorkoutsStates>().having((s) => s.muscleGroupsState.isLoading, 'isLoading', true),
        isA<WorkoutsStates>()
            .having((s) => s.muscleGroupsState.isLoading, 'isLoading', false)
            .having((s) => s.muscleGroupsState.errorMessage, 'errorMessage', tError),
      ],
      verify: (_) {
        verify(() => mockGetMuscleGroupsUseCase()).called(1);
      },
    );

    blocTest<WorkoutsViewModel, WorkoutsStates>(
      'emits [Loading, Success] when FetchMusclesByGroupEvent succeeds',
      build: () {
        when(() => mockGetMusclesByGroupIdUseCase('1')).thenAnswer(
          (_) async => SuccessResponse(data: tMuscles),
        );
        return viewModel;
      },
      act: (bloc) => bloc.doIntent(FetchMusclesByGroupEvent('1')),
      expect: () => [
        isA<WorkoutsStates>().having((s) => s.musclesState.isLoading, 'isLoading', true),
        isA<WorkoutsStates>()
            .having((s) => s.musclesState.isLoading, 'isLoading', false)
            .having((s) => s.musclesState.data, 'data', tMuscles),
      ],
      verify: (_) {
        verify(() => mockGetMusclesByGroupIdUseCase('1')).called(1);
      },
    );

    blocTest<WorkoutsViewModel, WorkoutsStates>(
      'emits [Loading, Error] when FetchMusclesByGroupEvent fails',
      build: () {
        when(() => mockGetMusclesByGroupIdUseCase('1')).thenAnswer(
          (_) async => const ErrorResponse(errorMessage: tError),
        );
        return viewModel;
      },
      act: (bloc) => bloc.doIntent(FetchMusclesByGroupEvent('1')),
      expect: () => [
        isA<WorkoutsStates>().having((s) => s.musclesState.isLoading, 'isLoading', true),
        isA<WorkoutsStates>()
            .having((s) => s.musclesState.isLoading, 'isLoading', false)
            .having((s) => s.musclesState.errorMessage, 'errorMessage', tError),
      ],
      verify: (_) {
        verify(() => mockGetMusclesByGroupIdUseCase('1')).called(1);
      },
    );
  });
}
