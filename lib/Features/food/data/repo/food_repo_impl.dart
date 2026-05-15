import 'package:fitness_app/Features/food/data/data_sources_contract/food_local_data_source_contract.dart';
import 'package:fitness_app/Features/food/data/data_sources_contract/food_remote_data_source_contract.dart';
import 'package:fitness_app/Features/food/data/mapper/category_mapper.dart';
import 'package:fitness_app/Features/food/data/mapper/meals_by_category_mapper.dart';
import 'package:fitness_app/Features/food/data/mapper/meals_details_mapper.dart';
import 'package:fitness_app/Features/food/data/models/meals_models/category_model.dart';
import 'package:fitness_app/Features/food/data/models/meals_models/meal_details_model.dart';
import 'package:fitness_app/Features/food/data/models/meals_models/meal_model.dart';
import 'package:fitness_app/Features/food/data/models/meals_response/categories_response.dart';
import 'package:fitness_app/Features/food/data/models/meals_response/meal_details_response.dart';
import 'package:fitness_app/Features/food/data/models/meals_response/meals_by_category_response.dart';
import 'package:fitness_app/Features/food/domain/entities/category_entity.dart';
import 'package:fitness_app/Features/food/domain/entities/meal_details_entity.dart';
import 'package:fitness_app/Features/food/domain/entities/meals_by_category_entity.dart';
import 'package:fitness_app/Features/food/domain/repo/food_repo_contract.dart';
import 'package:fitness_app/core/base_response/base_response.dart';
import 'package:fitness_app/core/mixins/cache_execution_mixin.dart';
import 'package:fitness_app/core/network/network_info.dart';
import 'package:injectable/injectable.dart';

@Injectable(as: FoodRepoContract)
class FoodRepoImpl with CacheExecutionMixin implements FoodRepoContract {
  final FoodRemoteDataSourceContract _remoteDataSource;
  final FoodLocalDataSourceContract _localDataSource;

  @override
  final NetworkInfo networkInfo;

  FoodRepoImpl(this._remoteDataSource, this._localDataSource, this.networkInfo);

  @override
  Future<BaseResponse<List<CategoryEntity>>> getCategories() {
    return executeWithCache<
      CategoriesResponse,
      List<CategoryModel>?,
      List<CategoryEntity>
    >(
      fetchFromRemote: () => _remoteDataSource.getCategories(),
      fetchFromCache: () => _localDataSource.getCategories(),
      isExpired: () => _localDataSource.isCacheExpired(
        'categories_key',
        const Duration(hours: 24),
      ),
      saveToCache: (remoteResponse) async {
        final hiveList =
            remoteResponse.categories?.map((e) => e.toHiveModel()).toList() ??
            [];
        await _localDataSource.saveCategories(hiveList);
      },
      remoteMapper: (remoteResponse) =>
          remoteResponse.categories
              ?.map((e) => e.toHiveModel().toEntity())
              .toList() ??
          [],
      cacheMapper: (localList) =>
          localList?.map((e) => e.toEntity()).toList() ?? [],
    );
  }

  @override
  Future<BaseResponse<List<MealsByCategoryEntity>>> getMealsByCategory(
    String category,
  ) {
    final String cacheKey = 'meals_$category';

    return executeWithCache<
      MealsByCategoryResponse,
      List<MealModel>?,
      List<MealsByCategoryEntity>
    >(
      fetchFromRemote: () => _remoteDataSource.getMealsByCategory(category),
      fetchFromCache: () => _localDataSource.getMealsByCategory(category),
      isExpired: () =>
          _localDataSource.isCacheExpired(cacheKey, const Duration(hours: 24)),
      saveToCache: (remoteResponse) async {
        final hiveList =
            remoteResponse.meals?.map((e) => e.toHiveModel()).toList() ?? [];
        await _localDataSource.saveMealsByCategory(category, hiveList);
      },
      remoteMapper: (remoteResponse) =>
          remoteResponse.meals
              ?.map((e) => e.toHiveModel().toEntity())
              .toList() ??
          [],
      cacheMapper: (localList) =>
          localList?.map((e) => e.toEntity()).toList() ?? [],
    );
  }

  @override
  Future<BaseResponse<MealDetailEntity>> getMealDetails(String id) {
    final String cacheKey = 'detail_$id';

    return executeWithCache<
      MealDetailsResponse,
      MealDetailsModel?,
      MealDetailEntity
    >(
      fetchFromRemote: () => _remoteDataSource.getMealDetails(id),
      fetchFromCache: () => _localDataSource.getMealDetail(id),
      isExpired: () =>
          _localDataSource.isCacheExpired(cacheKey, const Duration(hours: 24)),
      saveToCache: (remoteResponse) async {
        if (remoteResponse.meals != null && remoteResponse.meals!.isNotEmpty) {
          final hiveModel = remoteResponse.meals!.first.toHiveModel();
          await _localDataSource.saveMealDetail(hiveModel);
        }
      },
      remoteMapper: (remoteResponse) {
        return remoteResponse.meals!.first.toHiveModel().toEntity();
      },
      cacheMapper: (localModel) {
        return localModel!.toEntity();
      },
    );
  }
}
