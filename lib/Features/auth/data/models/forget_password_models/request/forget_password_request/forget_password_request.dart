import 'package:json_annotation/json_annotation.dart';

part 'forget_password_request.g.dart';

@JsonSerializable()
class ForgetPasswordRequest {
  @JsonKey(name: "email")
  final String? email;

  ForgetPasswordRequest({this.email});

  factory ForgetPasswordRequest.fromJson(Map<String, dynamic> json) {
    return _$ForgetPasswordRequestFromJson(json);
  }

  Map<String, dynamic> toJson() {
    return _$ForgetPasswordRequestToJson(this);
  }
}
