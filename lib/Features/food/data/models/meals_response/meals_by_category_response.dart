import 'package:json_annotation/json_annotation.dart';

part 'meals_by_category_response.g.dart';

@JsonSerializable()
class MealsByCategoryResponse {
  @JsonKey(name: "meals")
  final List<Meals>? meals;

  MealsByCategoryResponse ({
    this.meals,
  });

  factory MealsByCategoryResponse.fromJson(Map<String, dynamic> json) {
    return _$MealsByCategoryResponseFromJson(json);
  }

  Map<String, dynamic> toJson() {
    return _$MealsByCategoryResponseToJson(this);
  }
}

@JsonSerializable()
class Meals {
  @JsonKey(name: "strMeal")
  final String? strMeal;
  @JsonKey(name: "strMealThumb")
  final String? strMealThumb;
  @JsonKey(name: "idMeal")
  final String? idMeal;

  Meals ({
    this.strMeal,
    this.strMealThumb,
    this.idMeal,
  });

  factory Meals.fromJson(Map<String, dynamic> json) {
    return _$MealsFromJson(json);
  }

  Map<String, dynamic> toJson() {
    return _$MealsToJson(this);
  }
}


