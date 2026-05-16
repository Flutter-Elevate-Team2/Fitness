import 'package:fitness_app/core/theming/app_colors.dart';
import 'package:fitness_app/core/theming/app_typography.dart';
import 'package:flutter/material.dart';


class SmartCoachIntroHeader extends StatelessWidget {
  final String userName;
  final VoidCallback onMenuTap;

  const SmartCoachIntroHeader({
    super.key,
    required this.userName,
    required this.onMenuTap,
  });

  @override
  Widget build(BuildContext context) {
    final greeting = 'Hi $userName ,'; 
    final subtitle = 'I Am Your Smart Coach'; 

    return Padding(
      padding: const EdgeInsets.only(top: 8),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [

          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Text(
                  greeting,
                  style: AppTypography.labelLarge.copyWith(
                    color: AppColors.white,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  subtitle,
                  style: AppTypography.titleLarge.copyWith(
                    color: AppColors.white,
                  ),
                ),
              ],
            ),
          ),


          GestureDetector(
            onTap: onMenuTap,
            child: const Icon(
              Icons.menu,
              color: AppColors.primary,
              size: 28,
            ),
          ),
        ],
      ),
    );
  }
}
