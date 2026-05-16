import 'package:fitness_app/Features/food/domain/entities/meal_details_entity.dart';
import 'package:fitness_app/Features/food/domain/repo/food_repo_contract.dart';
import 'package:fitness_app/core/base_response/base_response.dart';
import 'package:injectable/injectable.dart';

@injectable
class GetMealDetailsUseCase {
  final FoodRepoContract _repository;

  GetMealDetailsUseCase(this._repository);

  Future<BaseResponse<MealDetailEntity>> call(String mealId) {
    return _repository.getMealDetails(mealId);
  }
}
