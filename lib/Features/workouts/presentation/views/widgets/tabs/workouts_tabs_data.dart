import 'package:fitness_app/Features/workouts/domain/entities/muscle_group_entity.dart';
import 'package:fitness_app/Features/workouts/presentation/views/widgets/muscle_group_tab.dart';
import 'package:flutter/material.dart';

class WorkoutsTabsData extends StatelessWidget {
  final List<MuscleGroupEntity> groups;
  final String? selectedGroupId;
  final ValueChanged<String> onTabSelected;

  const WorkoutsTabsData({
    super.key,
    required this.groups,
    required this.selectedGroupId,
    required this.onTabSelected,
  });

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      scrollDirection: Axis.horizontal,
      padding: const EdgeInsets.symmetric(horizontal: 20.0),
      itemCount: groups.length,
      itemBuilder: (context, index) {
        final group = groups[index];
        return MuscleGroupTab(
          title: group.name,
          isSelected: selectedGroupId == group.id,
          onTap: () => onTabSelected(group.id),
        );
      },
    );
  }
}
