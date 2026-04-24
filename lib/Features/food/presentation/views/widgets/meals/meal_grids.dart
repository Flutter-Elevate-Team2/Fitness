import 'package:fitness_app/Features/food/presentation/view_models/meals_state.dart';
import 'package:fitness_app/Features/food/presentation/view_models/meals_view_model.dart';
import 'package:fitness_app/Features/food/presentation/views/widgets/meals/meal_card.dart';
import 'package:fitness_app/core/theming/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class MealsGridWidget extends StatelessWidget {
  const MealsGridWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<MealsViewModel, MealsState>(
      builder: (context, state) {
        final mealsState = state.mealsByCategoryState;

        if (mealsState.isLoading) {
          return const Center(
            child: CircularProgressIndicator(color: AppColors.primary),
          );
        }

        if (mealsState.errorMessage != null) {
          return Center(child: Text(mealsState.errorMessage!));
        }

        final meals = mealsState.data ?? [];

        return GridView.builder(
          padding: const EdgeInsets.all(16),
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            childAspectRatio: 0.9,
            crossAxisSpacing: 16,
            mainAxisSpacing: 16,
          ),
          itemCount: meals.length,
          itemBuilder: (context, index) {
            return MealCard(
              imageUrl: meals[index].image,
              title: meals[index].name,
              onTap: () {
                // TODO: Handle meal tap
              },
            );
          },
        );
      },
    );
  }
}
