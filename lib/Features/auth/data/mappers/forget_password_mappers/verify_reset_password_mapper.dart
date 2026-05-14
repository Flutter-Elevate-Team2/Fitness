import 'package:fitness_app/Features/auth/data/models/forget_password_models/response/verify_reset_password_response/verify_reset_password_response.dart';
import 'package:fitness_app/Features/auth/domain/entities/forget_password_entities/verify_reset_password_entity.dart';

extension VerifyResetPasswordMapper on VerifyResetPasswordResponse {
  VerifyResetPasswordEntity toEntity() {
    return VerifyResetPasswordEntity(status: status ?? '');
  }
}
