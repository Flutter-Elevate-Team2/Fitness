import 'package:fitness_app/Features/workouts/domain/entities/muscle_entity.dart';
import 'package:fitness_app/Features/workouts/presentation/views/widgets/muscle_card.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:fitness_app/core/app_router/app_router.dart';

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
          final muscle = muscles[index];

          return MuscleCard(
            muscle: muscle,
            onTap: () {
              context.pushNamed(
                Routes.exercisesName,
                extra: {
                  'primeMoverMuscleId': muscle.id,
                  'title': muscle.name,
                  'image': muscle.image,
                },
              );
            },
          );
        },
        childCount: muscles.length,
      ),
    );
  }
}
