sealed class OnboardingEvent {}

class OnboardingPageChangedEvent extends OnboardingEvent {
  final int pageIndex;
  OnboardingPageChangedEvent(this.pageIndex);
}

class OnboardingGetStartedClickedEvent extends OnboardingEvent {}
