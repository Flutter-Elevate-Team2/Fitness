import 'package:fitness_app/core/theming/app_colors.dart';
import 'package:fitness_app/core/theming/app_theming.dart';
import 'package:flutter/material.dart';

class SharedTextItem extends StatelessWidget {
  const SharedTextItem({
    super.key,
    required this.title,
    this.subTitle,
  });

  final String title;
  final String? subTitle;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: SizedBox(
        width: double.infinity,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              title.toUpperCase(),
              style: AppTheme.darkTheme.textTheme.titleLarge?.copyWith(
                color: AppColors.white,
                height: 1.3,
              ),
            ),
            if (subTitle != null && subTitle!.isNotEmpty) ...[
              const SizedBox(height: 8),
              FittedBox(
                fit: BoxFit.scaleDown,
                alignment: Alignment.centerLeft,
                child: Text(
                  subTitle!,
                  style: AppTheme.darkTheme.textTheme.bodyLarge?.copyWith(
                    color: AppColors.white,
                  ),
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}
