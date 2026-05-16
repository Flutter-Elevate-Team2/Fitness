import 'package:fitness_app/Features/food/domain/entities/meals_by_category_entity.dart';
import 'package:fitness_app/Features/food/data/models/meals_models/meal_model.dart';
import '../models/meals_response/meals_by_category_response.dart';

extension MealModelMapper on MealModel {
  MealsByCategoryEntity toEntity() {
    return MealsByCategoryEntity(
      id: idMeal ?? "",
      name: strMeal ?? "Unknown Meal",
      image: strMealThumb ?? "",
    );
  }
}

extension MealRemoteMapper on Meals {
  MealModel toHiveModel() {
    return MealModel(
      idMeal: idMeal ?? '',
      strMeal: strMeal ?? 'Unknown',
      strMealThumb: strMealThumb ?? '',
    );
  }
}
