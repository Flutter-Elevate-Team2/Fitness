import 'package:json_annotation/json_annotation.dart';

part 'meal_details_response.g.dart';

@JsonSerializable()
class MealDetailsResponse {
  @JsonKey(name: "meals")
  final List<Meals>? meals;

  MealDetailsResponse ({
    this.meals,
  });

  factory MealDetailsResponse.fromJson(Map<String, dynamic> json) {
    return _$MealDetailsResponseFromJson(json);
  }

  Map<String, dynamic> toJson() {
    return _$MealDetailsResponseToJson(this);
  }
}

@JsonSerializable()
class Meals {
  @JsonKey(name: "idMeal")
  final String? idMeal;
  @JsonKey(name: "strMeal")
  final String? strMeal;
  @JsonKey(name: "strMealAlternate")
  final dynamic strMealAlternate;
  @JsonKey(name: "strCategory")
  final String? strCategory;
  @JsonKey(name: "strArea")
  final String? strArea;
  @JsonKey(name: "strInstructions")
  final String? strInstructions;
  @JsonKey(name: "strMealThumb")
  final String? strMealThumb;
  @JsonKey(name: "strTags")
  final dynamic strTags;
  @JsonKey(name: "strYoutube")
  final String? strYoutube;
  @JsonKey(name: "strIngredient1")
  final String? strIngredient1;
  @JsonKey(name: "strIngredient2")
  final String? strIngredient2;
  @JsonKey(name: "strIngredient3")
  final String? strIngredient3;
  @JsonKey(name: "strIngredient4")
  final String? strIngredient4;
  @JsonKey(name: "strIngredient5")
  final String? strIngredient5;
  @JsonKey(name: "strIngredient6")
  final String? strIngredient6;
  @JsonKey(name: "strIngredient7")
  final String? strIngredient7;
  @JsonKey(name: "strIngredient8")
  final String? strIngredient8;
  @JsonKey(name: "strIngredient9")
  final String? strIngredient9;
  @JsonKey(name: "strIngredient10")
  final String? strIngredient10;
  @JsonKey(name: "strIngredient11")
  final String? strIngredient11;
  @JsonKey(name: "strIngredient12")
  final String? strIngredient12;
  @JsonKey(name: "strIngredient13")
  final String? strIngredient13;
  @JsonKey(name: "strIngredient14")
  final String? strIngredient14;
  @JsonKey(name: "strIngredient15")
  final String? strIngredient15;
  @JsonKey(name: "strIngredient16")
  final String? strIngredient16;
  @JsonKey(name: "strIngredient17")
  final String? strIngredient17;
  @JsonKey(name: "strIngredient18")
  final String? strIngredient18;
  @JsonKey(name: "strIngredient19")
  final String? strIngredient19;
  @JsonKey(name: "strIngredient20")
  final String? strIngredient20;
  @JsonKey(name: "strMeasure1")
  final String? strMeasure1;
  @JsonKey(name: "strMeasure2")
  final String? strMeasure2;
  @JsonKey(name: "strMeasure3")
  final String? strMeasure3;
  @JsonKey(name: "strMeasure4")
  final String? strMeasure4;
  @JsonKey(name: "strMeasure5")
  final String? strMeasure5;
  @JsonKey(name: "strMeasure6")
  final String? strMeasure6;
  @JsonKey(name: "strMeasure7")
  final String? strMeasure7;
  @JsonKey(name: "strMeasure8")
  final String? strMeasure8;
  @JsonKey(name: "strMeasure9")
  final String? strMeasure9;
  @JsonKey(name: "strMeasure10")
  final String? strMeasure10;
  @JsonKey(name: "strMeasure11")
  final String? strMeasure11;
  @JsonKey(name: "strMeasure12")
  final String? strMeasure12;
  @JsonKey(name: "strMeasure13")
  final String? strMeasure13;
  @JsonKey(name: "strMeasure14")
  final String? strMeasure14;
  @JsonKey(name: "strMeasure15")
  final String? strMeasure15;
  @JsonKey(name: "strMeasure16")
  final String? strMeasure16;
  @JsonKey(name: "strMeasure17")
  final String? strMeasure17;
  @JsonKey(name: "strMeasure18")
  final String? strMeasure18;
  @JsonKey(name: "strMeasure19")
  final String? strMeasure19;
  @JsonKey(name: "strMeasure20")
  final String? strMeasure20;
  @JsonKey(name: "strSource")
  final String? strSource;
  @JsonKey(name: "strImageSource")
  final dynamic strImageSource;
  @JsonKey(name: "strCreativeCommonsConfirmed")
  final dynamic strCreativeCommonsConfirmed;
  @JsonKey(name: "dateModified")
  final String? dateModified;

  Meals ({
    this.idMeal,
    this.strMeal,
    this.strMealAlternate,
    this.strCategory,
    this.strArea,
    this.strInstructions,
    this.strMealThumb,
    this.strTags,
    this.strYoutube,
    this.strIngredient1,
    this.strIngredient2,
    this.strIngredient3,
    this.strIngredient4,
    this.strIngredient5,
    this.strIngredient6,
    this.strIngredient7,
    this.strIngredient8,
    this.strIngredient9,
    this.strIngredient10,
    this.strIngredient11,
    this.strIngredient12,
    this.strIngredient13,
    this.strIngredient14,
    this.strIngredient15,
    this.strIngredient16,
    this.strIngredient17,
    this.strIngredient18,
    this.strIngredient19,
    this.strIngredient20,
    this.strMeasure1,
    this.strMeasure2,
    this.strMeasure3,
    this.strMeasure4,
    this.strMeasure5,
    this.strMeasure6,
    this.strMeasure7,
    this.strMeasure8,
    this.strMeasure9,
    this.strMeasure10,
    this.strMeasure11,
    this.strMeasure12,
    this.strMeasure13,
    this.strMeasure14,
    this.strMeasure15,
    this.strMeasure16,
    this.strMeasure17,
    this.strMeasure18,
    this.strMeasure19,
    this.strMeasure20,
    this.strSource,
    this.strImageSource,
    this.strCreativeCommonsConfirmed,
    this.dateModified,
  });

  factory Meals.fromJson(Map<String, dynamic> json) {
    return _$MealsFromJson(json);
  }

  Map<String, dynamic> toJson() {
    return _$MealsToJson(this);
  }
}


