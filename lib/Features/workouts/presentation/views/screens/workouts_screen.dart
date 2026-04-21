import 'dart:ui';
import 'package:fitness_app/core/widget/shared_scaffold.dart';
import 'package:fitness_app/gen/assets.gen.dart';
import 'package:fitness_app/Features/workouts/presentation/view_model/workouts_events.dart';
import 'package:fitness_app/Features/workouts/presentation/view_model/workouts_states.dart';
import 'package:fitness_app/Features/workouts/presentation/view_model/workouts_view_model.dart';
import 'package:fitness_app/Features/workouts/presentation/views/widgets/muscle_card.dart';
import 'package:fitness_app/Features/workouts/presentation/views/widgets/muscle_group_tab.dart';
import 'package:fitness_app/core/di/di.dart';
import 'package:fitness_app/core/theming/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shimmer/shimmer.dart';

class WorkoutsScreen extends StatelessWidget {
  const WorkoutsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => getIt<WorkoutsViewModel>()..doIntent(FetchMuscleGroupsEvent()),
      child: const _WorkoutsScreenBody(),
    );
  }
}

class _WorkoutsScreenBody extends StatefulWidget {
  const _WorkoutsScreenBody();

  @override
  State<_WorkoutsScreenBody> createState() => _WorkoutsScreenBodyState();
}

class _WorkoutsScreenBodyState extends State<_WorkoutsScreenBody> {
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
            if (groupsData != null && groupsData.isNotEmpty && selectedGroupId == null) {
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
                    child: _buildTabsSection(state),
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
                  sliver: _buildGridSection(state),
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

  Widget _buildTabsSection(WorkoutsStates state) {
    final groupsState = state.muscleGroupsState;

    if (groupsState.isLoading && (groupsState.data == null || groupsState.data!.isEmpty)) {
      return ListView.builder(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 20.0),
        itemCount: 5,
        itemBuilder: (context, index) {
          return Shimmer.fromColors(
            baseColor: AppColors.grayMid,
            highlightColor: AppColors.grayLight,
            child: Container(
              margin: const EdgeInsets.only(right: 12.0),
              width: 90,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(24.0),
              ),
            ),
          );
        },
      );
    } else if (groupsState.errorMessage != null && (groupsState.data == null || groupsState.data!.isEmpty)) {
      return Center(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20.0),
          child: Text(
            groupsState.errorMessage!,
            style: const TextStyle(color: AppColors.red),
          ),
        ),
      );
    } else if (groupsState.data != null) {
      final groups = groupsState.data!;
      return ListView.builder(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 20.0),
        itemCount: groups.length,
        itemBuilder: (context, index) {
          final group = groups[index];
          return MuscleGroupTab(
            title: group.name,
            isSelected: selectedGroupId == group.id,
            onTap: () {
              if (selectedGroupId != group.id) {
                setState(() {
                  selectedGroupId = group.id;
                });
                context.read<WorkoutsViewModel>().doIntent(
                  FetchMusclesByGroupEvent(group.id),
                );
              }
            },
          );
        },
      );
    } else {
      return const SizedBox.shrink();
    }
  }

  Widget _buildGridSection(WorkoutsStates state) {
    final musclesState = state.musclesState;

    if (musclesState.isLoading && (musclesState.data == null || musclesState.data!.isEmpty)) {
      return SliverGrid(
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          mainAxisSpacing: 16.0,
          crossAxisSpacing: 16.0,
          childAspectRatio: 0.9,
        ),
        delegate: SliverChildBuilderDelegate(
          (context, index) {
            return Shimmer.fromColors(
              baseColor: AppColors.grayMid,
              highlightColor: AppColors.grayLight,
              child: Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(16.0),
                ),
              ),
            );
          },
          childCount: 6,
        ),
      );
    } else if (musclesState.errorMessage != null && (musclesState.data == null || musclesState.data!.isEmpty)) {
      return SliverToBoxAdapter(
        child: Center(
          child: Padding(
            padding: const EdgeInsets.all(24.0),
            child: Text(
              musclesState.errorMessage!,
              style: const TextStyle(color: AppColors.red),
              textAlign: TextAlign.center,
            ),
          ),
        ),
      );
    } else if (musclesState.data != null) {
      final muscles = musclesState.data!;
      if (muscles.isEmpty) {
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
    } else {
      return const SliverToBoxAdapter(
        child: SizedBox.shrink(),
      );
    }
  }
}
