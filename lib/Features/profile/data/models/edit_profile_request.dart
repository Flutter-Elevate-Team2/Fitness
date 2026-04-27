import 'package:json_annotation/json_annotation.dart';

part 'edit_profile_request.g.dart';

@JsonSerializable()
class EditProfileRequest {
  final String? firstName;
  final String? lastName;
  final String? email;
  final String? phone;

  EditProfileRequest({this.firstName, this.lastName, this.email, this.phone});

  Map<String, dynamic> toJson() => _$EditProfileRequestToJson(this);
}
