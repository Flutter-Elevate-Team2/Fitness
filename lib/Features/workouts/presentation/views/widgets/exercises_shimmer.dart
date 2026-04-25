// ignore_for_file: deprecated_member_use

import 'package:fitness_app/core/theming/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';

// ─────────────────────────────────────────────
// 1. Shimmer for Difficulty Tabs
// ─────────────────────────────────────────────
class DifficultyTabsShimmer extends StatelessWidget {
  const DifficultyTabsShimmer({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.grayDark.withOpacity(1.0),
        borderRadius: const BorderRadius.only(
          topLeft: Radius.zero,
          topRight: Radius.zero,
          bottomLeft: Radius.circular(25),
          bottomRight: Radius.circular(25),
        ),
      ),
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
      child: SizedBox(
        height: 34,
        child: ListView.separated(
          scrollDirection: Axis.horizontal,
          itemCount: 4, // عرض 4 تابس وهميين
          padding: EdgeInsets.zero,
          separatorBuilder: (context, index) => const SizedBox(width: 24),
          itemBuilder: (context, index) {
            return Shimmer.fromColors(
              baseColor: AppColors.grayMid,
              highlightColor: AppColors.grayLight,
              child: Container(
                width: 80,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(30),
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}

// ─────────────────────────────────────────────
// 2. Shimmer for Exercises List
// ─────────────────────────────────────────────
class ExercisesListShimmer extends StatelessWidget {
  const ExercisesListShimmer({super.key});

  @override
  Widget build(BuildContext context) {
    return ListView.separated(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      padding: EdgeInsets.zero,
      itemCount: 4, // عرض 4 تمارين وهمية
      separatorBuilder: (context, index) {
        return Divider(
          color: Colors.white.withOpacity(0.08),
          height: 1,
          thickness: 1,
        );
      },
      itemBuilder: (context, index) {
        return Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 16.0),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              // Thumbnail Shimmer
              Shimmer.fromColors(
                baseColor: AppColors.grayMid,
                highlightColor: AppColors.grayLight,
                child: Container(
                  width: 80,
                  height: 80,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
              ),
              const SizedBox(width: 16),

              // Texts Shimmer
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Shimmer.fromColors(
                      baseColor: AppColors.grayMid,
                      highlightColor: AppColors.grayLight,
                      child: Container(height: 14, width: double.infinity, color: Colors.white),
                    ),
                    const SizedBox(height: 8),
                    Shimmer.fromColors(
                      baseColor: AppColors.grayMid,
                      highlightColor: AppColors.grayLight,
                      child: Container(height: 12, width: 120, color: Colors.white),
                    ),
                    const SizedBox(height: 8),
                    Shimmer.fromColors(
                      baseColor: AppColors.grayMid,
                      highlightColor: AppColors.grayLight,
                      child: Container(height: 12, width: double.infinity, color: Colors.white),
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 16),

              // Play Button Shimmer
              Shimmer.fromColors(
                baseColor: AppColors.grayMid,
                highlightColor: AppColors.grayLight,
                child: Container(
                  width: 32,
                  height: 32,
                  decoration: const BoxDecoration(
                    color: Colors.white,
                    shape: BoxShape.circle,
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
