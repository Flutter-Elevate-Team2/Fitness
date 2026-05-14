import 'package:fitness_app/Features/auth/data/models/login_models/login_response.dart';
import 'package:fitness_app/Features/auth/domain/entities/login_entity/login_entity.dart';

extension LoginResponseMapper on LoginResponse {
  LoginEntity toEntity() {
    return LoginEntity(message: message, token: token);
  }
}

