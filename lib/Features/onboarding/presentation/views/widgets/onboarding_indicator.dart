import 'package:flutter/material.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';
import 'package:fitness_app/core/theming/app_colors.dart';

class OnboardingIndicator extends StatelessWidget {
  final PageController pageController;
  final int count;

  const OnboardingIndicator({
    super.key,
    required this.pageController,
    required this.count,
  });

  @override
  Widget build(BuildContext context) {
    return SmoothPageIndicator(
      controller: pageController,
      count: count,
      effect: ExpandingDotsEffect(
        activeDotColor: Theme.of(context).primaryColor,
        dotColor: AppColors.white,
        dotHeight: 8,
        dotWidth: 8,
        expansionFactor: 3,
      ),
    );
  }
}
