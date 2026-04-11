import 'package:json_annotation/json_annotation.dart';

part 'register_request.g.dart';

@JsonSerializable()
class RegisterRequest {
  String? firstName;
  String? lastName;
  String? email;
  String? password;
  String? rePassword;
  String? gender;
  num? height;
  num? weight;
  num? age;
  String? goal;
  String? activityLevel;

  RegisterRequest({
    this.firstName,
    this.lastName,
    this.email,
    this.password,
    this.rePassword,
    this.gender,
    this.height,
    this.weight,
    this.age,
    this.goal,
    this.activityLevel,
  });

  factory RegisterRequest.fromJson(Map<String, dynamic> json) {
    return _$RegisterRequestFromJson(json);
  }

  Map<String, dynamic> toJson() => _$RegisterRequestToJson(this);
}
