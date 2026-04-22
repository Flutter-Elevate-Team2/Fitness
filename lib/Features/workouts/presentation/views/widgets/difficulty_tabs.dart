import 'package:flutter/material.dart';

import '../../../../../../core/theming/app_colors.dart';
import '../../../domain/entities/difficulty_level_entity.dart';

class DifficultyTabsWidget extends StatelessWidget {
  final List<DifficultyLevelEntity> levels;
  final String selectedLevelId;
  final Function(String) onTabChanged;

  const DifficultyTabsWidget({
    super.key,
    required this.levels,
    required this.selectedLevelId,
    required this.onTabChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.grayDark.withOpacity(1.0),
        borderRadius: const BorderRadius.only(
          topLeft: Radius.zero,
          topRight: Radius.zero,
          bottomLeft: Radius.circular(25),
          bottomRight: Radius.circular(25),
        ),
      ),
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
      child: SizedBox(
        height: 34,
        child: ListView.separated(
          scrollDirection: Axis.horizontal,
          itemCount: levels.length,
          padding: EdgeInsets.zero,
          separatorBuilder: (context, index) => const SizedBox(width: 24),
          itemBuilder: (context, index) {
            final level = levels[index];
            final isSelected = level.id == selectedLevelId;

            return GestureDetector(
              onTap: () => onTabChanged(level.id),
              child: Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 20,
                  vertical: 0,
                ),
                decoration: BoxDecoration(
                  color: isSelected ? AppColors.primary : Colors.transparent,
                  borderRadius: BorderRadius.circular(30),
                ),
                alignment: Alignment.center,
                child: Text(
                  level.name,
                  style: Theme.of(context).textTheme.labelLarge?.copyWith(
                    color: isSelected ? AppColors.white : AppColors.light400,
                    fontWeight: isSelected ? FontWeight.w700 : FontWeight.w700,
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
