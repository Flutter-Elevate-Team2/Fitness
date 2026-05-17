import 'package:fitness_app/Features/onboarding/data/data_sources/onboarding_local_data_source_contract.dart';
import 'package:fitness_app/Features/onboarding/data/repo/onboarding_repo_impl.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

import 'onboarding_repo_impl_test.mocks.dart';

@GenerateMocks([OnboardingLocalDataSourceContract])
void main() {
  late OnboardingRepoImpl repository;
  late MockOnboardingLocalDataSourceContract mockDataSource;

  setUp(() {
    mockDataSource = MockOnboardingLocalDataSourceContract();
    repository = OnboardingRepoImpl(mockDataSource);
  });

  test('setVisited should call saveOnboardingVisited on dataSource', () async {
    // Act
    await repository.setVisited();

    // Assert
    verify(mockDataSource.saveOnboardingVisited()).called(1);
  });

  test('checkVisited should return value from dataSource', () {
    // Arrange
    when(mockDataSource.isOnboardingVisited()).thenReturn(true);

    // Act
    final result = repository.checkVisited();

    // Assert
    expect(result, true);
    verify(mockDataSource.isOnboardingVisited()).called(1);
  });
}
