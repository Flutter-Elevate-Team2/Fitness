import 'package:fitness_app/core/data_base/constants.dart';
import 'package:hive_ce/hive.dart';
import 'package:json_annotation/json_annotation.dart';

part 'meal_model.g.dart';

@HiveType(typeId: HiveTypes.mealModel)
@JsonSerializable()
class MealModel {
  @HiveField(0)
  final String? strMeal;
  @HiveField(1)
  final String? strMealThumb;
  @HiveField(2)
  final String? idMeal;

  MealModel({this.strMeal, this.strMealThumb, this.idMeal});

  factory MealModel.fromJson(Map<String, dynamic> json) =>
      _$MealModelFromJson(json);
  Map<String, dynamic> toJson() => _$MealModelToJson(this);
}
