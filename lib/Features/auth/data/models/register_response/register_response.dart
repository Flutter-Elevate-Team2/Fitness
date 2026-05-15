import 'package:json_annotation/json_annotation.dart';

import 'user.dart';

part 'register_response.g.dart';

@JsonSerializable()
class RegisterResponse {
  String? message;
  User? user;
  String? token;

  RegisterResponse({this.message, this.user, this.token});

  factory RegisterResponse.fromJson(Map<String, dynamic> json) {
    return _$RegisterResponseFromJson(json);
  }

  Map<String, dynamic> toJson() => _$RegisterResponseToJson(this);
}
