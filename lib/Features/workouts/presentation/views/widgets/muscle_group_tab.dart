import 'package:fitness_app/core/theming/app_colors.dart';
import 'package:flutter/material.dart';

class MuscleGroupTab extends StatelessWidget {
  final String title;
  final bool isSelected;
  final VoidCallback onTap;

  const MuscleGroupTab({
    super.key,
    required this.title,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        margin: const EdgeInsets.only(right: 12.0),
        padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 10.0),
        decoration: BoxDecoration(
          color: isSelected ? AppColors.primary : Colors.transparent,
          borderRadius: BorderRadius.circular(24.0),
        ),
        child: Center(
          child: Text(
            title,
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  color: AppColors.white,
                  fontWeight: isSelected ? FontWeight.bold : FontWeight.w500,
                ),
          ),
        ),
      ),
    );
  }
}
