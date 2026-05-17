import 'package:fitness_app/Features/home/presentation/views/widgets/custom_bottom_nav_bar.dart';
import 'package:fitness_app/core/theming/app_colors.dart';
import 'package:flutter/material.dart';

class CustomNavItemWidget extends StatelessWidget {
  final NavItem item;
  final bool isSelected;
  final VoidCallback onTap;

  const CustomNavItemWidget({
    super.key,
    required this.item,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      behavior: HitTestBehavior.opaque,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 250),
        curve: Curves.easeInOut,
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 4),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Image.asset(
              item.icon,
              width: 24,
              height: 24,
              color: isSelected ? AppColors.primary : AppColors.light500,
            ),
            if (isSelected) ...[
              const SizedBox(height: 4),
              Text(
                item.label,
                style: const TextStyle(
                  fontSize: 10,
                  fontWeight: FontWeight.w600,
                  color: AppColors.primary,
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}
