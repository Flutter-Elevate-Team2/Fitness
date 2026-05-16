import 'package:fitness_app/Features/food/api/api_client/food_api.dart';
import 'package:fitness_app/Features/food/data/data_sources_contract/food_remote_data_source_contract.dart';
import 'package:fitness_app/Features/food/data/models/meals_response/categories_response.dart';
import 'package:fitness_app/Features/food/data/models/meals_response/meals_by_category_response.dart';
import 'package:fitness_app/Features/food/data/models/meals_response/meal_details_response.dart';
import 'package:injectable/injectable.dart';

@Injectable(as: FoodRemoteDataSourceContract)
class FoodRemoteDataSourceImpl implements FoodRemoteDataSourceContract {
  final FoodApi _foodApi;

  FoodRemoteDataSourceImpl(this._foodApi);

  @override
  Future<CategoriesResponse> getCategories() {
    return _foodApi.getCategories();
  }

  @override
  Future<MealsByCategoryResponse> getMealsByCategory(String category) {
    return _foodApi.getMealsByCategory(category);
  }

  @override
  Future<MealDetailsResponse> getMealDetails(String id) {
    return _foodApi.getMealDetails(id);
  }
}
