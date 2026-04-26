import 'package:fitness_app/Features/home/domain/entities/home_section.dart';
import 'package:fitness_app/core/base_response/base_response.dart';
import 'package:fitness_app/Features/workouts/domain/entities/random_muscles_entity.dart';
import 'package:fitness_app/core/app_router/app_router.dart';
import 'package:fitness_app/core/theming/app_colors.dart';
import 'package:fitness_app/core/widget/shared_card.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:shimmer/shimmer.dart';

class RandomMusclesSection extends StatelessWidget {
  // بنستقبل الـ Response اللي شايل الـ Section
  final BaseResponse<HomeSection>? response;

  const RandomMusclesSection({super.key, this.response});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          "Recommendation To Day",
          style: TextStyle(
            color: Colors.white,
            fontSize: 16,
            fontWeight: FontWeight.w700,
          ),
        ),
        const SizedBox(height: 10),

        /// هندلة المحتوى بناءً على الـ Response
        _buildContent(),
      ],
    );
  }

  Widget _buildContent() {
    return switch (response) {
    // 1. حالة التحميل
      null => _buildShimmer(),

    // 2. حالة النجاح (الـ Casting لنوع الـ RandomMuscleSection)
      SuccessResponse(data: var section) => _buildList((section as RandomMuscleSection).muscles),

    // 3. حالة الفشل
      ErrorResponse(errorMessage: var msg) => SizedBox(
        height: 150,
        child: Center(
          child: Text(msg, style: const TextStyle(color: Colors.redAccent, fontSize: 13)),
        ),
      ),
    };
  }

  Widget _buildList(List<RandomMusclesEntity> muscles) {
    if (muscles.isEmpty) return const SizedBox(height: 150);

    return SizedBox(
      height: 150,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: muscles.length,
        itemBuilder: (context, index) {
          final muscle = muscles[index];
          return SharedCard(
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
            height: 150,
            borderRadius: 16,
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
                color: Colors.white,
                borderRadius: BorderRadius.circular(16),
              ),
            ),
          );
        },
      ),
    );
  }
}