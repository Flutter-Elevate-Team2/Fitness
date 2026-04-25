import 'dart:ui';

import 'package:fitness_app/Features/food/presentation/views/widgets/home_meals/recommendation_section.dart';
import 'package:fitness_app/Features/home/presentation/view_model/home_view_model.dart';
import 'package:fitness_app/Features/home/presentation/views/widgets/Random_muscle_section.dart';
import 'package:fitness_app/Features/home/presentation/views/widgets/home_category.dart';
import 'package:fitness_app/Features/home/presentation/views/widgets/home_header.dart';
import 'package:fitness_app/Features/home/presentation/views/widgets/popular_training_section.dart';
import 'package:fitness_app/Features/home/presentation/views/widgets/upcoming_workouts_section.dart';
import 'package:fitness_app/core/di/di.dart';
import 'package:fitness_app/core/widget/shared_scaffold.dart';
import 'package:fitness_app/gen/assets.gen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ExploreScreenBody extends StatefulWidget {
  /// Callback to switch to the Workouts tab from "See All".
  final void Function({String? selectedGroupId})? onSeeAllWorkoutsTapped;

  const ExploreScreenBody({super.key, this.onSeeAllWorkoutsTapped});

  @override
  State<ExploreScreenBody> createState() => _ExploreScreenBodyState();
}

class _ExploreScreenBodyState extends State<ExploreScreenBody> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => getIt<HomeViewModel>()..initHome(),
      child: SharedScaffold(
        backgroundImage: Assets.images.homeBackground.path,
        showBackButton: false,
        body: Stack(
          children: [
            Positioned.fill(
              child: BackdropFilter(
                filter: ImageFilter.blur(sigmaX: 12.5, sigmaY: 12.5),
                child: Container(color: const Color(0x801A1A1A)),
              ),
            ),
            SafeArea(
              child: SingleChildScrollView(
                padding: const EdgeInsets.only(bottom: 100),
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    children: [
                      const HomeHeader(),
                      const SizedBox(height: 20),

                      const CategorySection(),
                      const SizedBox(height: 20),

                      const RandomMusclesSection(),
                      const SizedBox(height: 20),

                      UpcomingWorkoutsSection(
                        onSeeAllTapped: widget.onSeeAllWorkoutsTapped,
                      ),
                      const SizedBox(height: 20),

                      const RecommendationForYouSection(),
                      const SizedBox(height: 20),

                      const PopularTrainingSection(),
                    ],
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
