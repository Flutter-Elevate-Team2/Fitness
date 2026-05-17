
import 'package:fitness_app/Features/profile/data/models/change_password_response/change_password_response.dart';
import '../../domain/entities/change_password_entity.dart';

extension ChangePasswordMapper on ChangePasswordResponse {
  ChangePasswordEntity toEntity() {
    return ChangePasswordEntity(
      message: message ?? '',
      token: token ?? '',
    );
  }
}