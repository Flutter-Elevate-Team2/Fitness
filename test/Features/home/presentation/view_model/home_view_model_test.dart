import 'package:bloc_test/bloc_test.dart';
import 'package:fitness_app/Features/home/domain/entities/home_section.dart';
import 'package:fitness_app/Features/home/domain/use_cases/get_home_data_use_case.dart';
import 'package:fitness_app/Features/home/presentation/view_model/home_view_model.dart';
import 'package:fitness_app/Features/home/presentation/view_model/home_state.dart';
import 'package:fitness_app/Features/workouts/domain/entities/muscle_entity.dart';
import 'package:fitness_app/Features/workouts/domain/use_cases/get_muscles_by_group_id_use_case.dart';
import 'package:fitness_app/core/base_response/base_response.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

// Mocks
class MockGetHomeDataUseCase extends Mock implements GetHomeDataUseCase {}

class MockGetMusclesByGroupIdUseCase extends Mock
    implements GetMusclesByGroupIdUseCase {}

void main() {
  late HomeViewModel viewModel;
  late MockGetHomeDataUseCase mockGetHomeDataUseCase;
  late MockGetMusclesByGroupIdUseCase mockGetMusclesByGroupUC;

  setUp(() {
    mockGetHomeDataUseCase = MockGetHomeDataUseCase();
    mockGetMusclesByGroupUC = MockGetMusclesByGroupIdUseCase();
    viewModel = HomeViewModel(mockGetHomeDataUseCase, mockGetMusclesByGroupUC);
  });

  tearDown(() {
    viewModel.close();
  });

  group('HomeViewModel Tests', () {
    final mockSections = [
      SuccessResponse<HomeSection>(
        data: UpcomingWorkoutsSectionData(
          muscleGroups: [],
          currentGroupMuscles: [],
          selectedGroupId: '1',
        ),
      ),
    ];

    test('initial state should be HomeState', () {
      expect(viewModel.state, HomeState());
    });

    blocTest<HomeViewModel, HomeState>(
      'initHome should emit isLoading then homeData when successful',
      build: () {
        when(
          () => mockGetHomeDataUseCase.execute(),
        ).thenAnswer((_) => Stream.value(mockSections));
        return viewModel;
      },
      act: (vm) => vm.initHome(),
      expect: () => [
        HomeState(isLoading: true),
        HomeState(isLoading: false, homeData: mockSections),
      ],
    );

    blocTest<HomeViewModel, HomeState>(
      'initHome should emit errorMessage when stream returns error',
      build: () {
        when(
          () => mockGetHomeDataUseCase.execute(),
        ).thenAnswer((_) => Stream.error('Error occurred'));
        return viewModel;
      },
      act: (vm) => vm.initHome(),
      expect: () => [
        HomeState(isLoading: true),
        HomeState(isLoading: false, errorMessage: 'Error occurred'),
      ],
    );

    blocTest<HomeViewModel, HomeState>(
      'changeMuscleGroup should update homeData with new muscles when successful',
      build: () {
        final mockMuscles = [const MuscleEntity(id: 'm1', name: 'Biceps')];
        when(
          () => mockGetMusclesByGroupUC(any()),
        ).thenAnswer((_) async => SuccessResponse(data: mockMuscles));
        return viewModel;
      },
      seed: () => HomeState(homeData: mockSections),
      act: (vm) => vm.changeMuscleGroup('new_id'),
      verify: (_) {
        verify(() => mockGetMusclesByGroupUC('new_id')).called(1);
      },
      expect: () {
        return [
          isA<HomeState>().having(
            (s) => (s.homeData[0] as SuccessResponse).data.selectedGroupId,
            'id',
            'new_id',
          ),
          isA<HomeState>().having(
            (s) => (s.homeData[0] as SuccessResponse)
                .data
                .currentGroupMuscles
                .length,
            'muscles count',
            1,
          ),
        ];
      },
    );

    blocTest<HomeViewModel, HomeState>(
      'changeMuscleGroup should do nothing if UpcomingWorkoutsSectionData is not found',
      build: () {
        return viewModel;
      },
      seed: () =>
          HomeState(homeData: [const ErrorResponse(errorMessage: 'Empty')]),
      act: (vm) => vm.changeMuscleGroup('123'),
      expect: () => [],
    );
  });
}
