import 'package:fitness_app/Features/food/domain/entities/meals_by_category_entity.dart';
import 'package:fitness_app/Features/food/domain/repo/food_repo_contract.dart';
import 'package:fitness_app/core/base_response/base_response.dart';
import 'package:injectable/injectable.dart';

@injectable
class GetMealsByCategoryUseCase {
  final FoodRepoContract _repository;

  GetMealsByCategoryUseCase(this._repository);

  Future<BaseResponse<List<MealsByCategoryEntity>>> call(String categoryName) {
    return _repository.getMealsByCategory(categoryName);
  }
}
