import 'package:fitness_app/Features/food/domain/entities/meal_details_entity.dart';
import 'package:fitness_app/core/theming/app_colors.dart';
import 'package:fitness_app/core/widget/shared_container.dart';
import 'package:flutter/material.dart';

class IngredientsList extends StatelessWidget {
  final List<IngredientEntity> ingredients;
  const IngredientsList({super.key , required this.ingredients});

  @override
  Widget build(BuildContext context) {
    return SharedContainer(
      borderRadius: 50,
      blur: 20.6,
      opacity: .0001,
      child: ListView.separated(
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        itemCount: ingredients.length,
        separatorBuilder: (_, _) =>
            Divider(color: AppColors.white.withAlpha(50)),
        itemBuilder: (context, index) {
          final item = ingredients[index];

          return Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(child: Text(
                item.name,
                style: const TextStyle(
                  color: AppColors.white,
                ),
              ),),
              Text(item.measure.toString()),
            ],
          );
        },
      ),
    );
  }
}
