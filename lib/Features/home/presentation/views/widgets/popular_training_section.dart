import 'package:fitness_app/Features/home/domain/entities/popular_tranning_entity.dart';
import 'package:fitness_app/Features/home/presentation/view_model/home_state.dart';
import 'package:fitness_app/Features/home/presentation/view_model/home_view_model.dart';
import 'package:fitness_app/core/app_router/app_router.dart';
import 'package:fitness_app/core/theming/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

class PopularTrainingSection extends StatelessWidget {
  const PopularTrainingSection({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<HomeViewModel, HomeState>(
      buildWhen: (previous, current) =>
          previous.popularWorkoutsState != current.popularWorkoutsState,
      builder: (context, state) {
        final popularState = state.popularWorkoutsState;
        final workouts = popularState.data ?? [];

        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            /// Header
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  "Popular Training",
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 16,
                    fontWeight: FontWeight.w700,
                  ),
                ),
               
              ],
            ),
            const SizedBox(height: 10),

            /// Loading state
            if (popularState.isLoading && workouts.isEmpty)
              const SizedBox(
                height: 150,
                child: Center(child: CircularProgressIndicator()),
              )

            /// Error state
            else if (popularState.errorMessage != null && workouts.isEmpty)
              SizedBox(
                height: 150,
                child: Center(
                  child: Text(
                    popularState.errorMessage!,
                    style: const TextStyle(color: Colors.white54, fontSize: 13),
                    textAlign: TextAlign.center,
                  ),
                ),
              )

            /// Success state
            else
              SizedBox(
                height: 150,
                child: ListView.builder(
                  scrollDirection: Axis.horizontal,
                  itemCount: workouts.length,
                  itemBuilder: (context, index) {
                    return _PopularWorkoutCard(
                      workout: workouts[index],
                    );
                  },
                ),
              ),
          ],
        );
      },
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
            /// Dark gradient overlay bottom
            Positioned.fill(
              child: Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(16),
                  gradient: const LinearGradient(
                    begin: Alignment.bottomCenter,
                    end: Alignment.topCenter,
                    colors: [Colors.black87, Colors.transparent],
                  ),
                ),
              ),
            ),

            /// Text info
            Positioned(
              bottom: 12,
              left: 12,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    workout.muscleName,
                    style: const TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontSize: 14,
                    ),
                  ),
                  Text(
                    "${workout.totalExercises} Tasks",
                    style: const TextStyle(
                      color: Colors.white54,
                      fontSize: 11,
                    ),
                  ),
                ],
              ),
            ),

            /// Badge
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
                  style: const TextStyle(
                    fontSize: 10,
                    color: Colors.white,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
