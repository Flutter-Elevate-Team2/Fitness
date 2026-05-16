import 'package:fitness_app/Features/workouts/domain/entities/muscle_entity.dart';
import 'package:fitness_app/Features/workouts/presentation/views/widgets/grid/workouts_grid_data.dart';
import 'package:fitness_app/Features/workouts/presentation/views/widgets/grid/workouts_grid_empty.dart';
import 'package:fitness_app/Features/workouts/presentation/views/widgets/grid/workouts_grid_error.dart';
import 'package:fitness_app/Features/workouts/presentation/views/widgets/grid/workouts_grid_shimmer.dart';
import 'package:fitness_app/core/base_state/base_state.dart';
import 'package:flutter/material.dart';

class WorkoutsGrid extends StatelessWidget {
  final BaseState<List<MuscleEntity>> musclesState;

  const WorkoutsGrid({
    super.key,
    required this.musclesState,
  });

  @override
  Widget build(BuildContext context) {
    if (musclesState.isLoading &&
        (musclesState.data == null || musclesState.data!.isEmpty)) {
      return const WorkoutsGridShimmer();
    }

    if (musclesState.errorMessage != null &&
        (musclesState.data == null || musclesState.data!.isEmpty)) {
      return WorkoutsGridError(errorMessage: musclesState.errorMessage!);
    }

    if (musclesState.data != null) {
      final muscles = musclesState.data!;
      if (muscles.isEmpty) {
        return const WorkoutsGridEmpty();
      }
      return WorkoutsGridData(muscles: muscles);
    }

    return const SliverToBoxAdapter(child: SizedBox.shrink());
  }
}
