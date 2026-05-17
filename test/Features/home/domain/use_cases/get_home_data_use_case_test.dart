import 'package:fitness_app/Features/food/domain/use_cases/categories_use_case.dart';
import 'package:fitness_app/Features/home/domain/entities/home_section.dart';
import 'package:fitness_app/Features/home/domain/entities/popular_tranning_entity.dart';
import 'package:fitness_app/Features/home/domain/use_cases/get_home_data_use_case.dart';
import 'package:fitness_app/Features/home/domain/use_cases/get_popular_workouts_use_case.dart';
import 'package:fitness_app/Features/workouts/domain/entities/muscle_group_entity.dart';
import 'package:fitness_app/Features/workouts/domain/use_cases/get_muscle_groups_use_case.dart';
import 'package:fitness_app/Features/workouts/domain/use_cases/get_muscles_by_group_id_use_case.dart';
import 'package:fitness_app/Features/workouts/domain/use_cases/get_random_muscles_use_case.dart';
import 'package:fitness_app/core/base_response/base_response.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

// Mocks
class MockGetCategoriesUseCase extends Mock implements GetCategoriesUseCase {}

class MockGetPopularWorkoutsUseCase extends Mock
    implements GetPopularWorkoutsUseCase {}

class MockGetRandomMusclesUseCase extends Mock
    implements GetRandomMusclesUseCase {}

class MockGetMuscleGroupsUseCase extends Mock
    implements GetMuscleGroupsUseCase {}

class MockGetMusclesByGroupIdUseCase extends Mock
    implements GetMusclesByGroupIdUseCase {}

void main() {
  late GetHomeDataUseCase useCase;
  late MockGetCategoriesUseCase mockCategoriesUC;
  late MockGetPopularWorkoutsUseCase mockWorkoutsUC;
  late MockGetRandomMusclesUseCase mockRandomUC;
  late MockGetMuscleGroupsUseCase mockMuscleGroupsUC;
  late MockGetMusclesByGroupIdUseCase mockMusclesByGroupUC;

  setUp(() {
    mockCategoriesUC = MockGetCategoriesUseCase();
    mockWorkoutsUC = MockGetPopularWorkoutsUseCase();
    mockRandomUC = MockGetRandomMusclesUseCase();
    mockMuscleGroupsUC = MockGetMuscleGroupsUseCase();
    mockMusclesByGroupUC = MockGetMusclesByGroupIdUseCase();

    useCase = GetHomeDataUseCase(
      mockCategoriesUC,
      mockWorkoutsUC,
      mockRandomUC,
      mockMuscleGroupsUC,
      mockMusclesByGroupUC,
    );
  });

  group('GetHomeDataUseCase Tests', () {
    test(
      'should emit multiple updates as different use cases complete',
      () async {
        // Arrange
        // 1. Random Muscles
        when(
          () => mockRandomUC(),
        ).thenAnswer((_) async => const SuccessResponse(data: []));

        // 2. Muscle Groups & Muscles
        final mockGroups = [const MuscleGroupEntity(id: 'g1', name: 'Group 1')];
        when(
          () => mockMuscleGroupsUC(),
        ).thenAnswer((_) async => SuccessResponse(data: mockGroups));
        when(
          () => mockMusclesByGroupUC(any()),
        ).thenAnswer((_) async => const SuccessResponse(data: []));

        // 3. Categories
        when(
          () => mockCategoriesUC(),
        ).thenAnswer((_) async => const SuccessResponse(data: []));

        // 4. Popular Workouts (Stream)
        final mockPopular = <PopularWorkoutEntity>[];
        when(
          () => mockWorkoutsUC(),
        ).thenAnswer((_) => Stream.value(SuccessResponse(data: mockPopular)));

        // Act
        final stream = useCase.execute();

        // Assert — now 4 sections (user profile was removed)
        await expectLater(
          stream,
          emitsThrough(
            predicate((List<BaseResponse<HomeSection>> list) {
              return list.length == 4 &&
                  list.every((e) => e is SuccessResponse);
            }),
          ),
        );

        // Verify all calls
        verify(() => mockRandomUC()).called(1);
        verify(() => mockMuscleGroupsUC()).called(1);
        verify(() => mockCategoriesUC()).called(1);
        verify(() => mockWorkoutsUC()).called(1);
      },
    );

    test(
      'should handle failures from individual use cases correctly',
      () async {
        // 1. Random Muscles — error
        when(
          () => mockRandomUC(),
        ).thenAnswer(
          (_) async => const ErrorResponse(errorMessage: 'Random Muscles Error'),
        );

        // 2. Muscle Groups
        final mockGroups = [const MuscleGroupEntity(id: 'g1', name: 'Group 1')];
        when(
          () => mockMuscleGroupsUC(),
        ).thenAnswer((_) async => SuccessResponse(data: mockGroups));
        when(
          () => mockMusclesByGroupUC(any()),
        ).thenAnswer((_) async => const SuccessResponse(data: []));

        // 3. Categories
        when(
          () => mockCategoriesUC(),
        ).thenAnswer((_) async => const SuccessResponse(data: []));

        // 4. Popular Workouts
        when(
          () => mockWorkoutsUC(),
        ).thenAnswer((_) => Stream.value(const SuccessResponse(data: [])));

        // Act
        final stream = useCase.execute();

        // Assert — index 0 is RandomMuscles, should be ErrorResponse
        await expectLater(
          stream,
          emitsThrough(
            predicate((List<BaseResponse<HomeSection>> list) {
              return list[0] is ErrorResponse &&
                  (list[0] as ErrorResponse).errorMessage ==
                      'Random Muscles Error';
            }),
          ),
        );
      },
    );
  });
}
