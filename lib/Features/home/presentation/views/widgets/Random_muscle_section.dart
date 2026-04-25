import 'package:fitness_app/Features/home/presentation/view_model/home_state.dart';
import 'package:fitness_app/Features/home/presentation/view_model/home_view_model.dart';
import 'package:fitness_app/core/app_router/app_router.dart';
import 'package:fitness_app/core/theming/app_colors.dart';
import 'package:fitness_app/core/widget/shared_card.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:shimmer/shimmer.dart';

class RandomMusclesSection extends StatelessWidget {
  const RandomMusclesSection({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<HomeViewModel, HomeState>(
     buildWhen: (previous, current) =>
      previous.randomMuscles != current.randomMuscles ||
      previous.isLoading != current.isLoading,
      builder: (context, state) {
        final muscles = state.randomMuscles;

        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  "Recommendation To Day",
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 16,
                    fontWeight: FontWeight.w700,
                  ),
                ),

              ],
            ),
            const SizedBox(height: 10),

            if (state.isLoading && muscles.isEmpty)
              _buildShimmer()
            else
              SizedBox(
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
              ),
          ],
        );
      },
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
