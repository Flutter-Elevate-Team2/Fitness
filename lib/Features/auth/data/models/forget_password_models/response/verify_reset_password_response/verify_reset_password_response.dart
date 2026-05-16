import 'package:json_annotation/json_annotation.dart';

part 'verify_reset_password_response.g.dart';

@JsonSerializable()
class VerifyResetPasswordResponse {
  @JsonKey(name: "status")
  final String? status;

  VerifyResetPasswordResponse({this.status});

  factory VerifyResetPasswordResponse.fromJson(Map<String, dynamic> json) {
    return _$VerifyResetPasswordResponseFromJson(json);
  }

  Map<String, dynamic> toJson() {
    return _$VerifyResetPasswordResponseToJson(this);
  }
}
