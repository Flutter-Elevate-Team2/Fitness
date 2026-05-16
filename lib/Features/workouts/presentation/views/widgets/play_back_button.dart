import 'package:fitness_app/core/theming/app_colors.dart';
import 'package:flutter/material.dart';

class PlayButton extends StatelessWidget {
  final VoidCallback? onTap;

  const PlayButton({super.key, required this.onTap});

  @override
  Widget build(BuildContext context) {
    final bool isEnabled = onTap != null;

    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 32,
        height: 32,
        padding: const EdgeInsets.all(2),
        decoration: BoxDecoration(
          color: isEnabled ? AppColors.primary : AppColors.grayMid,
          shape: BoxShape.circle,
        ),
        child: Icon(
          Icons.play_arrow_rounded,
          color: isEnabled ? AppColors.playIconColor : AppColors.light400,
          size: 20,
        ),
      ),
    );
  }
}
