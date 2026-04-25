import 'package:fitness_app/Features/workouts/presentation/view_models/workouts_events.dart';
import 'package:fitness_app/Features/workouts/presentation/view_models/workouts_view_model.dart';
import 'package:fitness_app/Features/workouts/presentation/views/widgets/workouts_screen_body.dart';
import 'package:fitness_app/core/di/di.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class WorkoutsScreen extends StatelessWidget {
  final String? initialGroupId;

  const WorkoutsScreen({super.key, this.initialGroupId});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) =>
          getIt<WorkoutsViewModel>()..doIntent(FetchMuscleGroupsEvent()),
      child: WorkoutsScreenBody(initialGroupId: initialGroupId),
    );
  }
}
