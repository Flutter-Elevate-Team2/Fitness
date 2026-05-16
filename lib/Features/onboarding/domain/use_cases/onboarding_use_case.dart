import 'package:fitness_app/Features/onboarding/domain/repo/onboarding_repo_contract.dart';
import 'package:injectable/injectable.dart';

@injectable
class SetOnboardingVisitedUseCase {
  final OnboardingRepoContract _repository;
  SetOnboardingVisitedUseCase(this._repository);

  Future<void> call() async {
    await _repository.setVisited();
  }
}