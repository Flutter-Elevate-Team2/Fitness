import 'package:fitness_app/Features/profile/data/models/change_password_request/change_password_request.dart';

sealed class ChangePasswordEvents {}
class ChangePasswordEvent extends ChangePasswordEvents {
  final ChangePasswordRequest request;

  ChangePasswordEvent({
    required this.request
  });
}