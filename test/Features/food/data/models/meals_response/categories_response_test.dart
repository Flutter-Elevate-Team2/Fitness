import 'package:fitness_app/Features/food/data/models/meals_response/categories_response.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('CategoriesResponse Tests', () {
    final tCategoriesResponseJson = {
      "categories": [
        {
          "idCategory": "1",
          "strCategory": "Beef",
          "strCategoryThumb": "thumb_url",
          "strCategoryDescription": "Beef description",
        },
      ],
    };

    test(
      'fromJson should return a valid CategoriesResponse with a list of Categories',
      () {
        // Act
        final result = CategoriesResponse.fromJson(tCategoriesResponseJson);

        // Assert
        expect(result.categories, isA<List<Categories>>());
        expect(result.categories?.length, 1);
        expect(result.categories?[0].idCategory, "1");
        expect(result.categories?[0].strCategory, "Beef");
      },
    );

    test(
      'toJson should return a JSON map containing the proper nested data',
      () {
        // Arrange
        final tCategoriesResponse = CategoriesResponse(
          categories: [
            Categories(
              idCategory: "1",
              strCategory: "Beef",
              strCategoryThumb: "thumb_url",
              strCategoryDescription: "Beef description",
            ),
          ],
        );

        // Act
        final result = tCategoriesResponse.toJson();

        // Assert
        // دلوقت الـ result مفروض تكون Map كاملة زي الـ JSON بالظبط
        expect(result, tCategoriesResponseJson);
      },
    );

    test('should handle empty or null categories list safely', () {
      // Act
      final resultNull = CategoriesResponse.fromJson({"categories": null});
      final resultEmpty = CategoriesResponse.fromJson({"categories": []});

      // Assert
      expect(resultNull.categories, null);
      expect(resultEmpty.categories, isEmpty);
    });
  });

  group('Categories (Inner Class) Tests', () {
    test('fromJson should handle individual category data', () {
      final categoryJson = {"idCategory": "2", "strCategory": "Chicken"};

      final result = Categories.fromJson(categoryJson);

      expect(result.idCategory, "2");
      expect(result.strCategory, "Chicken");
      expect(result.strCategoryThumb, null);
    });
  });
}
