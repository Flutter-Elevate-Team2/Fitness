import 'package:fitness_app/Features/home/presentation/view_model/home_state.dart';
import 'package:fitness_app/Features/home/presentation/view_model/home_view_model.dart';
import 'package:fitness_app/core/app_router/app_router.dart';
import 'package:fitness_app/core/widget/shared_card.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

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
                Text(
                  "Workouts For You",
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 10),

            if (state.isLoading && muscles.isEmpty)
              const SizedBox(
                height: 120,
                child: Center(child: CircularProgressIndicator()),
              )
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
                      width: 140,
                      height: 180,
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
}
