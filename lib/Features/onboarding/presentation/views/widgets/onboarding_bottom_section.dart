import 'package:fitness_app/Features/onboarding/domain/entities/onboarding_entity.dart';
import 'package:fitness_app/Features/onboarding/presentation/view_model/onboarding_state.dart';
import 'package:fitness_app/Features/onboarding/presentation/views/widgets/onboarding_action_buttons.dart';
import 'package:fitness_app/Features/onboarding/presentation/views/widgets/onboarding_indicator.dart';
import 'package:fitness_app/Features/onboarding/presentation/views/widgets/onboarding_page_view.dart';
import 'package:fitness_app/core/widget/shared_container.dart';
import 'package:flutter/material.dart';

class OnboardingBottomSection extends StatelessWidget {
  final PageController pageController;
  final List<OnboardingEntity> pages;
  final OnboardingState state;

  const OnboardingBottomSection({
    super.key,
    required this.pageController,
    required this.pages,
    required this.state,
  });

  @override
  Widget build(BuildContext context) {
    return SharedContainer(
      isTopOnly: true,
      borderRadius: 50,
      blur: 10,
      opacity: 0.5,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          OnboardingPageView(pageController: pageController, pages: pages),

          OnboardingIndicator(
            pageController: pageController,
            count: pages.length,
          ),

          const SizedBox(height: 24),

          OnboardingActionButtons(
            pageController: pageController,
            currentIndex: state.currentIndex,
            isLastPage: state.currentIndex == pages.length - 1,
          ),
        ],
      ),
    );
  }
}
