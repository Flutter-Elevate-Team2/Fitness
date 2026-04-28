import 'package:json_annotation/json_annotation.dart';

part 'smart_coach_response.g.dart';

@JsonSerializable()
class SmartCoachResponse {
  @JsonKey(name: 'id')
  final String? id;
  @JsonKey(name: 'message')
  final String? message;

  SmartCoachResponse({this.id, this.message});

  factory SmartCoachResponse.fromJson(Map<String, dynamic> json) =>
      _$SmartCoachResponseFromJson(json);

  Map<String, dynamic> toJson() => _$SmartCoachResponseToJson(this);
}
