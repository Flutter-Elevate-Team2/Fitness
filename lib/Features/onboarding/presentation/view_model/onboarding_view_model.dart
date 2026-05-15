import 'package:fitness_app/Features/onboarding/domain/use_cases/onboarding_use_case.dart';
import 'package:fitness_app/Features/onboarding/presentation/view_model/onboarding_event.dart';
import 'package:fitness_app/Features/onboarding/presentation/view_model/onboarding_state.dart';
import 'package:injectable/injectable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

@injectable
class OnboardingViewModel extends Cubit<OnboardingState> {
  final SetOnboardingVisitedUseCase _setOnboardingVisitedUseCase;

  OnboardingViewModel(this._setOnboardingVisitedUseCase)
    : super(const OnboardingState());

  void doIntent(OnboardingEvent event) {
    switch (event) {
      case OnboardingPageChangedEvent():
        _onPageChanged(event.pageIndex);
        break;
      case OnboardingGetStartedClickedEvent():
        _handleGetStarted();
        break;
    }
  }

  void _onPageChanged(int index) {
    emit(state.copyWith(currentIndex: index));
  }

  Future<void> _handleGetStarted() async {
    await _setOnboardingVisitedUseCase.call();

    emit(state.copyWith(isFinished: true));
  }
}
