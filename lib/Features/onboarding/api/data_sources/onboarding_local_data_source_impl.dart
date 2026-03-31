import 'package:fitness_app/Features/onboarding/data/data_sources/onboarding_local_data_source_contract.dart';
import 'package:injectable/injectable.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:fitness_app/core/constants/api_constants.dart';

@Injectable(as: OnboardingLocalDataSourceContract)
class OnboardingLocalDataSourceImpl
    implements OnboardingLocalDataSourceContract {
  final SharedPreferences _prefs;

  OnboardingLocalDataSourceImpl(this._prefs);

  @override
  Future<void> saveOnboardingVisited() async {
    await _prefs.setBool(ApiConstants.onboardingKey, true);
  }

  @override
  bool isOnboardingVisited() {
    return _prefs.getBool(ApiConstants.onboardingKey) ?? false;
  }
}
