import 'package:fitness_app/Features/home/domain/entities/popular_tranning_entity.dart';
import 'package:fitness_app/Features/home/domain/repo/home_repo_contract.dart';
import 'package:fitness_app/Features/home/domain/use_cases/get_popular_workouts_use_case.dart';
import 'package:fitness_app/Features/workouts/domain/entities/difficulty_level_entity.dart';
import 'package:fitness_app/Features/workouts/domain/entities/exercise_entity.dart';
import 'package:fitness_app/Features/workouts/domain/entities/random_muscles_entity.dart';
import 'package:fitness_app/Features/workouts/domain/repo/workouts_repo_contract.dart';
import 'package:fitness_app/core/base_response/base_response.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

class MockHomeRepo extends Mock implements HomeRepoContract {}

class MockWorkoutsRepo extends Mock implements WorkoutsRepoContract {}

void main() {
  late GetPopularWorkoutsUseCase useCase;
  late MockHomeRepo mockHomeRepo;
  late MockWorkoutsRepo mockWorkoutsRepo;

  setUp(() {
    mockHomeRepo = MockHomeRepo();
    mockWorkoutsRepo = MockWorkoutsRepo();
    useCase = GetPopularWorkoutsUseCase(mockHomeRepo, mockWorkoutsRepo);
  });

  group('GetPopularWorkoutsUseCase Tests', () {
    final mockLevels = [
      const DifficultyLevelEntity(id: 'l1', name: 'Beginner'),
    ];
    final mockMuscles = [
      const RandomMusclesEntity(id: 'm1', name: 'Chest', image: 'img1'),
      const RandomMusclesEntity(id: 'm2', name: 'Back', image: 'img2'),
    ];

    test('should emit ErrorResponse if fetching levels fails', () async {
      // Arrange
      when(() => mockHomeRepo.getLevels()).thenAnswer(
        (_) async => const ErrorResponse(errorMessage: 'Level Error'),
      );
      when(
        () => mockWorkoutsRepo.getRandomMuscles(),
      ).thenAnswer((_) async => SuccessResponse(data: mockMuscles));

      // Act
      final stream = useCase.call();

      // Assert
      expect(
        stream,
        emitsInOrder([
          isA<ErrorResponse>().having(
            (e) => e.errorMessage,
            'message',
            'Level Error',
          ),
          emitsDone,
        ]),
      );
    });

    test(
      'should execute Round-Robin batching successfully and emit SuccessResponse',
      () async {
        // Arrange
        when(
          () => mockHomeRepo.getLevels(),
        ).thenAnswer((_) async => SuccessResponse(data: mockLevels));
        when(
          () => mockWorkoutsRepo.getRandomMuscles(),
        ).thenAnswer((_) async => SuccessResponse(data: mockMuscles));

        when(
          () => mockWorkoutsRepo.getExercisesByMuscleDifficulty(
            any(),
            any(),
            any(),
          ),
        ).thenAnswer(
          (_) async => const SuccessResponse(
            data: [
              ExerciseEntity(
                id: 'e1',
                title: '',
                description: '',
                sets: 0,
                reps: 0,
                thumbnailUrl: '',
              ),
            ],
          ),
        );

        // Act
        final stream = useCase.call();

        // Assert
        await expectLater(
          stream,
          emitsInOrder([
            isA<SuccessResponse<List<PopularWorkoutEntity>>>().having(
              (s) => s.data.length,
              'workout count',
              greaterThan(0),
            ),
            emitsDone,
          ]),
        );

        verify(() => mockHomeRepo.getLevels()).called(1);
        verify(() => mockWorkoutsRepo.getRandomMuscles()).called(1);
      },
    );

    test('should emit ErrorResponse with "لا توجد بيانات متاحة" if lists are empty', () async {
      // Arrange
      when(() => mockHomeRepo.getLevels()).thenAnswer(
              (_) async => const SuccessResponse(data: []));
      when(() => mockWorkoutsRepo.getRandomMuscles()).thenAnswer(
              (_) async => const SuccessResponse(data: []));

      // Act & Assert
      expect(useCase.call(), emitsInOrder([
        isA<ErrorResponse>().having((e) => e.errorMessage, 'message', 'لا توجد بيانات متاحة'),
        emitsDone,
      ]));
    });
  });
}
