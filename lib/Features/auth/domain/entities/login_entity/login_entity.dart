import 'package:fitness_app/Features/profile/domain/entities/user_entity.dart';

class LoginEntity {
  final String? message;
  final String? token;
  final UserEntity? user;

  LoginEntity({required this.token, required this.message, this.user});
}
