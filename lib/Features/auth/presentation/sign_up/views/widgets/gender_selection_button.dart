import 'package:fitness_app/core/theming/app_colors.dart';
import 'package:flutter/material.dart';

class GenderSelectionButton extends StatelessWidget {
  final String label;
  final String imagePath;
  final bool isSelected;
  final VoidCallback onTap;

  const GenderSelectionButton({
    super.key,
    required this.label,
    required this.imagePath,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final Color activeColor =
        isSelected ? AppColors.primary : AppColors.white;

    return GestureDetector(
      onTap: onTap,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          /// ── Circular Icon ──
          AnimatedContainer(
            duration: const Duration(milliseconds: 250),
            curve: Curves.easeInOut,
            width: 120,
            height: 120,
            child: Padding(
              padding: const EdgeInsets.all(24),
              child: Image.asset(
                imagePath,
                color: activeColor,
                fit: BoxFit.contain,
              ),
            ),
          ),
          const SizedBox(height: 10),

          /// ── Label ──
          Text(
            label,
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  color: activeColor,
                ),
          ),
        ],
      ),
    );
  }
}
