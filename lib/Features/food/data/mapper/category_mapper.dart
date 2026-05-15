import 'package:fitness_app/Features/food/data/models/meals_response/categories_response.dart';
import 'package:fitness_app/Features/food/domain/entities/category_entity.dart';
import 'package:fitness_app/Features/food/data/models/meals_models/category_model.dart';

extension CategoryModelMapper on CategoryModel {
  CategoryEntity toEntity() {
    return CategoryEntity(
      id: idCategory ?? "",
      name: strCategory ?? "Unknown",
      image: strCategoryThumb ?? "",
      description: strCategoryDescription ?? "",
    );
  }
}

extension CategoryRemoteMapper on Categories {
  CategoryModel toHiveModel() {
    return CategoryModel(
      idCategory: idCategory ?? '',
      strCategory: strCategory ?? 'Unknown',
      strCategoryThumb: strCategoryThumb ?? '',
      strCategoryDescription: strCategoryDescription ?? '',
    );
  }
}
