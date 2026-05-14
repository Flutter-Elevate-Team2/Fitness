import 'package:fitness_app/Features/onboarding/data/data_sources/onboarding_local_data_source_contract.dart';
import 'package:fitness_app/Features/onboarding/domain/repo/onboarding_repo_contract.dart';
import 'package:injectable/injectable.dart';

@Injectable(as: OnboardingRepoContract)
class OnboardingRepoImpl implements OnboardingRepoContract {
  final OnboardingLocalDataSourceContract _localDataSource;

  OnboardingRepoImpl(this._localDataSource);

  @override
  Future<void> setVisited() async =>
      await _localDataSource.saveOnboardingVisited();

  @override
  bool checkVisited() => _localDataSource.isOnboardingVisited();
}
