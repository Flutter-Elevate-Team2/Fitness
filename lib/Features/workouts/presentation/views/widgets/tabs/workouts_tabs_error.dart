import 'package:fitness_app/core/theming/app_colors.dart';
import 'package:flutter/material.dart';

class WorkoutsTabsError extends StatelessWidget {
  final String errorMessage;

  const WorkoutsTabsError({
    super.key,
    required this.errorMessage,
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20.0),
        child: Text(
          errorMessage,
          style: const TextStyle(color: AppColors.red),
        ),
      ),
    );
  }
}
