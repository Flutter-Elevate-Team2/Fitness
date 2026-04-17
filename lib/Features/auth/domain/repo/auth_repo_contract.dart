import 'package:fitness_app/Features/auth/data/models/login_models/login_request.dart';
import 'package:fitness_app/Features/auth/domain/entities/login_entity/login_entity.dart';
import 'package:fitness_app/core/base_response/base_response.dart';

abstract class AuthRepoContract {
  Future<BaseResponse<LoginEntity>> login(
    LoginRequest request
  );
  Future<bool> isLoggedIn();
  void clearSession();
}
