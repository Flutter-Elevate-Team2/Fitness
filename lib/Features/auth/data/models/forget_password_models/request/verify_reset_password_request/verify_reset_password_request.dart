import 'package:json_annotation/json_annotation.dart';

part 'verify_reset_password_request.g.dart';

@JsonSerializable()
class VerifyResetPasswordRequest {
  @JsonKey(name: "resetCode")
  final String? resetCode;

  VerifyResetPasswordRequest({this.resetCode});

  factory VerifyResetPasswordRequest.fromJson(Map<String, dynamic> json) {
    return _$VerifyResetPasswordRequestFromJson(json);
  }

  Map<String, dynamic> toJson() {
    return _$VerifyResetPasswordRequestToJson(this);
  }
}
