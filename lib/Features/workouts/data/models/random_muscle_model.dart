import 'package:hive_ce/hive.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:fitness_app/core/data_base/constants.dart';

part 'random_muscle_model.g.dart';

@HiveType(typeId: HiveTypes.randomMuscle)
@JsonSerializable()
class RandomMuscleModel extends HiveObject {
  @HiveField(0)
  @JsonKey(name: '_id')
  final String id;
  @HiveField(1)
  final String name;
  @HiveField(2)
  final String image;

  RandomMuscleModel({
    required this.id,
    required this.name,
    required this.image,
  });

  factory RandomMuscleModel.fromJson(Map<String, dynamic> json) =>
      _$RandomMuscleModelFromJson(json);
  Map<String, dynamic> toJson() => _$RandomMuscleModelToJson(this);
}
