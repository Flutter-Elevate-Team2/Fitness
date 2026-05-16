import 'package:fitness_app/core/theming/app_colors.dart';
import 'package:flutter/material.dart';

class WorkoutsGridError extends StatelessWidget {
  final String errorMessage;

  const WorkoutsGridError({
    super.key,
    required this.errorMessage,
  });

  @override
  Widget build(BuildContext context) {
    return SliverToBoxAdapter(
      child: Center(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Text(
            errorMessage,
            style: const TextStyle(color: AppColors.red),
            textAlign: TextAlign.center,
          ),
        ),
      ),
    );
  }
}
