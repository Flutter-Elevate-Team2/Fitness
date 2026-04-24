import 'package:fitness_app/Features/food/data/models/meals_models/meal_details_model.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('MealDetailsModel Logic Tests', () {
    final tJson = {
      "idMeal": "52772",
      "strMeal": "Teriyaki Chicken",
      "strCategory": "Chicken",
      "strArea": "Japanese",
      "strInstructions": "Cook it well.",
      "strMealThumb": "https://url.com/image.jpg",
      "strYoutube": "https://youtube.com/video",
      "strIngredient1": "chicken",
      "strIngredient2": "soy sauce",
      "strIngredient3": "",
      "strIngredient4": null,
      "strMeasure1": "1kg",
      "strMeasure2": "200ml",
      "strMeasure3": " ",
    };

    test(
      'fromJson should correctly collect ingredients and measures into lists',
      () {
        // Act
        final result = MealDetailsModel.fromJson(tJson);

        // Assert
        expect(result.idMeal, "52772");
        expect(result.strMeal, "Teriyaki Chicken");

        expect(result.ingredients.length, 2);
        expect(result.ingredients, ["chicken", "soy sauce"]);

        expect(result.measures.length, 2);
        expect(result.measures, ["1kg", "200ml"]);
      },
    );

    test('toJson should return a valid map based on JsonSerializable', () {
      final model = MealDetailsModel(
        idMeal: "1",
        strMeal: "Test Meal",
        ingredients: ["Rice"],
        measures: ["1 cup"],
      );

      final result = model.toJson();

      expect(result['idMeal'], "1");
      expect(result['ingredients'], ["Rice"]);
    });

    test('should handle completely empty JSON safely', () {
      // Act
      final result = MealDetailsModel.fromJson({});

      // Assert
      expect(result.idMeal, null);
      expect(result.ingredients, isEmpty);
      expect(result.measures, isEmpty);
    });
  });
}
