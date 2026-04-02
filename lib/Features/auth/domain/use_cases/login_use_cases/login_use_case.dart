import 'package:fitness_app/Features/auth/data/models/login_models/login_request.dart';
import 'package:fitness_app/Features/auth/domain/entities/login_entity/login_entity.dart';
import 'package:fitness_app/Features/auth/domain/repo/auth_repo_contract.dart';
import 'package:fitness_app/core/base_response/base_response.dart';
import 'package:injectable/injectable.dart';

@injectable
class LoginUseCase {
  final AuthRepoContract _authRepo;

  LoginUseCase(this._authRepo);

  Future<BaseResponse<LoginEntity>> call(
      LoginRequest request, {
        required bool isRememberMe,
      }) {
    return _authRepo.login(request, isRememberMe);
  }
}
