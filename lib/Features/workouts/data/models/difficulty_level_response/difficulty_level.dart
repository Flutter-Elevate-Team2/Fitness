import 'package:json_annotation/json_annotation.dart';

part 'difficulty_level.g.dart';

@JsonSerializable()
class DifficultyLevel {
  String? id;
  String? name;

  DifficultyLevel({this.id, this.name});

  factory DifficultyLevel.fromJson(Map<String, dynamic> json) {
    return _$DifficultyLevelFromJson(json);
  }

  Map<String, dynamic> toJson() => _$DifficultyLevelToJson(this);
}
