import 'package:fitness_app/Features/onboarding/domain/repo/onboarding_repo_contract.dart';
import 'package:fitness_app/Features/onboarding/domain/use_cases/onboarding_use_case.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

import 'onboarding_use_case_test.mocks.dart';

@GenerateMocks([OnboardingRepoContract])
void main() {
  late SetOnboardingVisitedUseCase useCase;
  late MockOnboardingRepoContract mockRepo;

  setUp(() {
    mockRepo = MockOnboardingRepoContract();
    useCase = SetOnboardingVisitedUseCase(mockRepo);
  });

  test('should call setVisited on the repository when called', () async {
    // Act
    await useCase.call();

    // Assert
    verify(mockRepo.setVisited()).called(1);
    verifyNoMoreInteractions(mockRepo);
  });
}
