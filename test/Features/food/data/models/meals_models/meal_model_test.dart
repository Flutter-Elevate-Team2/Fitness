import 'package:fitness_app/Features/food/data/models/meals_models/meal_model.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('MealModel Tests', () {
    final tJson = {
      "strMeal": "Teriyaki Chicken",
      "strMealThumb":
          "https://www.themealdb.com/images/media/meals/wvpsw11468256321.jpg",
      "idMeal": "52772",
    };

    final tMealModel = MealModel(
      idMeal: "52772",
      strMeal: "Teriyaki Chicken",
      strMealThumb:
          "https://www.themealdb.com/images/media/meals/wvpsw11468256321.jpg",
    );

    test('fromJson should return a valid model from JSON', () {
      // Act
      final result = MealModel.fromJson(tJson);

      // Assert
      expect(result.idMeal, tMealModel.idMeal);
      expect(result.strMeal, tMealModel.strMeal);
      expect(result.strMealThumb, tMealModel.strMealThumb);
    });

    test('toJson should return a JSON map containing the proper data', () {
      // Act
      final result = tMealModel.toJson();

      // Assert
      expect(result, tJson);
    });

    test('should handle null values safely', () {
      // Act
      final result = MealModel.fromJson({});

      // Assert
      expect(result.idMeal, null);
      expect(result.strMeal, null);
      expect(result.strMealThumb, null);
    });
  });
}
