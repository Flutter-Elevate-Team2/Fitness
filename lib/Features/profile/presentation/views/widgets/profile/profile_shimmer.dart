import 'package:fitness_app/core/theming/app_colors.dart';
import 'package:fitness_app/core/widget/shared_container.dart';
import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';

class ProfilePageShimmer extends StatelessWidget {
  const ProfilePageShimmer({super.key});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: SingleChildScrollView(
        child: Column(
          children: [
            const SizedBox(height: 40),

            /// 🔹 Profile Image
            Shimmer.fromColors(
              baseColor: AppColors.grayMid,
              highlightColor: AppColors.grayLight,
              child: const CircleAvatar(
                radius: 50,
                backgroundColor: Colors.white,
              ),
            ),

            const SizedBox(height: 16),

            /// 🔹 Name
            Shimmer.fromColors(
              baseColor: AppColors.grayMid,
              highlightColor: AppColors.grayLight,
              child: Container(
                width: 220,
                height: 25,
                decoration: BoxDecoration(
                  color: AppColors.white,
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
            ),

            const SizedBox(height: 30),

            /// 🔹 Settings Container
            Padding(
              padding: const EdgeInsets.all(14),
              child: SharedContainer(
                padding: const EdgeInsets.all(8),
                child: Column(
                  children: List.generate(6, (index) {
                    return Padding(
                      padding: const EdgeInsets.symmetric(vertical: 15),
                      child: Shimmer.fromColors(
                        baseColor: AppColors.grayMid,
                        highlightColor: AppColors.grayLight,
                        child: Row(
                          children: [
                            /// icon
                            Container(
                              width: 24,
                              height: 24,
                              decoration: BoxDecoration(
                                color: AppColors.white,
                                borderRadius: BorderRadius.circular(6),
                              ),
                            ),

                            const SizedBox(width: 12),

                            /// title
                            Expanded(
                              child: Container(
                                height: 14,
                                decoration: BoxDecoration(
                                  color: AppColors.white,
                                  borderRadius: BorderRadius.circular(6),
                                ),
                              ),
                            ),

                            const SizedBox(width: 12),

                            /// arrow / switch placeholder
                            Container(
                              width: 30,
                              height: 24,
                              decoration: BoxDecoration(
                                color: AppColors.white,
                                borderRadius: BorderRadius.circular(6),
                              ),
                            ),
                          ],
                        ),
                      ),
                    );
                  }),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
