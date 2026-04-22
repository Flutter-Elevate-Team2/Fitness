import 'package:fitness_app/Features/workouts/domain/entities/muscle_group_entity.dart';
import 'package:fitness_app/Features/workouts/presentation/views/widgets/tabs/workouts_tabs_data.dart';
import 'package:fitness_app/Features/workouts/presentation/views/widgets/tabs/workouts_tabs_error.dart';
import 'package:fitness_app/Features/workouts/presentation/views/widgets/tabs/workouts_tabs_shimmer.dart';
import 'package:fitness_app/core/base_state/base_state.dart';
import 'package:flutter/material.dart';

class WorkoutsTabsList extends StatelessWidget {
  final BaseState<List<MuscleGroupEntity>> muscleGroupsState;
  final String? selectedGroupId;
  final ValueChanged<String> onTabSelected;

  const WorkoutsTabsList({
    super.key,
    required this.muscleGroupsState,
    required this.selectedGroupId,
    required this.onTabSelected,
  });

  @override
  Widget build(BuildContext context) {
    if (muscleGroupsState.isLoading &&
        (muscleGroupsState.data == null || muscleGroupsState.data!.isEmpty)) {
      return const WorkoutsTabsShimmer();
    }

    if (muscleGroupsState.errorMessage != null &&
        (muscleGroupsState.data == null || muscleGroupsState.data!.isEmpty)) {
      return WorkoutsTabsError(errorMessage: muscleGroupsState.errorMessage!);
    }

    if (muscleGroupsState.data != null) {
      return WorkoutsTabsData(
        groups: muscleGroupsState.data!,
        selectedGroupId: selectedGroupId,
        onTabSelected: onTabSelected,
      );
    }

    return const SizedBox.shrink();
  }
}
