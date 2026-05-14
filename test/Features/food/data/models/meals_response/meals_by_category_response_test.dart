import 'package:fitness_app/Features/food/data/models/meals_response/meals_by_category_response.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('MealsByCategoryResponse Serialization Tests', () {
    final tMealsByCategoryResponseJson = {
      "meals": [
        {
          "strMeal": "Baked Salmon with Fennel & Tomatoes",
          "strMealThumb":
              "https://www.themealdb.com/images/media/meals/1548772327.jpg",
          "idMeal": "52959",
        },
      ],
    };

    test(
      'fromJson should return a valid MealsByCategoryResponse with a list of Meals',
      () {
        // Act
        final result = MealsByCategoryResponse.fromJson(
          tMealsByCategoryResponseJson,
        );

        // Assert
        expect(result.meals, isA<List<Meals>>());
        expect(result.meals?.length, 1);
        expect(result.meals?[0].idMeal, "52959");
        expect(result.meals?[0].strMeal, "Baked Salmon with Fennel & Tomatoes");
      },
    );

    test('toJson should return a JSON map with correct data structure', () {
      // Arrange
      final tMealsResponse = MealsByCategoryResponse(
        meals: [
          Meals(
            idMeal: "52959",
            strMeal: "Baked Salmon with Fennel & Tomatoes",
            strMealThumb: "https://url.com/image.jpg",
          ),
        ],
      );

      // Act
      final result = tMealsResponse.toJson();

      // Assert
      expect(result['meals'], isA<List>());
      expect(result['meals'][0].idMeal, "52959");
      expect(result['meals'][0].strMeal, "Baked Salmon with Fennel & Tomatoes");
    });

    test('should return empty list when meals field is empty in JSON', () {
      // Act
      final result = MealsByCategoryResponse.fromJson({"meals": []});

      // Assert
      expect(result.meals, isEmpty);
    });

    test('should return null when meals field is null in JSON', () {
      // Act
      final result = MealsByCategoryResponse.fromJson({"meals": null});

      // Assert
      expect(result.meals, isNull);
    });
  });

  group('Meals (Inner Class) Serialization', () {
    test('fromJson should handle simple meal data correctly', () {
      final mealJson = {"strMeal": "Test Meal", "idMeal": "123"};

      final result = Meals.fromJson(mealJson);

      expect(result.idMeal, "123");
      expect(result.strMeal, "Test Meal");
      expect(result.strMealThumb, isNull);
    });
  });
}
