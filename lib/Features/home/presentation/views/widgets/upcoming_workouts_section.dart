import 'package:fitness_app/Features/home/presentation/view_model/home_state.dart';
import 'package:fitness_app/Features/home/presentation/view_model/home_view_model.dart';
import 'package:fitness_app/core/extension/context_extention.dart';
import 'package:fitness_app/core/theming/app_colors.dart';
import 'package:fitness_app/core/widget/shared_card.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class UpcomingWorkoutsSection extends StatelessWidget {
  const UpcomingWorkoutsSection({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<HomeViewModel, HomeState>(
      buildWhen: (previous, current) =>
      previous.muscleGroups != current.muscleGroups ||
      previous.currentGroupMuscles != current.currentGroupMuscles ||
      previous.selectedGroupId != current.selectedGroupId,
      builder: (context, state) {
        return Column(
          children: [
            /// Header
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  "Upcoming Workouts",
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 16,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                TextButton(
                  onPressed: () {},
                  child: Text(
                    context.l10n.seeAll,
                    style: const TextStyle(color: AppColors.primary),
                  ),
                ),
              ],
            ),

            /// Tabs (Muscle Groups)
            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                children: state.muscleGroups.map((group) {
                  bool isSelected = state.selectedGroupId == group.id;
                  return GestureDetector(
                    onTap: () => context
                        .read<HomeViewModel>()
                        .changeMuscleGroup(group.id),
                    child: AnimatedContainer(
                      duration: const Duration(milliseconds: 300),
                      margin: const EdgeInsets.only(right: 12),
                      padding: const EdgeInsets.symmetric(
                        horizontal: 20,
                        vertical: 10,
                      ),
                      decoration: BoxDecoration(
                        color: isSelected
                            ? AppColors.primary
                            : Colors.transparent,
                        borderRadius: BorderRadius.circular(20),
                        border: isSelected
                            ? null
                            : Border.all(
                                color: Colors.white.withValues(alpha: 0.3),
                                width: 1,
                              ),
                      ),
                      child: Text(
                        group.name,
                        style: const TextStyle(
                          color: AppColors.white,
                          fontSize: 12,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  );
                }).toList(),
              ),
            ),

            const SizedBox(height: 12),

            /// Muscles List
            SizedBox(
              height: 160,
              child: ListView.builder(
                scrollDirection: Axis.horizontal,
                itemCount: state.currentGroupMuscles.length,
                itemBuilder: (context, index) {
                  final muscle = state.currentGroupMuscles[index];
                  return SharedCard(
                    title: muscle.name,
                    imageUrl: muscle.image ?? "",
                    onTap: () {
                      /* Navigate to Details */
                    },
                    width: 130,
                    height: 160,
                    margin: const EdgeInsets.only(right: 12),
                  );
                },
              ),
            ),
          ],
        );
      },
    );
  }
}
