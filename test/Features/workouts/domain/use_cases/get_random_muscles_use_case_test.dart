import 'package:fitness_app/Features/workouts/domain/entities/random_muscles_entity.dart';
import 'package:fitness_app/Features/workouts/domain/repo/workouts_repo_contract.dart';
import 'package:fitness_app/Features/workouts/domain/use_cases/get_random_muscles_use_case.dart';
import 'package:fitness_app/core/base_response/base_response.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

// ── Mock Repository ──────────────────────────────────────────────────────────
class MockWorkoutsRepository extends Mock implements WorkoutsRepoContract {}

void main() {
  late GetRandomMusclesUseCase useCase;
  late MockWorkoutsRepository mockRepository;

  setUp(() {
    mockRepository = MockWorkoutsRepository();
    useCase = GetRandomMusclesUseCase(mockRepository);
  });

  // ── Test Data ──────────────────────────────────────────────────────────────
  final tRandomMusclesList = [
    const RandomMusclesEntity(id: '1', name: 'Biceps', image: 'image_url'),
    const RandomMusclesEntity(id: '2', name: 'Chest', image: 'image_url'),
  ];

  final tResponse = SuccessResponse<List<RandomMusclesEntity>>(
    data: tRandomMusclesList,
  );
  test(
    'should call getRandomMuscles from the repository',
        () async {
      // Arrange
      when(() => mockRepository.getRandomMuscles())
          .thenAnswer((_) async => tResponse);

      // Act
      final result = await useCase.call();

      // Assert
      expect(result, equals(tResponse));
      // Verify that the repository method was actually called once
      verify(() => mockRepository.getRandomMuscles()).called(1);
      verifyNoMoreInteractions(mockRepository);
    },
  );

  test(
    'should return the same response as the repository (Failure case)',
        () async {
      // Arrange
          final tErrorResponse = ErrorResponse<List<RandomMusclesEntity>>(errorMessage:'Server Error'
          );
      when(() => mockRepository.getRandomMuscles())
          .thenAnswer((_) async => tErrorResponse);

      // Act
      final result = await useCase.call();

      // Assert
      expect(result, equals(tErrorResponse));
      verify(() => mockRepository.getRandomMuscles()).called(1);
    },
  );
}