import 'package:json_annotation/json_annotation.dart';

import 'exercise.dart';

part 'exercises_response.g.dart';

@JsonSerializable()
class ExercisesResponse {
  String? message;
  num? totalExercises;
  num? totalPages;
  num? currentPage;
  List<Exercise>? exercises;

  ExercisesResponse({
    this.message,
    this.totalExercises,
    this.totalPages,
    this.currentPage,
    this.exercises,
  });

  factory ExercisesResponse.fromJson(Map<String, dynamic> json) {
    return _$ExercisesResponseFromJson(json);
  }

  Map<String, dynamic> toJson() => _$ExercisesResponseToJson(this);
}
