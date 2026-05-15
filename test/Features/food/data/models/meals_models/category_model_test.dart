import 'package:fitness_app/Features/food/data/models/meals_models/category_model.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  final tCategoryModel = CategoryModel(
    idCategory: '1',
    strCategory: 'Beef',
    strCategoryThumb: 'https://www.themealdb.com/images/category/beef.png',
    strCategoryDescription: 'Beef is the culinary name for meat from cattle.',
  );

  final tJson = {
    "idCategory": "1",
    "strCategory": "Beef",
    "strCategoryThumb": "https://www.themealdb.com/images/category/beef.png",
    "strCategoryDescription": "Beef is the culinary name for meat from cattle.",
  };

  group('CategoryModel Tests', () {
    test('fromJson should return a valid model', () {
      // Act
      final result = CategoryModel.fromJson(tJson);

      // Assert
      expect(result.idCategory, tCategoryModel.idCategory);
      expect(result.strCategory, tCategoryModel.strCategory);
    });

    test('toJson should return a JSON map containing the proper data', () {
      // Act
      final result = tCategoryModel.toJson();

      // Assert
      expect(result, tJson);
    });

    test('Models with same data should be equal (Equatable check)', () {
      // Arrange
      final model1 = CategoryModel(idCategory: '1', strCategory: 'Beef');
      final model2 = CategoryModel(idCategory: '1', strCategory: 'Beef');

      // Assert
      expect(model1, equals(model2));
    });

    test('should handle null values safely', () {
      // Act
      final result = CategoryModel.fromJson({});

      // Assert
      expect(result.idCategory, null);
      expect(result.strCategory, null);
    });
  });
}
