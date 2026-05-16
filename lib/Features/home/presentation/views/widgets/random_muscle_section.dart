import 'package:fitness_app/Features/home/domain/entities/home_section.dart';
import 'package:fitness_app/core/base_response/base_response.dart';
import 'package:fitness_app/Features/workouts/domain/entities/random_muscles_entity.dart';
import 'package:fitness_app/core/app_router/app_router.dart';
import 'package:fitness_app/core/extension/context_extention.dart';
import 'package:fitness_app/core/theming/app_colors.dart';
import 'package:fitness_app/core/widget/shared_card.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:shimmer/shimmer.dart';

class RandomMusclesSection extends StatelessWidget {
  final BaseResponse<HomeSection>? response;

  const RandomMusclesSection({super.key, this.response});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          context.l10n.recommendationToday,
          style: const TextStyle(
            color: AppColors.white,
            fontSize: 16,
            fontWeight: FontWeight.w700,
          ),
        ),
        const SizedBox(height: 10),
        _buildContent(context),
      ],
    );
  }

  Widget _buildContent(BuildContext context) {
    return switch (response) {
      null => _buildShimmer(),
      SuccessResponse(data: var section) => _buildList(
        (section as RandomMuscleSection).muscles,
      ),

      ErrorResponse(errorMessage: var msg) => SizedBox(
        height: 150,
        child: Center(
          child: Text(
            msg,
            style: const TextStyle(color: AppColors.red, fontSize: 13),
          ),
        ),
      ),
    };
  }

  Widget _buildList(List<RandomMusclesEntity> muscles) {
    if (muscles.isEmpty) return const SizedBox(height: 150);

    return SizedBox(
      height: 130,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: muscles.length,
        itemBuilder: (context, index) {
          final muscle = muscles[index];
          return SharedCard(
            useCachedImage: true,
            title: muscle.name,
            imageUrl: muscle.image,
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
            height: 130,
            borderRadius: 22,
            margin: const EdgeInsets.only(right: 12),
          );
        },
      ),
    );
  }

  Widget _buildShimmer() {
    return SizedBox(
      height: 150,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: 4,
        itemBuilder: (context, index) {
          return Shimmer.fromColors(
            baseColor: AppColors.grayMid,
            highlightColor: AppColors.grayLight,
            child: Container(
              width: 130,
              height: 150,
              margin: const EdgeInsets.only(right: 12),
              decoration: BoxDecoration(
                color: AppColors.white,
                borderRadius: BorderRadius.circular(16),
              ),
            ),
          );
        },
      ),
    );
  }
}
