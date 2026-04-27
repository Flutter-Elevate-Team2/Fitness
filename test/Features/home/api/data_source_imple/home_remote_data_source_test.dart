import 'package:fitness_app/Features/home/api/api_client/home_api.dart';
import 'package:fitness_app/Features/home/api/data_source_imple/home_remote_data_source.dart';
import 'package:fitness_app/Features/home/data/models/levels_respones/levels_respones.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

class MockHomeApi extends Mock implements HomeApi {}

void main() {
  late HomeRemoteDataSourceImpl dataSource;
  late MockHomeApi mockHomeApi;

  setUp(() {
    mockHomeApi = MockHomeApi();
    dataSource = HomeRemoteDataSourceImpl(homeApi: mockHomeApi);
  });

  group('HomeRemoteDataSourceImpl Unit Tests', () {
    test(
      'getLevels should call getLevels from API Client and return data successfully',
      () async {
        // Arrange
        final mockResponse = LevelsRespones(message: 'Success', levels: []);

        when(
          () => mockHomeApi.getLevels(),
        ).thenAnswer((_) async => mockResponse);

        // Act
        final result = await dataSource.getLevels();

        // Assert
        expect(result, isA<LevelsRespones>());
        expect(result.message, 'Success');

        verify(() => mockHomeApi.getLevels()).called(1);
      },
    );

    test(
      'should throw an Exception if the API Client throws an error',
      () async {
        // Arrange
        when(
          () => mockHomeApi.getLevels(),
        ).thenThrow(Exception('Network Error'));

        // Act & Assert
        expect(() => dataSource.getLevels(), throwsA(isA<Exception>()));
      },
    );
  });
}
