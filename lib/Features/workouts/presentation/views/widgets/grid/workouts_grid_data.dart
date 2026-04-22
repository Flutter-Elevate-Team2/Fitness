import 'package:fitness_app/Features/workouts/domain/entities/muscle_entity.dart';
import 'package:fitness_app/Features/workouts/presentation/views/widgets/muscle_card.dart';
import 'package:flutter/material.dart';

class WorkoutsGridData extends StatelessWidget {
  final List<MuscleEntity> muscles;

  const WorkoutsGridData({
    super.key,
    required this.muscles,
  });

  @override
  Widget build(BuildContext context) {
    return SliverGrid(
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        mainAxisSpacing: 16.0,
        crossAxisSpacing: 16.0,
        childAspectRatio: 0.9,
      ),
      delegate: SliverChildBuilderDelegate(
        (context, index) {
          return MuscleCard(muscle: muscles[index]);
        },
        childCount: muscles.length,
      ),
    );
  }
}
