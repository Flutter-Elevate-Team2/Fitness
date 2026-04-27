import 'package:fitness_app/Features/home/domain/entities/home_section.dart';
import 'package:fitness_app/Features/home/domain/entities/popular_tranning_entity.dart';
import 'package:fitness_app/core/base_response/base_response.dart';
import 'package:fitness_app/core/app_router/app_router.dart';
import 'package:fitness_app/core/extension/context_extention.dart';
import 'package:fitness_app/core/theming/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:shimmer/shimmer.dart';

class PopularTrainingSection extends StatelessWidget {
  final BaseResponse<HomeSection>? response;

  const PopularTrainingSection({super.key, this.response});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          context.l10n.popularTraining,
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
        context,
        (section as PopularWorkoutsSection).workouts,
      ),
      ErrorResponse(errorMessage: var msg) => _buildError(msg),
    };
  }

  Widget _buildList(BuildContext context, List<PopularWorkoutEntity> workouts) {
    if (workouts.isEmpty) {
      return SizedBox(
        height: 150,
        child: Center(
          child: Text(
            "No workouts found",
            style: const TextStyle(color: AppColors.light600),
          ),
        ),
      );
    }
    return SizedBox(
      height: 150,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: workouts.length,
        itemBuilder: (context, index) {
          return _PopularWorkoutCard(workout: workouts[index]);
        },
      ),
    );
  }

  Widget _buildError(String message) {
    return SizedBox(
      height: 150,
      child: Center(
        child: Text(
          message,
          style: const TextStyle(color: AppColors.red, fontSize: 13),
          textAlign: TextAlign.center,
        ),
      ),
    );
  }

  Widget _buildShimmer() {
    return SizedBox(
      height: 150,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: 3,
        itemBuilder: (context, index) {
          return Shimmer.fromColors(
            baseColor: AppColors.grayMid,
            highlightColor: AppColors.grayLight,
            child: Container(
              width: 200,
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

class _PopularWorkoutCard extends StatelessWidget {
  final PopularWorkoutEntity workout;
  const _PopularWorkoutCard({required this.workout});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        context.pushNamed(
          Routes.exercisesName,
          extra: {
            'primeMoverMuscleId': workout.muscleId,
            'title': workout.muscleName,
            'image': workout.muscleImage,
            'preloadedExercises': workout.exercises,
          },
        );
      },
      child: Container(
        width: 200,
        margin: const EdgeInsets.only(right: 12),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(16),
          image: DecorationImage(
            image: NetworkImage(workout.muscleImage),
            fit: BoxFit.cover,
          ),
        ),
        child: Stack(
          children: [
            Positioned.fill(
              child: Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(16),
                  gradient: const LinearGradient(
                    begin: Alignment.bottomCenter,
                    end: Alignment.topCenter,
                    colors: [AppColors.blackSoft, Colors.transparent],
                  ),
                ),
              ),
            ),
            Positioned(
              bottom: 12,
              left: 12,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    workout.muscleName,
                    style: const TextStyle(
                      color: AppColors.white,
                      fontWeight: FontWeight.bold,
                      fontSize: 14,
                    ),
                  ),
                  Text(
                    "${workout.totalExercises} ${context.l10n.tasks}",
                    style: const TextStyle(
                      color: AppColors.light600,
                      fontSize: 11,
                    ),
                  ),
                ],
              ),
            ),
            Positioned(
              bottom: 12,
              right: 12,
              child: Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 10,
                  vertical: 4,
                ),
                decoration: BoxDecoration(
                  color: AppColors.primary,
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Text(
                  workout.levelName,
                  style: const TextStyle(fontSize: 10, color: AppColors.white),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
