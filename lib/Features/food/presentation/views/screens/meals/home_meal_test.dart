import 'package:fitness_app/Features/food/presentation/view_models/meals_event.dart';
import 'package:fitness_app/Features/food/presentation/view_models/meals_view_model.dart';
import 'package:fitness_app/Features/food/presentation/views/widgets/home_meals/recommendation_section.dart';
import 'package:fitness_app/core/widget/shared_scaffold.dart';
import 'package:fitness_app/gen/assets.gen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
// coverage:ignore-file

class HomeMealTest extends StatefulWidget {
  const HomeMealTest({super.key});

  @override
  State<HomeMealTest> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeMealTest> {
  @override
  void initState() {
    super.initState();
    context.read<MealsViewModel>().doIntent(FetchCategoriesEvent());
  }

  @override
  Widget build(BuildContext context) {
    return SharedScaffold(
      backgroundImage: Assets.images.food.path,
      showBackButton: false,
      body: SafeArea(child: RecommendationForYouSection()),
    );
  }
}
