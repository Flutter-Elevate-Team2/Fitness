import 'package:json_annotation/json_annotation.dart';

part 'edit_profile_request.g.dart';

@JsonSerializable()
class EditProfileRequest {
  final String? firstName;
  final String? lastName;
  final String? email;
  final double? weight;
  final String? goal;
  final String? activityLevel;

  EditProfileRequest({
    this.firstName,
    this.lastName,
    this.email,
    this.weight,
    this.goal,
    this.activityLevel,
  });

  Map<String, dynamic> toJson() => _$EditProfileRequestToJson(this);
}
