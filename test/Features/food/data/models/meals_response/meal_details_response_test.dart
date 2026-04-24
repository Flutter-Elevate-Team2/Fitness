import 'package:fitness_app/Features/food/data/models/meals_response/meal_details_response.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('MealDetailsResponse Serialization Tests', () {
    final tMealJson = {
      "idMeal": "52772",
      "strMeal": "Teriyaki Chicken",
      "strInstructions": "Cook it.",
      "strIngredient1": "chicken",
      "strMeasure1": "1kg",
    };

    final tResponseJson = {
      "meals": [tMealJson],
    };

    test('fromJson should create a valid object and parse nested meals', () {
      // Act
      final result = MealDetailsResponse.fromJson(tResponseJson);

      // Assert
      expect(result.meals, isA<List<Meals>>());
      expect(result.meals?.first.idMeal, "52772");
      expect(result.meals?.first.strIngredient1, "chicken");
    });

    test('toJson should return a map and handle nested objects correctly', () {
      // Arrange
      final meal = Meals(
        idMeal: "52772",
        strMeal: "Teriyaki Chicken",
        strIngredient1: "chicken",
      );
      final response = MealDetailsResponse(meals: [meal]);

      // Act
      final result = response.toJson();

      // Assert
      expect(result['meals'], isA<List>());
      expect(result['meals'][0].idMeal, "52772");
    });

    test('should handle nullable fields when API returns empty data', () {
      // Act
      final result = MealDetailsResponse.fromJson({"meals": null});

      // Assert
      expect(result.meals, null);
    });
  });

  group('Meals (Inner Class) Detailed Mapping', () {
    test('should map all 20 ingredients and measures correctly', () {
      final json = {
        "idMeal": "1",
        "strIngredient1": "Ing1",
        "strIngredient20": "Ing20",
        "strMeasure1": "Meas1",
        "strMeasure20": "Meas20",
      };

      final result = Meals.fromJson(json);

      expect(result.strIngredient1, "Ing1");
      expect(result.strIngredient20, "Ing20");
      expect(result.strMeasure1, "Meas1");
      expect(result.strMeasure20, "Meas20");
    });
  });
}
