// Features/onboarding/presentation/pages/onboarding_screen.dart
import 'package:fitness_app/Features/onboarding/domain/entities/onboarding_entity.dart';
import 'package:fitness_app/Features/onboarding/presentation/view_model/onboarding_event.dart';
import 'package:fitness_app/Features/onboarding/presentation/view_model/onboarding_state.dart';
import 'package:fitness_app/Features/onboarding/presentation/view_model/onboarding_view_model.dart';
import 'package:fitness_app/Features/onboarding/presentation/views/widgets/onboarding_content_widget.dart';
import 'package:fitness_app/core/di/di.dart';
import 'package:fitness_app/core/theming/app_colors.dart';
import 'package:fitness_app/core/theming/app_typography.dart';
import 'package:fitness_app/core/widget/custom_button.dart';
import 'package:fitness_app/core/widget/shared_container.dart';
import 'package:fitness_app/core/widget/shared_scaffold.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';

class OnboardingScreen extends StatefulWidget {
  const OnboardingScreen({super.key});

  @override
  State<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {
  final PageController _pageController = PageController();
  final List<OnboardingEntity> _pages = OnboardingEntity.getPages();

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => getIt<OnboardingViewModel>(),
      child: BlocConsumer<OnboardingViewModel, OnboardingState>(
        listener: (context, state) {
          if (state.isFinished) {
            // Navigator.pushReplacementNamed(context, Routes.login);
          }
        },
        builder: (context, state) {
          return SharedScaffold(
            showBackButton: false,
            backgroundImage: 'assets/images/onboarding_background.png',
            foregroundImage: _pages[state.currentIndex].image,
            body: Stack(
              children: [
                if (state.currentIndex != _pages.length - 1)
                  Positioned(
                    top: 10,
                    right: 5,
                    child: TextButton(
                      onPressed: () => context
                          .read<OnboardingViewModel>()
                          .doIntent(OnboardingGetStartedClickedEvent()),
                      child: Text(
                        "Skip",
                        style: AppTypography.bodyMedium.copyWith(
                          color: AppColors.white,
                          fontSize: 14,
                          fontWeight: FontWeight.w100,
                        ),
                      ),
                    ),
                  ),
                Column(
                  children: [
                    const Spacer(),
                    SharedContainer(
                      isTopOnly: true,
                      borderRadius: 50,
                      blur: 10,
                      opacity: 0.5,
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          SizedBox(
                            height: MediaQuery.of(context).size.height * .17,
                            child: PageView.builder(
                              controller: _pageController,
                              itemCount: _pages.length,
                              onPageChanged: (index) {
                                context.read<OnboardingViewModel>().doIntent(
                                  OnboardingPageChangedEvent(index),
                                );
                              },
                              itemBuilder: (context, index) {
                                return OnboardingContentWidget(
                                  entity: _pages[index],
                                );
                              },
                            ),
                          ),
                          SmoothPageIndicator(
                            controller: _pageController,
                            count: _pages.length,
                            effect: ExpandingDotsEffect(
                              activeDotColor: Theme.of(context).primaryColor,
                              dotColor: AppColors.white,
                              dotHeight: 8,
                              dotWidth: 8,
                              expansionFactor: 3,
                            ),
                          ),
                          const SizedBox(height: 24),
                          Row(
                            children: [
                              if (state.currentIndex > 0)
                                Expanded(
                                  child: CustomButton(
                                    title: "Back",
                                    backgroundColor: Colors.transparent,
                                    hasBorder: true,
                                    onPressed: () {
                                      _pageController.previousPage(
                                        duration: const Duration(
                                          milliseconds: 300,
                                        ),
                                        curve: Curves.easeInOut,
                                      );
                                    },
                                  ),
                                ),
                              if (state.currentIndex > 0)
                                SizedBox(
                                  width:
                                      MediaQuery.of(context).size.width * 0.5,
                                ),
                              Expanded(
                                child: CustomButton(
                                  title: state.currentIndex == _pages.length - 1
                                      ? "Go It!"
                                      : "Next",
                                  onPressed: () {
                                    if (state.currentIndex ==
                                        _pages.length - 1) {
                                      context
                                          .read<OnboardingViewModel>()
                                          .doIntent(
                                            OnboardingGetStartedClickedEvent(),
                                          );
                                    } else {
                                      _pageController.nextPage(
                                        duration: const Duration(
                                          milliseconds: 300,
                                        ),
                                        curve: Curves.easeInOut,
                                      );
                                    }
                                  },
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
