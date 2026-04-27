import 'package:fitness_app/Features/home/domain/entities/home_section.dart';
import 'package:fitness_app/Features/home/presentation/view_model/home_view_model.dart';
import 'package:fitness_app/core/base_response/base_response.dart';
import 'package:fitness_app/core/extension/context_extention.dart';
import 'package:fitness_app/core/theming/app_colors.dart';
import 'package:fitness_app/core/widget/shared_card.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shimmer/shimmer.dart';
import 'package:go_router/go_router.dart';
import 'package:fitness_app/core/app_router/app_router.dart';

class UpcomingWorkoutsSection extends StatelessWidget {
  final BaseResponse<HomeSection>? response;

  final void Function({String? selectedGroupId})? onSeeAllTapped;

  const UpcomingWorkoutsSection({
    super.key,
    required this.response,
    this.onSeeAllTapped,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        _buildHeader(context),
        const SizedBox(height: 12),
        _buildContent(context),
      ],
    );
  }

  Widget _buildHeader(BuildContext context) {
    String? currentId;
    if (response is SuccessResponse<HomeSection>) {
      currentId =
          (response as SuccessResponse<HomeSection>).data
              is UpcomingWorkoutsSectionData
          ? ((response as SuccessResponse<HomeSection>).data
                    as UpcomingWorkoutsSectionData)
                .selectedGroupId
          : null;
    }

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          context.l10n.upcomingWorkouts,
          style: const TextStyle(
            color: AppColors.white,
            fontSize: 16,
            fontWeight: FontWeight.w700,
          ),
        ),
        TextButton(
          onPressed: () {
            if (onSeeAllTapped != null) {
              onSeeAllTapped!(selectedGroupId: currentId);
            }
          },
          child: Text(
            context.l10n.seeAll,
            style: const TextStyle(color: AppColors.primary),
          ),
        ),
      ],
    );
  }

  Widget _buildContent(BuildContext context) {
    return switch (response) {
      null => Column(
        children: [
          _buildTabsShimmer(),
          const SizedBox(height: 12),
          _buildCardsShimmer(),
        ],
      ),

      SuccessResponse(data: var section) => _buildSuccessUI(
        context,
        section as UpcomingWorkoutsSectionData,
      ),

      ErrorResponse(errorMessage: var msg) => Container(
          height: 160,
          alignment: Alignment.center,
          child: Text(msg, style: const TextStyle(color: AppColors.red)),
        ),
    };
  }

  Widget _buildSuccessUI(
    BuildContext context,
    UpcomingWorkoutsSectionData data,
  ) {
    return Column(
      children: [
        /// Tabs (Muscle Groups)
        SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: Row(
            children: data.muscleGroups.map((group) {
              bool isSelected = data.selectedGroupId == group.id;
              return GestureDetector(
                onTap: () {
                  context.read<HomeViewModel>().changeMuscleGroup(group.id);
                },
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 300),
                  margin: const EdgeInsets.only(right: 12),
                  padding: const EdgeInsets.symmetric(
                    horizontal: 20,
                    vertical: 10,
                  ),
                  decoration: BoxDecoration(
                    color: isSelected ? AppColors.primary : Colors.transparent,
                    borderRadius: BorderRadius.circular(20),
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
          child: data.currentGroupMuscles.isEmpty
              ? _buildCardsShimmer()
              : ListView.builder(
                  scrollDirection: Axis.horizontal,
                  itemCount: data.currentGroupMuscles.length,
                  itemBuilder: (context, index) {
                    final muscle = data.currentGroupMuscles[index];
                    return SharedCard(
                      useCachedImage: true,
                      title: muscle.name,
                      imageUrl: muscle.image ?? "",
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
                      width: 130,
                      height: 160,
                      margin: const EdgeInsets.only(right: 12),
                    );
                  },
                ),
        ),
      ],
    );
  }

  /// --- SHIMMERS ---

  Widget _buildTabsShimmer() {
    return SizedBox(
      height: 40,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: 5,
        itemBuilder: (context, index) {
          return Shimmer.fromColors(
            baseColor: AppColors.grayMid,
            highlightColor: AppColors.grayLight,
            child: Container(
              margin: const EdgeInsets.only(right: 12),
              width: 90,
              decoration: BoxDecoration(
                color: AppColors.white,
                borderRadius: BorderRadius.circular(20),
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildCardsShimmer() {
    return SizedBox(
      height: 160,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: 4,
        itemBuilder: (context, index) {
          return Shimmer.fromColors(
            baseColor: AppColors.grayMid,
            highlightColor: AppColors.grayLight,
            child: Container(
              width: 130,
              height: 160,
              margin: const EdgeInsets.only(right: 12),
              decoration: BoxDecoration(
                color: AppColors.white,
                borderRadius: BorderRadius.circular(20),
              ),
            ),
          );
        },
      ),
    );
  }
}
