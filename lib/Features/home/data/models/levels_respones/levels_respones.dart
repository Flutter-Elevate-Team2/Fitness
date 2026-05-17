import 'package:json_annotation/json_annotation.dart';

import 'level.dart';

part 'levels_respones.g.dart';

@JsonSerializable()
class LevelsRespones {
  String? message;
  List<Level>? levels;

  LevelsRespones({this.message, this.levels});

  factory LevelsRespones.fromJson(Map<String, dynamic> json) {
    return _$LevelsResponesFromJson(json);
  }

  Map<String, dynamic> toJson() => _$LevelsResponesToJson(this);
}
