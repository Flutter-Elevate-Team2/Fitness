import 'package:fitness_app/core/theming/app_colors.dart';
import 'package:fitness_app/core/widget/shared_container.dart';
import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';

class ChangePasswordShimmer extends StatelessWidget {
  const ChangePasswordShimmer({super.key});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: SingleChildScrollView(
        child: Column(
          children: [
            const SizedBox(height: 200),

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

            const SizedBox(height: 16),

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
                  children: List.generate(3, (index) {
                    return Padding(
                      padding: const EdgeInsets.symmetric(vertical: 20),
                      child: Shimmer.fromColors(
                        baseColor: AppColors.grayMid,
                        highlightColor: AppColors.grayLight,
                        child: Row(
                          children: [

                            /// title
                            Expanded(
                              child: Container(
                                height: 34,
                                decoration: BoxDecoration(
                                  color: AppColors.white,
                                  borderRadius: BorderRadius.circular(6),
                                ),
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
