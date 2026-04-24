import 'package:fitness_app/core/theming/app_colors.dart';
import 'package:flutter/material.dart';

class WorkoutsGridEmpty extends StatelessWidget {
  const WorkoutsGridEmpty({super.key});

  @override
  Widget build(BuildContext context) {
    return const SliverToBoxAdapter(
      child: Center(
        child: Padding(
          padding: EdgeInsets.all(24.0),
          child: Text(
            'No exercise routines found for this muscle group.',
            style: TextStyle(color: AppColors.white),
          ),
        ),
      ),
    );
  }
}
