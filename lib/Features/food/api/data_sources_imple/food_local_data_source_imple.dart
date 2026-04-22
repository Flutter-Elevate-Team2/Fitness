import 'package:fitness_app/Features/food/data/data_sources_contract/food_local_data_source_contract.dart';
import 'package:fitness_app/Features/food/data/models/meals_models/category_model.dart';
import 'package:fitness_app/Features/food/data/models/meals_models/meal_details_model.dart';
import 'package:fitness_app/Features/food/data/models/meals_models/meal_model.dart';
import 'package:fitness_app/core/data_base/hive_database_service.dart';
import 'package:hive_ce/hive.dart';
import 'package:injectable/injectable.dart';

@Injectable(as: FoodLocalDataSourceContract)
class FoodLocalDataSourceImple implements FoodLocalDataSourceContract {
  static const String _boxName = "food_box";
  static const String _metadataBox = 'cache_metadata_box';

  Box? _box;

  Future<Box> _getBox() async {
    _box ??= await HiveDatabaseService.instance.openBox(_boxName);
    return _box!;
  }

  Future<void> _saveTimestamp(String key) async {
    final box = await HiveDatabaseService.instance.openBox<dynamic>(
      _metadataBox,
    );
    await box.put('ts_$key', DateTime.now().millisecondsSinceEpoch);
  }

  @override
  Future<void> saveCategories(List<CategoryModel> categories) async {
    final box = await _getBox();
    const key = "categories_key";
    await box.put(key, categories);
    await _saveTimestamp(key);
  }

  @override
  Future<void> saveMealsByCategory(
    String categoryName,
    List<MealModel> meals,
  ) async {
    final box = await _getBox();
    final key = "meals_$categoryName";
    await box.put(key, meals);
    await _saveTimestamp(key);
  }

  @override
  Future<void> saveMealDetail(MealDetailsModel meal) async {
    final box = await _getBox();
    final key = "detail_${meal.idMeal}";
    await box.put(key, meal);
    await _saveTimestamp(key);
  }

  @override
  Future<bool> isCacheExpired(String key, Duration ttl) async {
    final box = await HiveDatabaseService.instance.openBox<dynamic>(
      _metadataBox,
    );
    final lastUpdate = box.get('ts_$key') as int?;

    if (lastUpdate == null) return true;

    final lastUpdateTime = DateTime.fromMillisecondsSinceEpoch(lastUpdate);

    return DateTime.now().difference(lastUpdateTime) > ttl;
  }

  @override
  Future<List<CategoryModel>?> getCategories() async {
    final box = await _getBox();
    final data = box.get("categories_key");
    return data != null ? List<CategoryModel>.from(data) : null;
  }

  @override
  Future<List<MealModel>?> getMealsByCategory(String categoryName) async {
    final box = await _getBox();
    final data = box.get("meals_$categoryName");
    return data != null ? List<MealModel>.from(data) : null;
  }

  @override
  Future<MealDetailsModel?> getMealDetail(String mealId) async {
    final box = await _getBox();
    return box.get("detail_$mealId");
  }
}
