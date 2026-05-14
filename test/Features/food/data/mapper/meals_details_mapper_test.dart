import 'package:fitness_app/Features/food/data/models/meals_response/meal_details_response.dart' as remote_details;
import 'package:flutter_test/flutter_test.dart';
import 'package:fitness_app/Features/food/data/models/meals_models/meal_details_model.dart';
import 'package:fitness_app/Features/food/data/mapper/meals_details_mapper.dart';

void main() {
  group('Meal Details Mappers Tests', () {
    test(
      'toHiveModel should extract ingredients and measures correctly from JSON',
      () {
        final remoteMealDetail = remote_details.Meals(
          idMeal: '1',
          strMeal: 'Test',
          strIngredient1: 'Chicken',
          strMeasure1: '1kg',
          strIngredient2: '',
        );

        final result = remoteMealDetail.toHiveModel();

        expect(result.ingredients.length, 1);
        expect(result.ingredients[0], 'Chicken');
        expect(result.measures[0], '1kg');
      },
    );

    test(
      'toEntity should map MealDetailsModel to MealDetailEntity with ingredients list',
      () {
        final hiveModel = MealDetailsModel(
          idMeal: '1',
          ingredients: ['Chicken'],
          measures: ['1kg'],
        );

        final entity = hiveModel.toEntity();

        expect(entity.id, '1');
        expect(entity.ingredients.length, 1);
        expect(entity.ingredients[0].name, 'Chicken');
        expect(entity.ingredients[0].measure, '1kg');
      },
    );
  });
}
