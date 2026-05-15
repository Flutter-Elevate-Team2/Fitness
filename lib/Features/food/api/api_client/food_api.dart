import 'package:dio/dio.dart';
import 'package:fitness_app/Features/food/data/models/meals_response/categories_response.dart';
import 'package:fitness_app/Features/food/data/models/meals_response/meal_details_response.dart';
import 'package:fitness_app/Features/food/data/models/meals_response/meals_by_category_response.dart';
import 'package:fitness_app/core/constants/api_constants.dart';
import 'package:injectable/injectable.dart';
import 'package:retrofit/retrofit.dart';
part 'food_api.g.dart';

@lazySingleton
@RestApi()
@injectable
abstract class FoodApi {
  @factoryMethod
  factory FoodApi(@Named("MealsDio") Dio dio) = _FoodApi;

  @GET(ApiConstants.mealsCategories)
  Future<CategoriesResponse> getCategories();

  @GET(ApiConstants.mealsByCategory)
  Future<MealsByCategoryResponse> getMealsByCategory(
    @Query('c') String category,
  );

  @GET(ApiConstants.mealDetails)
  Future<MealDetailsResponse> getMealDetails(@Query('i') String id);
}
