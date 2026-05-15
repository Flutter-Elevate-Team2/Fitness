import 'package:flutter_test/flutter_test.dart';
import 'package:fitness_app/Features/food/data/models/meals_models/meal_model.dart';
import 'package:fitness_app/Features/food/data/models/meals_response/meals_by_category_response.dart' as remote_meals;
import 'package:fitness_app/Features/food/data/mapper/meals_by_category_mapper.dart';

void main() {
  group('Meal Summary Mappers Tests', () {
    test('toHiveModel should map remote Meal to MealModel', () {
      final remoteMeal = remote_meals.Meals(idMeal: '52772', strMeal: 'Teriyaki Chicken');

      final result = remoteMeal.toHiveModel();

      expect(result.idMeal, '52772');
      expect(result.strMeal, 'Teriyaki Chicken');
    });

    test('toEntity should map MealModel to MealsByCategoryEntity', () {
      final hiveModel = MealModel(idMeal: '52772', strMeal: 'Teriyaki Chicken');

      final entity = hiveModel.toEntity();

      expect(entity.id, '52772');
      expect(entity.name, 'Teriyaki Chicken');
    });
  });
}