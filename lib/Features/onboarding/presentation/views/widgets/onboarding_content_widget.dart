import 'package:fitness_app/Features/onboarding/domain/entities/onboarding_entity.dart';
import 'package:fitness_app/core/theming/app_colors.dart';
import 'package:fitness_app/core/theming/app_typography.dart';
import 'package:flutter/material.dart';

class OnboardingContentWidget extends StatelessWidget {
  final OnboardingEntity entity;

  const OnboardingContentWidget({super.key, required this.entity});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        SizedBox(
          child: Text(
            entity.title,
            textAlign: TextAlign.center,
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
            style: AppTypography.headlineLarge.copyWith(
              color: AppColors.white,
              fontSize: 26,
              height: 1.2,
            ),
          ),
        ),
        const SizedBox(height: 12),
        Text(
          entity.description,
          textAlign: TextAlign.center,
          style: const TextStyle(
            fontSize: 16,
            color: AppColors.light400,
            height: 1.5,
          ),
        ),
      ],
    );
  }
}
