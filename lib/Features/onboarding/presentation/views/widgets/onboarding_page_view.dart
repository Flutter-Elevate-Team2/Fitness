import 'package:flutter/material.dart';
import 'package:fitness_app/Features/onboarding/domain/entities/onboarding_entity.dart';
import 'package:fitness_app/Features/onboarding/presentation/view_model/onboarding_view_model.dart';
import 'package:fitness_app/Features/onboarding/presentation/view_model/onboarding_event.dart';
import 'package:fitness_app/Features/onboarding/presentation/views/widgets/onboarding_content_widget.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class OnboardingPageView extends StatelessWidget {
  final PageController pageController;
  final List<OnboardingEntity> pages;

  const OnboardingPageView({
    super.key,
    required this.pageController,
    required this.pages,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: MediaQuery.sizeOf(context).height * .17,
      child: PageView.builder(
        controller: pageController,
        itemCount: pages.length,
        onPageChanged: (index) {
          context.read<OnboardingViewModel>().doIntent(
            OnboardingPageChangedEvent(index),
          );
        },
        itemBuilder: (context, index) {
          return OnboardingContentWidget(entity: pages[index]);
        },
      ),
    );
  }
}
