import 'package:flutter_test/flutter_test.dart';
import 'package:fitness_app/Features/food/data/models/meals_models/category_model.dart';
import 'package:fitness_app/Features/food/data/models/meals_response/categories_response.dart';
import 'package:fitness_app/Features/food/data/mapper/category_mapper.dart';

void main() {
  group('Category Mappers Tests', () {
    test('toHiveModel should map Categories response to CategoryModel', () {
      final remoteCategory = Categories(idCategory: '1', strCategory: 'Beef');

      final result = remoteCategory.toHiveModel();

      expect(result.idCategory, '1');
      expect(result.strCategory, 'Beef');
    });

    test('toEntity should map CategoryModel to CategoryEntity', () {
      final hiveModel = CategoryModel(idCategory: '1', strCategory: 'Beef');

      final entity = hiveModel.toEntity();

      expect(entity.id, '1');
      expect(entity.name, 'Beef');
    });
  });
}