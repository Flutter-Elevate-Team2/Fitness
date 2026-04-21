import 'package:json_annotation/json_annotation.dart';

import 'difficulty_level.dart';

part 'difficulty_level_response.g.dart';

@JsonSerializable()
class DifficultyLevelResponse {
  String? message;
  num? totalLevels;
  @JsonKey(name: 'difficulty_levels')
  List<DifficultyLevel>? difficultyLevels;

  DifficultyLevelResponse({
    this.message,
    this.totalLevels,
    this.difficultyLevels,
  });

  factory DifficultyLevelResponse.fromJson(Map<String, dynamic> json) {
    return _$DifficultyLevelResponseFromJson(json);
  }

  Map<String, dynamic> toJson() => _$DifficultyLevelResponseToJson(this);
}
