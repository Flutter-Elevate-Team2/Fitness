import 'package:fitness_app/Features/home/domain/repo/home_repo_contract.dart';
import 'package:fitness_app/Features/home/domain/use_cases/get_levels_use_case.dart';
import 'package:fitness_app/Features/workouts/domain/entities/difficulty_level_entity.dart';
import 'package:fitness_app/core/base_response/base_response.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

class MockHomeRepo extends Mock implements HomeRepoContract {}

void main() {
  late GetLevelsUseCase getLevelsUseCase;
  late MockHomeRepo mockHomeRepo;

  setUp(() {
    mockHomeRepo = MockHomeRepo();
    getLevelsUseCase = GetLevelsUseCase(mockHomeRepo);
  });

  group('GetLevelsUseCase Unit Tests', () {
    final mockLevels = [
      const DifficultyLevelEntity(id: '1', name: 'Beginner'),
      const DifficultyLevelEntity(id: '2', name: 'Expert'),
    ];

    test(
      'should fetch data from the Repository and return SuccessResponse',
      () async {
        // Arrange
        when(
          () => mockHomeRepo.getLevels(),
        ).thenAnswer((_) async => SuccessResponse(data: mockLevels));

        // Act
        final result = await getLevelsUseCase.call();

        // Assert
        expect(result, isA<SuccessResponse<List<DifficultyLevelEntity>>>());
        expect((result as SuccessResponse).data, mockLevels);

        verify(() => mockHomeRepo.getLevels()).called(1);
      },
    );

    test('should return ErrorResponse when the Repository fails', () async {
      // Arrange
      const errorMessage = 'Server Error';
      when(
        () => mockHomeRepo.getLevels(),
      ).thenAnswer((_) async => ErrorResponse(errorMessage: errorMessage));

      // Act
      final result = await getLevelsUseCase.call();

      // Assert
      expect(result, isA<ErrorResponse>());
      expect((result as ErrorResponse).errorMessage, errorMessage);

      verify(() => mockHomeRepo.getLevels()).called(1);
    });
  });
}
