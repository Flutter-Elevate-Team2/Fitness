import 'package:fitness_app/Features/onboarding/presentation/view_model/onboarding_event.dart';
import 'package:fitness_app/Features/onboarding/presentation/view_model/onboarding_view_model.dart';
import 'package:fitness_app/core/extension/context_extention.dart';
import 'package:fitness_app/core/widget/custom_button.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class OnboardingActionButtons extends StatelessWidget {
  final PageController pageController;
  final int currentIndex;
  final bool isLastPage;

  const OnboardingActionButtons({
    super.key,
    required this.pageController,
    required this.currentIndex,
    required this.isLastPage,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        if (currentIndex > 0)
          Expanded(
            child: CustomButton(
              title: context.l10n.back,
              backgroundColor: Colors.transparent,
              hasBorder: true,
              onPressed: () => pageController.previousPage(
                duration: const Duration(milliseconds: 300),
                curve: Curves.easeInOut,
              ),
            ),
          ),
        if (currentIndex > 0)
          SizedBox(width: MediaQuery.sizeOf(context).width * 0.45),
        Expanded(
          child: CustomButton(
            title: isLastPage ? context.l10n.doIt : context.l10n.next,
            onPressed: () {
              if (isLastPage) {
                context.read<OnboardingViewModel>().doIntent(
                  OnboardingGetStartedClickedEvent(),
                );
              } else {
                pageController.nextPage(
                  duration: const Duration(milliseconds: 300),
                  curve: Curves.easeInOut,
                );
              }
            },
          ),
        ),
      ],
    );
  }
}
