import 'dart:ui';

import 'package:fitness_app/Features/workouts/presentation/view_models/workouts_events.dart';
import 'package:fitness_app/Features/workouts/presentation/view_models/workouts_states.dart';
import 'package:fitness_app/Features/workouts/presentation/view_models/workouts_view_model.dart';
import 'package:fitness_app/Features/workouts/presentation/views/widgets/grid/workouts_grid.dart';
import 'package:fitness_app/Features/workouts/presentation/views/widgets/tabs/workouts_tabs_list.dart';
import 'package:fitness_app/core/theming/app_colors.dart';
import 'package:fitness_app/core/widget/shared_scaffold.dart';
import 'package:fitness_app/gen/assets.gen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class WorkoutsScreenBody extends StatefulWidget {
  const WorkoutsScreenBody({super.key});

  @override
  State<WorkoutsScreenBody> createState() => WorkoutsScreenBodyState();
}

class WorkoutsScreenBodyState extends State<WorkoutsScreenBody> {
  String? selectedGroupId;

  @override
  Widget build(BuildContext context) {
    return SharedScaffold(
      backgroundImage: Assets.images.homeBackground.path,
      showBackButton: false,
      body: Stack(
        children: [
          Positioned.fill(
            child: BackdropFilter(
              filter: ImageFilter.blur(sigmaX: 12.5, sigmaY: 12.5),
              child: Container(color: const Color(0x801A1A1A)),
            ),
          ),
          Positioned.fill(
            child: SafeArea(
              child: BlocConsumer<WorkoutsViewModel, WorkoutsStates>(
                listenWhen: (previous, current) =>
                    previous.muscleGroupsState != current.muscleGroupsState,
                listener: (context, state) {
                  final groupsData = state.muscleGroupsState.data;
                  if (groupsData != null &&
                      groupsData.isNotEmpty &&
                      selectedGroupId == null) {
                    final firstGroup = groupsData.first;
                    setState(() {
                      selectedGroupId = firstGroup.id;
                    });
                    context.read<WorkoutsViewModel>().doIntent(
                          FetchMusclesByGroupEvent(firstGroup.id),
                        );
                  }
                },
                builder: (context, state) {
                  return CustomScrollView(
                    slivers: [
                      const SliverToBoxAdapter(
                        child: Padding(
                          padding: EdgeInsets.only(top: 24.0, bottom: 20.0),
                          child: Center(
                            child: Text(
                              'Workouts',
                              style: TextStyle(
                                fontSize: 24,
                                fontWeight: FontWeight.bold,
                                color: AppColors.white,
                              ),
                            ),
                          ),
                        ),
                      ),

                      // Tabs Section
                      SliverToBoxAdapter(
                        child: SizedBox(
                          height: 48,
                          child: WorkoutsTabsList(
                            muscleGroupsState: state.muscleGroupsState,
                            selectedGroupId: selectedGroupId,
                            onTabSelected: (id) {
                              if (selectedGroupId != id) {
                                setState(() {
                                  selectedGroupId = id;
                                });
                                context.read<WorkoutsViewModel>().doIntent(
                                      FetchMusclesByGroupEvent(id),
                                    );
                              }
                            },
                          ),
                        ),
                      ),

                      const SliverToBoxAdapter(
                        child: SizedBox(height: 24.0),
                      ),

                      // Grid Section
                      SliverPadding(
                        padding: const EdgeInsets.only(
                          left: 20.0,
                          right: 20.0,
                          bottom: 100.0, // Floating nav bar padding
                        ),
                        sliver: WorkoutsGrid(
                          musclesState: state.musclesState,
                        ),
                      ),
                    ],
                  );
                },
              ),
            ),
          ),
        ],
      ),
    );
  }
}
