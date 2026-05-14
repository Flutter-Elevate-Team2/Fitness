import 'package:fitness_app/Features/food/presentation/view_models/meals_event.dart';
import 'package:fitness_app/Features/food/presentation/view_models/meals_view_model.dart';
import 'package:fitness_app/Features/food/presentation/views/widgets/meal_details_screen_body.dart';
import 'package:fitness_app/core/di/di.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class MealDetailsScreen extends StatelessWidget {
 final String mealId;
    const MealDetailsScreen( this.mealId,{super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) =>
      getIt<MealsViewModel>()..doIntent(FetchMealDetailsEvent(mealId)),
      child: const MealDetailsScreenBody(),
    );
  }
}