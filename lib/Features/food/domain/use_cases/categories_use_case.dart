import 'package:fitness_app/Features/food/domain/entities/category_entity.dart';
import 'package:fitness_app/Features/food/domain/repo/food_repo_contract.dart';
import 'package:fitness_app/core/base_response/base_response.dart';
import 'package:injectable/injectable.dart';

@injectable
class GetCategoriesUseCase {
  final FoodRepoContract _repository;

  GetCategoriesUseCase(this._repository);

  Future<BaseResponse<List<CategoryEntity>>> call() {
    return _repository.getCategories();
  }
}