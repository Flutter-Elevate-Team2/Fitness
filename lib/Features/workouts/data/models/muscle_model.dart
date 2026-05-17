import 'package:hive_ce/hive.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:fitness_app/core/data_base/constants.dart';

part 'muscle_model.g.dart';

@HiveType(typeId: HiveTypes.muscle)
@JsonSerializable()
class MuscleModel extends HiveObject {
  @HiveField(0)
  @JsonKey(name: '_id')
  final String id;

  @HiveField(1)
  final String name;

  @HiveField(2)
  final String? image;

  MuscleModel({
    required this.id,
    required this.name,
    this.image,
  });

  factory MuscleModel.fromJson(Map<String, dynamic> json) => _$MuscleModelFromJson(json);
  Map<String, dynamic> toJson() => _$MuscleModelToJson(this);
}
