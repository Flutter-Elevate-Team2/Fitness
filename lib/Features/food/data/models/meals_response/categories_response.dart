import 'package:json_annotation/json_annotation.dart';

part 'categories_response.g.dart';

@JsonSerializable(explicitToJson: true)
class CategoriesResponse {
  @JsonKey(name: "categories")
  final List<Categories>? categories;

  CategoriesResponse({this.categories});

  factory CategoriesResponse.fromJson(Map<String, dynamic> json) {
    return _$CategoriesResponseFromJson(json);
  }

  Map<String, dynamic> toJson() {
    return _$CategoriesResponseToJson(this);
  }
}

@JsonSerializable()
class Categories {
  @JsonKey(name: "idCategory")
  final String? idCategory;
  @JsonKey(name: "strCategory")
  final String? strCategory;
  @JsonKey(name: "strCategoryThumb")
  final String? strCategoryThumb;
  @JsonKey(name: "strCategoryDescription")
  final String? strCategoryDescription;

  Categories({
    this.idCategory,
    this.strCategory,
    this.strCategoryThumb,
    this.strCategoryDescription,
  });

  factory Categories.fromJson(Map<String, dynamic> json) {
    return _$CategoriesFromJson(json);
  }

  Map<String, dynamic> toJson() {
    return _$CategoriesToJson(this);
  }
}
