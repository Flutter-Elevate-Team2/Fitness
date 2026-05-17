import 'package:fitness_app/core/data_base/constants.dart';
import 'package:hive_ce/hive.dart';
import 'package:json_annotation/json_annotation.dart';

part 'meal_details_model.g.dart';

@HiveType(typeId: HiveTypes.mealDetailsModel)
@JsonSerializable(createFactory: false)
class MealDetailsModel {
  @HiveField(0)
  @JsonKey(name: "idMeal")
  final String? idMeal;

  @HiveField(1)
  @JsonKey(name: "strMeal")
  final String? strMeal;

  @HiveField(2)
  @JsonKey(name: "strCategory")
  final String? strCategory;

  @HiveField(3)
  @JsonKey(name: "strArea")
  final String? strArea;

  @HiveField(4)
  @JsonKey(name: "strInstructions")
  final String? strInstructions;

  @HiveField(5)
  @JsonKey(name: "strMealThumb")
  final String? strMealThumb;

  @HiveField(6)
  @JsonKey(name: "strYoutube")
  final String? strYoutube;

  @HiveField(7)
  final List<String> ingredients;

  @HiveField(8)
  final List<String> measures;

  MealDetailsModel({
    this.idMeal,
    this.strMeal,
    this.strCategory,
    this.strArea,
    this.strInstructions,
    this.strMealThumb,
    this.strYoutube,
    this.ingredients = const [],
    this.measures = const [],
  });
  factory MealDetailsModel.fromJson(Map<String, dynamic> json) {
    List<String> ingredients = [];
    List<String> measures = [];

    for (int i = 1; i <= 20; i++) {
      final ingredient = json['strIngredient$i'];
      final measure = json['strMeasure$i'];

      if (ingredient != null && ingredient.toString().trim().isNotEmpty) {
        ingredients.add(ingredient);
      }
      if (measure != null && measure.toString().trim().isNotEmpty) {
        measures.add(measure);
      }
    }

    return MealDetailsModel(
      idMeal: json['idMeal'],
      strMeal: json['strMeal'],
      strCategory: json['strCategory'],
      strArea: json['strArea'],
      strInstructions: json['strInstructions'],
      strMealThumb: json['strMealThumb'],
      strYoutube: json['strYoutube'],
      ingredients: ingredients,
      measures: measures,
    );
  }

  Map<String, dynamic> toJson() => _$MealDetailsModelToJson(this);
}
