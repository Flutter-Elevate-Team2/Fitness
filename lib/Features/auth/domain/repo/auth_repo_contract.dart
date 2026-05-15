import 'package:fitness_app/Features/auth/domain/entities/register_params.dart';
import 'package:fitness_app/Features/auth/domain/entities/user_entity.dart';
import 'package:fitness_app/core/base_response/base_response.dart';

abstract class AuthRepoContract {
  Future<BaseResponse<UserEntity>> register(RegisterParams params);
}
