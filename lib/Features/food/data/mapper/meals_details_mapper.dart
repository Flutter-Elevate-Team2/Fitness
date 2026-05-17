import 'package:fitness_app/Features/food/data/models/meals_response/meal_details_response.dart';
import 'package:fitness_app/Features/food/domain/entities/meal_details_entity.dart';
import 'package:fitness_app/Features/food/data/models/meals_models/meal_details_model.dart';

extension MealDetailsModelMapper on MealDetailsModel {
  MealDetailEntity toEntity() {
    return MealDetailEntity(
      id: idMeal ?? "",
      name: strMeal ?? "",
      category: strCategory ?? "",
      area: strArea ?? "",
      instructions: strInstructions ?? "",
      image: strMealThumb ?? "",
      youtubeUrl: strYoutube,
      ingredients: ingredients.asMap().entries.map((entry) {
        return IngredientEntity(
          name: entry.value,
          measure: measures.length > entry.key ? measures[entry.key] : "",
        );
      }).toList(),
    );
  }
}

extension MealDetailsRemoteMapper on Meals {
  MealDetailsModel toHiveModel() {
    final List<String> ingredientsList = [];
    final List<String> measuresList = [];

    final mealMap = toJson();

    for (int i = 1; i <= 20; i++) {
      final ingredient = mealMap['strIngredient$i'] as String?;
      final measure = mealMap['strMeasure$i'] as String?;

      if (ingredient != null && ingredient.trim().isNotEmpty) {
        ingredientsList.add(ingredient);
        measuresList.add(measure ?? "");
      }
    }

    return MealDetailsModel(
      idMeal: idMeal ?? "",
      strMeal: strMeal ?? "",
      strCategory: strCategory ?? "",
      strArea: strArea ?? "",
      strInstructions: strInstructions ?? "",
      strMealThumb: strMealThumb ?? "",
      strYoutube: strYoutube,
      ingredients: ingredientsList,
      measures: measuresList,
    );
  }
}
