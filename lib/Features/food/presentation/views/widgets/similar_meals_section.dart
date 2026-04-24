import 'package:fitness_app/Features/food/presentation/view_models/meals_event.dart';
import 'package:fitness_app/Features/food/presentation/view_models/meals_state.dart';
import 'package:fitness_app/Features/food/presentation/view_models/meals_view_model.dart';
import 'package:fitness_app/core/extension/context_extention.dart';
import 'package:fitness_app/core/widget/shared_card.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class SimilarMealsSection extends StatelessWidget {
  const SimilarMealsSection({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<MealsViewModel, MealsState>(
      builder: (context, state) {
        final meals = List.of(
          state.mealsByCategoryState.data!.where(
            (m) => m.id != state.mealDetailsState.data?.id,
          ),
        )..shuffle();
        if (meals.isEmpty) {
          return const SizedBox();
        }

        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            /// Title
            Text(
              context.l10n.foodRecommendation,
              style: Theme.of(context).textTheme.titleLarge,
            ),

            const SizedBox(height: 15),

            /// Horizontal List
            SizedBox(
              height: 190,
              child: ListView.separated(
                scrollDirection: Axis.horizontal,
                itemCount: meals.length,
                separatorBuilder: (_, _) => const SizedBox(width: 12),
                itemBuilder: (context, index) {
                  final meal = meals[index];
                  return _SimilarMealCard(meal: meal);
                },
              ),
            ),
          ],
        );
      },
    );
  }
}

class _SimilarMealCard extends StatelessWidget {
  final dynamic meal;

  const _SimilarMealCard({required this.meal});

  @override
  Widget build(BuildContext context) {
    return SharedCard(
      title: meal.name,
      imageUrl: meal.image,
      onTap: () {
        context.read<MealsViewModel>().doIntent(FetchMealDetailsEvent(meal.id));
      },
      width: 150,
      height: 190,
      useCachedImage: false,
    );
  }
}
