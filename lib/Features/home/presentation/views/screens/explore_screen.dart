import 'package:fitness_app/Features/home/presentation/view_model/home_view_model.dart';
import 'package:fitness_app/Features/home/presentation/views/widgets/explore_screen_body.dart';
import 'package:fitness_app/core/di/di.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ExploreScreen extends StatelessWidget {
  /// Callback to switch to the Workouts tab from "See All".
  final void Function({String? selectedGroupId})? onSeeAllWorkoutsTapped;

  const ExploreScreen({super.key, this.onSeeAllWorkoutsTapped});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => getIt<HomeViewModel>()..initHome(),
      child: ExploreScreenBody(
        onSeeAllWorkoutsTapped: onSeeAllWorkoutsTapped,
      ),
    );
  }
}
