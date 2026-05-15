import 'package:fitness_app/Features/food/presentation/view_models/meals_event.dart';
import 'package:fitness_app/Features/food/presentation/view_models/meals_view_model.dart';
import 'package:fitness_app/Features/food/presentation/views/widgets/meals/category_tabs.dart';
import 'package:fitness_app/Features/food/presentation/views/widgets/meals/meal_grids.dart';
import 'package:fitness_app/core/extension/context_extention.dart';
import 'package:fitness_app/core/theming/app_colors.dart';
import 'package:fitness_app/core/widget/shared_scaffold.dart';
import 'package:fitness_app/gen/assets.gen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class MealsScreen extends StatefulWidget {
  final String selectedCategory;
  final List<String> categories;

  const MealsScreen({
    super.key,
    required this.selectedCategory,
    required this.categories,
  });

  @override
  State<MealsScreen> createState() => _MealsScreenState();
}

class _MealsScreenState extends State<MealsScreen> {
  @override
  void initState() {
    super.initState();
    context.read<MealsViewModel>().doIntent(
      FetchMealsByCategoryEvent(widget.selectedCategory),
    );
  }

  @override
  Widget build(BuildContext context) {
    return SharedScaffold(
      showBackButton: true,
      backgroundImage: Assets.images.food.path,
      title: Text(context.l10n.foodRecommendation,
          style: const TextStyle(color: AppColors.white)),
      body: Column(
        children: [
          CategoryTabsWidget(
            initialCategory: widget.selectedCategory,
            categories: widget.categories,
          ),
          const Expanded(child: MealsGridWidget()),
        ],
      ),
    );
  }
}