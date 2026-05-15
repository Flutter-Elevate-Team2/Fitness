import 'package:json_annotation/json_annotation.dart';
import 'package:fitness_app/Features/workouts/data/models/muscle_group_model.dart';
import 'package:fitness_app/Features/workouts/data/models/muscle_model.dart';

part 'muscles_by_group_response.g.dart';

@JsonSerializable()
class MusclesByGroupResponse {
  final String? message;
  final MuscleGroupModel? muscleGroup;
  final List<MuscleModel>? muscles;

  MusclesByGroupResponse({
    this.message,
    this.muscleGroup,
    this.muscles,
  });

  factory MusclesByGroupResponse.fromJson(Map<String, dynamic> json) => _$MusclesByGroupResponseFromJson(json);
  Map<String, dynamic> toJson() => _$MusclesByGroupResponseToJson(this);
}
