import 'package:fitness_app/core/extension/context_extention.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fitness_app/core/theming/app_typography.dart';
import 'package:fitness_app/core/theming/app_colors.dart';
import 'package:fitness_app/Features/onboarding/presentation/view_model/onboarding_view_model.dart';
import 'package:fitness_app/Features/onboarding/presentation/view_model/onboarding_event.dart';

class OnboardingSkipButton extends StatelessWidget {
  const OnboardingSkipButton({super.key});

  @override
  Widget build(BuildContext context) {
    return Positioned(
      top: 10,
      right: 5,
      child: TextButton(
        onPressed: () => context.read<OnboardingViewModel>().doIntent(
          OnboardingGetStartedClickedEvent(),
        ),
        child: Text(
          context.l10n.skip,
          style: AppTypography.bodyMedium.copyWith(
            color: AppColors.white,
            fontSize: 14,
            fontWeight: FontWeight.w100,
          ),
        ),
      ),
    );
  }
}
