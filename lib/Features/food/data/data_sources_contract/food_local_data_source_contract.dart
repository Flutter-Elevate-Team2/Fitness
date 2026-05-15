import 'package:fitness_app/Features/food/data/models/meals_models/category_model.dart';
import 'package:fitness_app/Features/food/data/models/meals_models/meal_details_model.dart';
import 'package:fitness_app/Features/food/data/models/meals_models/meal_model.dart';

abstract class FoodLocalDataSourceContract {
  Future<void> saveCategories(List<CategoryModel> categories);
  Future<List<CategoryModel>?> getCategories();

  Future<void> saveMealsByCategory(String categoryName, List<MealModel> meals);
  Future<List<MealModel>?> getMealsByCategory(String categoryName);

  Future<void> saveMealDetail(MealDetailsModel meal);
  Future<MealDetailsModel?> getMealDetail(String mealId);

  Future<bool> isCacheExpired(String key, Duration duration);
}
