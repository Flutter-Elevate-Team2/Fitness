import 'package:json_annotation/json_annotation.dart';

part 'change_password_response.g.dart';

@JsonSerializable()
class ChangePasswordResponse {
  String? message;
  String? token;

  ChangePasswordResponse({this.message, this.token});

  factory ChangePasswordResponse.fromJson(Map<String, dynamic> json) {
    return _$ChangePasswordResponseFromJson(json);
  }

  Map<String, dynamic> toJson() => _$ChangePasswordResponseToJson(this);
}
