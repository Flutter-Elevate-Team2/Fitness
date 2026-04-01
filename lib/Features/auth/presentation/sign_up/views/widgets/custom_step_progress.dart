import 'package:fitness_app/core/theming/app_colors.dart';
import 'package:flutter/material.dart';

class CustomStepProgress extends StatelessWidget {
  final int currentStep;
  final int totalSteps;

  const CustomStepProgress({
    super.key,
    required this.currentStep,
    this.totalSteps = 6,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 40,
      height: 40,
      child: Stack(
        fit: StackFit.expand,
        children: [
          CircularProgressIndicator(
            value: currentStep / totalSteps,
            backgroundColor: AppColors.white.withValues(alpha: 0.1),
            color: AppColors.primary,
            strokeWidth: 4,
            strokeCap: StrokeCap.round,
          ),
          Center(
            child: Text(
              "$currentStep/$totalSteps",
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    color: AppColors.white,
                    fontWeight: FontWeight.bold,
                  ),
            ),
          ),
        ],
      ),
    );
  }
}
