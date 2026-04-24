import 'dart:ui';
import 'package:fitness_app/Features/food/presentation/view_models/meals_state.dart';
import 'package:fitness_app/Features/food/presentation/view_models/meals_view_model.dart';
import 'package:fitness_app/Features/food/presentation/views/widgets/expandable_text.dart';
import 'package:fitness_app/Features/food/presentation/views/widgets/ingredients_list.dart';
import 'package:fitness_app/Features/food/presentation/views/widgets/meal_image.dart';
import 'package:fitness_app/Features/food/presentation/views/widgets/outlined_text.dart';
import 'package:fitness_app/Features/food/presentation/views/widgets/similar_meals_section.dart';
import 'package:fitness_app/core/extension/context_extention.dart';
import 'package:fitness_app/core/theming/app_colors.dart';
import 'package:fitness_app/core/widget/shared_scaffold.dart';
import 'package:fitness_app/gen/assets.gen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class MealDetailsScreenBody extends StatefulWidget {
  const MealDetailsScreenBody({super.key});

  @override
  State<MealDetailsScreenBody> createState() => MealDetailsScreenBodyState();
}

class MealDetailsScreenBodyState extends State<MealDetailsScreenBody> {
  String? selectedGroupId;

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<MealsViewModel, MealsState>(
      builder: (context, state) {
        final mealState = state.mealDetailsState;

        if (mealState.isLoading) {
          return const Center(child: CircularProgressIndicator());
        }

        if (mealState.errorMessage != null) {
          return Text(mealState.errorMessage!);
        }

        final meal = mealState.data;

        if (meal == null) {
          return const SizedBox();
        }

        return SharedScaffold(
          backgroundImage: Assets.images.homeBackground.path,
           body: Stack(
            children: [
              // Blur + dark overlay
              Positioned.fill(
                child: BackdropFilter(
                  filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
                  child: Container(color: const Color(0x801A1A1A)),
                ),
              ),
              SafeArea(
                child: SingleChildScrollView(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                     Stack(
                       alignment: AlignmentGeometry.bottomCenter,
                       children: [
                         MealImage(videoUrl: meal.youtubeUrl),

                         /// Title
                         OutlinedText(
                           text: meal.name,
                           fontSize: 26,
                           fontWeight: FontWeight.bold,
                           textColor: AppColors.white,
                         ),
                         ]
                     ),

                      const SizedBox(height: 8),

                      /// Description
                      ExpandableText(text: meal.instructions),

                      const SizedBox(height: 20),

                      /// Ingredients title
                      Text(
                        context.l10n.ingredients,
                        style: Theme.of(context).textTheme.titleLarge!.copyWith(
                          color: AppColors.white,
                        ),
                      ),

                      const SizedBox(height: 15),

                      /// Ingredients list
                      IngredientsList(ingredients: meal.ingredients),

                      const SizedBox(height: 30),

                      SimilarMealsSection(),

                      const SizedBox(height: 30),
                    ],
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
