import 'package:bloc_test/bloc_test.dart';
import 'package:fitness_app/Features/onboarding/domain/use_cases/onboarding_use_case.dart';
import 'package:fitness_app/Features/onboarding/presentation/view_model/onboarding_event.dart';
import 'package:fitness_app/Features/onboarding/presentation/view_model/onboarding_state.dart';
import 'package:fitness_app/Features/onboarding/presentation/view_model/onboarding_view_model.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

import 'onboarding_view_model_test.mocks.dart';

@GenerateMocks([SetOnboardingVisitedUseCase])
void main() {
  late OnboardingViewModel viewModel;
  late MockSetOnboardingVisitedUseCase mockUseCase;

  setUp(() {
    mockUseCase = MockSetOnboardingVisitedUseCase();
    viewModel = OnboardingViewModel(mockUseCase);
  });

  group('OnboardingViewModel Tests', () {
    test('initial state should be OnboardingState with default values', () {
      expect(viewModel.state, const OnboardingState());
    });

    blocTest<OnboardingViewModel, OnboardingState>(
      'emits state with updated currentIndex when OnboardingPageChangedEvent is added',
      build: () => viewModel,
      act: (viewModel) => viewModel.doIntent(OnboardingPageChangedEvent(1)),
      expect: () => [const OnboardingState(currentIndex: 1)],
    );

    blocTest<OnboardingViewModel, OnboardingState>(
      'should call usecase and emit isFinished true when OnboardingGetStartedClickedEvent is added',
      build: () {
        when(mockUseCase.call()).thenAnswer((_) async => {});
        return viewModel;
      },
      act: (viewModel) =>
          viewModel.doIntent(OnboardingGetStartedClickedEvent()),
      expect: () => [const OnboardingState(isFinished: true)],
      verify: (_) {
        verify(mockUseCase.call()).called(1);
      },
    );
  });
}
