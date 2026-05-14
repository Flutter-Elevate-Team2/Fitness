import 'package:fitness_app/Features/auth/domain/repo/auth_repo_contract.dart';
import 'package:injectable/injectable.dart';
import 'package:fitness_app/Features/auth/data/models/forget_password_models/request/forget_password_request/forget_password_request.dart';
 import 'package:fitness_app/Features/auth/domain/entities/forget_password_entities/forget_password_entity.dart';
import 'package:fitness_app/core/base_response/base_response.dart';

@injectable
class ForgetPasswordUseCase {
  final AuthRepoContract _authRepoContract;

  ForgetPasswordUseCase(this._authRepoContract);

  Future<BaseResponse<ForgetPasswordEntity>> forgetPassword(
    ForgetPasswordRequest request,
  ) async {
    return await _authRepoContract.forgetPassword(request);
  }
}
