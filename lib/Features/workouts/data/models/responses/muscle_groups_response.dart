import 'package:json_annotation/json_annotation.dart';
import 'package:fitness_app/Features/workouts/data/models/muscle_group_model.dart';

part 'muscle_groups_response.g.dart';

@JsonSerializable()
class MuscleGroupsResponse {
  final String? message;
  final List<MuscleGroupModel>? musclesGroup;

  MuscleGroupsResponse({
    this.message,
    this.musclesGroup,
  });

  factory MuscleGroupsResponse.fromJson(Map<String, dynamic> json) => _$MuscleGroupsResponseFromJson(json);
  Map<String, dynamic> toJson() => _$MuscleGroupsResponseToJson(this);
}
