import 'package:fitness_app/core/theming/app_colors.dart';
import 'package:fitness_app/core/theming/app_typography.dart';
import 'package:fitness_app/core/widget/custom_button.dart';
import 'package:flutter/material.dart';


class SmartCoachIntroCard extends StatelessWidget {

  final VoidCallback? onGetStarted;

  const SmartCoachIntroCard({super.key, this.onGetStarted});

  @override
  Widget build(BuildContext context) {
    final title = 'How Can I Assist You\nToday ?'; 
    final buttonLabel = 'Get Started'; 

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        const SizedBox(height: 16),


        Text(
          title,
          textAlign: TextAlign.center,
          style: AppTypography.headlineLarge.copyWith(
            color: AppColors.white,
          ),
        ),

        const SizedBox(height: 20),


        CustomButton(
          title: buttonLabel,
          backgroundColor: AppColors.primary,
          onPressed: onGetStarted ?? () {},
        ),


        SizedBox(height: MediaQuery.of(context).padding.bottom + 16),
      ],
    );
  }
}
