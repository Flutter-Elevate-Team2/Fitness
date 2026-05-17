import 'package:fitness_app/Features/food/domain/entities/category_entity.dart';
import 'package:fitness_app/Features/food/domain/entities/meal_details_entity.dart';
import 'package:fitness_app/Features/food/domain/entities/meals_by_category_entity.dart';
import 'package:fitness_app/core/base_response/base_response.dart';

abstract class FoodRepoContract {
  Future<BaseResponse<List<CategoryEntity>>> getCategories();
  Future<BaseResponse<List<MealsByCategoryEntity>>> getMealsByCategory(
    String category,
  );
  Future<BaseResponse<MealDetailEntity>> getMealDetails(String id);
}
