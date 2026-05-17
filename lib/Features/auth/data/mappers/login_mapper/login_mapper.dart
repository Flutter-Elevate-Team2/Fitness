import 'package:fitness_app/Features/auth/data/models/login_models/login_response.dart';
import 'package:fitness_app/Features/auth/domain/entities/login_entity/login_entity.dart';
import 'package:fitness_app/Features/profile/domain/entities/user_entity.dart';

extension LoginResponseMapper on LoginResponse {
  LoginEntity toEntity() {
    UserEntity? userEntity;
    if (user != null) {
      userEntity = UserEntity(
        id: user!.id ?? '',
        firstName: user!.firstName ?? '',
        lastName: user!.lastName ?? '',
        email: user!.email ?? '',
        gender: user!.gender ?? '',
        age: user!.age ?? 0,
        weight: user!.weight ?? 0,
        height: user!.height ?? 0,
        activityLevel: user!.activityLevel ?? '',
        goal: user!.goal ?? '',
        photo: user!.photo ?? '',
      );
    }

    return LoginEntity(
      message: message,
      token: token,
      user: userEntity,
    );
  }
}
