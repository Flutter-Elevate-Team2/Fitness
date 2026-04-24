import 'package:fitness_app/Features/food/data/models/meals_response/categories_response.dart';
import 'package:fitness_app/Features/food/data/models/meals_response/meal_details_response.dart';
import 'package:fitness_app/Features/food/data/models/meals_response/meals_by_category_response.dart';

abstract class FoodRemoteDataSourceContract {
  Future<CategoriesResponse> getCategories();

  Future<MealsByCategoryResponse> getMealsByCategory(String category);

  Future<MealDetailsResponse> getMealDetails(String id);
}
