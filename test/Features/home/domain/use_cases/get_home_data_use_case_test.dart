import 'package:fitness_app/Features/food/domain/use_cases/categories_use_case.dart';
import 'package:fitness_app/Features/home/domain/entities/home_section.dart';
import 'package:fitness_app/Features/home/domain/entities/popular_tranning_entity.dart';
import 'package:fitness_app/Features/home/domain/use_cases/get_home_data_use_case.dart';
import 'package:fitness_app/Features/home/domain/use_cases/get_popular_workouts_use_case.dart';
import 'package:fitness_app/Features/profile/domain/entities/user_entity.dart';
import 'package:fitness_app/Features/profile/domain/use_cases/get_user_profile_use_case.dart';
import 'package:fitness_app/Features/workouts/domain/entities/muscle_group_entity.dart';
import 'package:fitness_app/Features/workouts/domain/use_cases/get_muscle_groups_use_case.dart';
import 'package:fitness_app/Features/workouts/domain/use_cases/get_muscles_by_group_id_use_case.dart';
import 'package:fitness_app/Features/workouts/domain/use_cases/get_random_muscles_use_case.dart';
import 'package:fitness_app/core/base_response/base_response.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

// Mocks
class MockGetUserProfileUseCase extends Mock implements GetUserProfileUseCase {}

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
  late MockGetUserProfileUseCase mockUserUC;
  late MockGetCategoriesUseCase mockCategoriesUC;
  late MockGetPopularWorkoutsUseCase mockWorkoutsUC;
  late MockGetRandomMusclesUseCase mockRandomUC;
  late MockGetMuscleGroupsUseCase mockMuscleGroupsUC;
  late MockGetMusclesByGroupIdUseCase mockMusclesByGroupUC;

  setUp(() {
    mockUserUC = MockGetUserProfileUseCase();
    mockCategoriesUC = MockGetCategoriesUseCase();
    mockWorkoutsUC = MockGetPopularWorkoutsUseCase();
    mockRandomUC = MockGetRandomMusclesUseCase();
    mockMuscleGroupsUC = MockGetMuscleGroupsUseCase();
    mockMusclesByGroupUC = MockGetMusclesByGroupIdUseCase();

    useCase = GetHomeDataUseCase(
      mockUserUC,
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
        // 1. User Profile
        final mockUser = UserEntity(
          id: '1',
          email: '',
          photo: '',
          firstName: '',
          lastName: '',
          gender: '',
          age: 0,
          weight: 0,
          height: 0,
          activityLevel: '',
          goal: '',
        );
        when(
          () => mockUserUC(),
        ).thenAnswer((_) async => SuccessResponse(data: mockUser));

        // 2. Random Muscles
        when(
          () => mockRandomUC(),
        ).thenAnswer((_) async => const SuccessResponse(data: []));

        // 3. Muscle Groups & Muscles
        final mockGroups = [const MuscleGroupEntity(id: 'g1', name: 'Group 1')];
        when(
          () => mockMuscleGroupsUC(),
        ).thenAnswer((_) async => SuccessResponse(data: mockGroups));
        when(
          () => mockMusclesByGroupUC(any()),
        ).thenAnswer((_) async => const SuccessResponse(data: []));

        // 4. Categories
        when(
          () => mockCategoriesUC(),
        ).thenAnswer((_) async => const SuccessResponse(data: []));

        // 5. Popular Workouts (Stream)
        final mockPopular = <PopularWorkoutEntity>[];
        when(
          () => mockWorkoutsUC(),
        ).thenAnswer((_) => Stream.value(SuccessResponse(data: mockPopular)));

        // Act
        final stream = useCase.execute();

        // Assert
        await expectLater(
          stream,
          emitsThrough(
            predicate((List<BaseResponse<HomeSection>> list) {
              final hasUser = list[0] is SuccessResponse;
              final hasPopular = list[4] is SuccessResponse;
              return list.length == 5 && (hasUser || hasPopular);
            }),
          ),
        );

        // Verify all calls
        verify(() => mockUserUC()).called(1);
        verify(() => mockRandomUC()).called(1);
        verify(() => mockMuscleGroupsUC()).called(1);
        verify(() => mockCategoriesUC()).called(1);
        verify(() => mockWorkoutsUC()).called(1);
      },
    );

    test(
      'should handle failures from individual use cases correctly',
      () async {
        when(() => mockUserUC()).thenAnswer(
          (_) async => const ErrorResponse(errorMessage: 'User Error'),
        );

        // 1. Random Muscles
        when(
          () => mockRandomUC(),
        ).thenAnswer((_) async => const SuccessResponse(data: []));

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

        // Assert
        await expectLater(
          stream,
          emitsThrough(
            predicate((List<BaseResponse<HomeSection>> list) {
              return list[0] is ErrorResponse &&
                  (list[0] as ErrorResponse).errorMessage == 'User Error';
            }),
          ),
        );
      },
    );
  });
}
