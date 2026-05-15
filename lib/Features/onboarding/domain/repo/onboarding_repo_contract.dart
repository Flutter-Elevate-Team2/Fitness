abstract class OnboardingRepoContract {
  Future<void> setVisited();
  bool checkVisited();
}