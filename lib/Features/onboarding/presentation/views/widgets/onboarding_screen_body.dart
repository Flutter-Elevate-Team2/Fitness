import 'package:fitness_app/Features/onboarding/domain/entities/onboarding_entity.dart';
import 'package:fitness_app/Features/onboarding/presentation/view_model/onboarding_state.dart';
import 'package:fitness_app/Features/onboarding/presentation/views/widgets/onboarding_bottom_section.dart';
import 'package:fitness_app/Features/onboarding/presentation/views/widgets/onboarding_skip_button.dart';
import 'package:fitness_app/core/extension/context_extention.dart';
import 'package:fitness_app/core/widget/shared_scaffold.dart';
import 'package:fitness_app/gen/assets.gen.dart';
import 'package:flutter/material.dart';

class OnboardingScreenBody extends StatefulWidget {
  final OnboardingState state;
  const OnboardingScreenBody({super.key, required this.state});

  @override
  State<OnboardingScreenBody> createState() => _OnboardingScreenBodyState();
}

class _OnboardingScreenBodyState extends State<OnboardingScreenBody> {
  final PageController _pageController = PageController();
  late List<OnboardingEntity> _pages;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _pages = [
      OnboardingEntity(
        title: context.l10n.onboarding1Title,
        description: context.l10n.onboarding1Desc,
        image: Assets.images.onboarding1.path,
      ),
      OnboardingEntity(
        title: context.l10n.onboarding2Title,
        description: context.l10n.onboarding2Desc,
        image: Assets.images.onboarding2.path,
      ),
      OnboardingEntity(
        title: context.l10n.onboarding3Title,
        description: context.l10n.onboarding3Desc,
        image: Assets.images.onboarding3.path,
      ),
    ];
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final double imageTop = _getImageTop(widget.state.currentIndex, context);
    final double imageHeight = _getImageHeight(
      widget.state.currentIndex,
      context,
    );

    return SharedScaffold(
      showBackButton: false,
      backgroundImage: Assets.images.onboardingBackground.path,
      foregroundImage: _pages[widget.state.currentIndex].image,
      foregroundImageTop: imageTop,
      foregroundImageHeight: imageHeight,
      body: Stack(
        children: [
          // 1. Skip Button
          if (widget.state.currentIndex != _pages.length - 1)
            const OnboardingSkipButton(),

          Column(
            children: [
              const Spacer(),
              // 2. Bottom Container (Controls & Content)
              OnboardingBottomSection(
                pageController: _pageController,
                pages: _pages,
                state: widget.state,
              ),
            ],
          ),
        ],
      ),
    );
  }

  double _getImageTop(int index, BuildContext context) {
    final h = MediaQuery.of(context).size.height;
    return switch (index) {
      1 => h * 0.1,
      2 => h * 0.15,
      _ => h * 0.02,
    };
  }

  double _getImageHeight(int index, BuildContext context) {
    final h = MediaQuery.of(context).size.height;
    return switch (index) {
      1 => h * 0.65,
      2 => h * 0.6,
      _ => h * 0.7,
    };
  }
}
