import 'package:fitness_app/Features/home/data/data_source_contract/home_remot_data_source.dart';
import 'package:fitness_app/Features/home/data/models/levels_respones/levels_respones.dart';
import 'package:fitness_app/Features/home/data/repo/home_repo_imple.dart';
import 'package:fitness_app/Features/workouts/domain/entities/difficulty_level_entity.dart';
import 'package:fitness_app/core/base_response/base_response.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

class MockHomeRemoteDataSource extends Mock
    implements HomeRemoteDataSourceContract {}

void main() {
  late HomeRepoImpl homeRepo;
  late MockHomeRemoteDataSource mockRemoteDataSource;

  setUp(() {
    mockRemoteDataSource = MockHomeRemoteDataSource();
    homeRepo = HomeRepoImpl(mockRemoteDataSource);
  });

  group('HomeRepoImpl Unit Tests', () {
    test(
      'getLevels should return SuccessResponse when Data Source and Mapping are successful',
      () async {
        // Arrange
        final mockModelResponse = LevelsRespones();

        when(
          () => mockRemoteDataSource.getLevels(),
        ).thenAnswer((_) async => mockModelResponse);

        // Act
        final result = await homeRepo.getLevels();

        // Assert
        expect(result, isA<SuccessResponse<List<DifficultyLevelEntity>>>());
        verify(() => mockRemoteDataSource.getLevels()).called(1);
      },
    );

    test(
      'getLevels should return ErrorResponse when an API error occurs',
      () async {
        // Arrange
        when(
          () => mockRemoteDataSource.getLevels(),
        ).thenThrow(Exception('No Internet'));

        // Act
        final result = await homeRepo.getLevels();

        // Assert
        expect(result, isA<ErrorResponse>());
        verify(() => mockRemoteDataSource.getLevels()).called(1);
      },
    );
  });
}
