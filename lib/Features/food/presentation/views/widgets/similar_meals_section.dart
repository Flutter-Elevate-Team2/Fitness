import 'package:fitness_app/Features/food/presentation/view_models/meals_event.dart';
import 'package:fitness_app/core/extension/context_extention.dart';
import 'package:fitness_app/core/theming/app_colors.dart';
import 'package:fitness_app/core/widget/shared_container.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../view_models/meals_view_model.dart';
import '../../view_models/meals_state.dart';

class SimilarMealsSection extends StatelessWidget {
  const SimilarMealsSection({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<MealsViewModel, MealsState>(
      builder: (context, state) {
        final meals = List.of(
          state.mealsByCategoryState.data!
              .where((m) => m.id != state.mealDetailsState.data?.id),
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
    return GestureDetector(
      onTap: () {
        context.read<MealsViewModel>().doIntent(FetchMealDetailsEvent(meal.id));
      },
      child: Container(
        width: 150,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(18),
          color: AppColors.white.withAlpha(8),
        ),
        child:
            Stack(
              alignment: AlignmentGeometry.bottomCenter,
              children: [
                ClipRRect(
                  borderRadius: const BorderRadius.all(
                    Radius.circular(18),
                  ),
                  child: Image.network(
                    meal.image,
                    width: double.infinity,
                    height: 200,
                    fit: BoxFit.cover,
                  ),
                ),
                /// Name
                SharedContainer(
                  borderRadius: 18,
                  blur: 20.6,
                  opacity: .0001,
                  padding: EdgeInsetsGeometry.symmetric(vertical: 15 , horizontal: 20),
                  child:SizedBox(
                    width: double.infinity,
                    child:  Text(
                      textAlign: TextAlign.center,
                    meal.name,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: Theme.of(context).textTheme.labelLarge!.copyWith(
                      fontWeight: FontWeight.w600,
                      color: AppColors.white,
                    ),
                  ),)
                ),
              ],
            ),

      ),
    );
  }
}
