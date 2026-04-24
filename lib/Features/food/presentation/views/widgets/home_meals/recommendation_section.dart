import 'package:fitness_app/Features/food/presentation/view_models/meals_event.dart';
import 'package:fitness_app/Features/food/presentation/view_models/meals_state.dart';
import 'package:fitness_app/Features/food/presentation/view_models/meals_view_model.dart';
 import 'package:fitness_app/core/app_router/app_router.dart';
import 'package:fitness_app/core/extension/context_extention.dart';
import 'package:fitness_app/core/theming/app_colors.dart';
import 'package:fitness_app/core/widget/shared_card.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

class RecommendationForYouSection extends StatelessWidget {
  const RecommendationForYouSection({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<MealsViewModel, MealsState>(
      buildWhen: (previous, current) =>
          previous.categoriesState != current.categoriesState,
      builder: (context, state) {
        final categories = state.categoriesState.data ?? [];

        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  context.l10n.recommendationForYou,
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                TextButton(
                  onPressed: () {
                    if (categories.isEmpty) return;
                    context.pushNamed(
                      Routes.mealsName,
                      extra: MealsNavArgs(
                        selectedCategory: categories.first.name,
                        categories: categories.map((c) => c.name).toList(),
                      ),
                    );
                  },
                  child: Text(
                    context.l10n.seeAll,
                    style: TextStyle(color: AppColors.primary),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 10),
            if (state.categoriesState.isLoading)
              const SizedBox(
                height: 120,
                child: Center(child: CircularProgressIndicator()),
              )
            else
              SizedBox(
                height: 120,
                child: ListView.builder(
                  scrollDirection: Axis.horizontal,
                  itemCount: categories.length,
                  itemBuilder: (context, index) {
                    final category = categories[index];
                    return SharedCard(
                      title: category.name,
                      imageUrl: category.image,
                      onTap: () {
                        context.pushNamed(
                          Routes.mealsName,
                          extra: MealsNavArgs(
                            selectedCategory: category.name,
                            categories: categories.map((c) => c.name).toList(),
                          ),
                        );
                      },
                      width: 120,
                      margin: const EdgeInsets.only(right: 15),
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
