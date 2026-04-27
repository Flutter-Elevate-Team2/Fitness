import 'package:fitness_app/Features/food/presentation/views/widgets/home_meals/recommendation_section.dart';
import 'package:fitness_app/Features/home/domain/entities/home_section.dart';
import 'package:fitness_app/Features/home/presentation/view_model/home_state.dart';
import 'package:fitness_app/Features/home/presentation/view_model/home_view_model.dart';
import 'package:fitness_app/Features/home/presentation/views/widgets/home_category.dart';
import 'package:fitness_app/Features/home/presentation/views/widgets/random_muscle_section.dart';
import 'package:fitness_app/Features/home/presentation/views/widgets/home_header.dart';
import 'package:fitness_app/Features/home/presentation/views/widgets/popular_training_section.dart';
import 'package:fitness_app/Features/home/presentation/views/widgets/upcoming_workouts_section.dart';
import 'package:fitness_app/core/base_response/base_response.dart';
import 'package:fitness_app/core/widget/shared_scaffold.dart';
import 'package:fitness_app/gen/assets.gen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ExploreScreenBody extends StatelessWidget {
  final void Function({String? selectedGroupId})? onSeeAllWorkoutsTapped;
  const ExploreScreenBody({super.key, this.onSeeAllWorkoutsTapped});

  @override
  Widget build(BuildContext context) {
    return SharedScaffold(
      backgroundImage: Assets.images.food.path,
      showBackButton: false,
      body: BlocBuilder<HomeViewModel, HomeState>(
        builder: (context, state) {
          return SafeArea(
            child: ListView.separated(
              padding: const EdgeInsets.only(
                bottom: 116,
                left: 16,
                right: 16,
                top: 16,
              ),
              itemCount: 6,
              separatorBuilder: (_, _) => const SizedBox(height: 24),
              itemBuilder: (context, index) {
                if (index == 1) {
                  return CategorySection(onTapGym: onSeeAllWorkoutsTapped);
                }

                int serverIndex = index > 1 ? index - 1 : index;

                final response = state.homeData.where((e) {
                  if (e is SuccessResponse<HomeSection>) {
                    return e.data.index == serverIndex;
                  }
                  return false;
                }).firstOrNull;

                return switch (index) {
                  0 => HomeHeader(response: response), // Server Index 0
                  2 => RandomMusclesSection(
                    response: response,
                  ), // Server Index 1
                  3 => UpcomingWorkoutsSection(
                    response: response,
                    onSeeAllTapped: onSeeAllWorkoutsTapped,
                  ), // Server Index 2
                  4 => RecommendationForYouSection(
                    response: response,
                  ), // Server Index 3
                  5 => PopularTrainingSection(
                    response: response,
                  ), // Server Index 4
                  _ => const SizedBox.shrink(),
                };
              },
            ),
          );
        },
      ),
    );
  }
}
