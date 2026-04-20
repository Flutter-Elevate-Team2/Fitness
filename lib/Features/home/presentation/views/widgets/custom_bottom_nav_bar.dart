import 'package:fitness_app/Features/home/presentation/views/widgets/custom_nav_item_widget.dart';
import 'package:fitness_app/core/extension/context_extention.dart';
import 'package:fitness_app/core/theming/app_colors.dart';
import 'package:fitness_app/gen/assets.gen.dart';
import 'package:flutter/material.dart';

class CustomBottomNavBar extends StatelessWidget {
  final int currentIndex;
  final ValueChanged<int> onTap;

  const CustomBottomNavBar({
    super.key,
    required this.currentIndex,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final items = [
      NavItem(icon: Assets.icons.explore.path, label: context.l10n.explore),
      NavItem(icon: Assets.icons.chatAi.path, label: context.l10n.chatAi),
      NavItem(icon: Assets.icons.workouts.path, label: context.l10n.workouts),
      NavItem(icon: Assets.icons.profile.path, label: context.l10n.profile),
    ];

    return Container(
      margin: const EdgeInsets.only(left: 20, right: 20, bottom: 24),
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 12),
      decoration: BoxDecoration(
        color: AppColors.grayDark,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: AppColors.grayMid.withValues(alpha: 0.4),
          width: 0.5,
        ),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: List.generate(items.length, (index) {
          final isSelected = currentIndex == index;
          return CustomNavItemWidget(
            item: items[index],
            isSelected: isSelected,
            onTap: () => onTap(index),
          );
        }),
      ),
    );
  }


}

class NavItem {
  final String icon;
  final String label;

  const NavItem({required this.icon, required this.label});
}



