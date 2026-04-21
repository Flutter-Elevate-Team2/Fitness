import 'package:fitness_app/core/data_base/constants.dart';
import 'package:hive_ce/hive.dart';
import 'package:json_annotation/json_annotation.dart';

part 'muscle_group_model.g.dart';

@HiveType(typeId: HiveTypes.muscleGroup)
@JsonSerializable()
class MuscleGroupModel extends HiveObject {
  @HiveField(0)
  @JsonKey(name: '_id')
  final String id;

  @HiveField(1)
  final String name;

  MuscleGroupModel({
    required this.id,
    required this.name,
  });

  factory MuscleGroupModel.fromJson(Map<String, dynamic> json) => _$MuscleGroupModelFromJson(json);
  Map<String, dynamic> toJson() => _$MuscleGroupModelToJson(this);
}
