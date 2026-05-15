import 'package:fitness_app/Features/auth/domain/entities/register_params.dart';
import 'package:fitness_app/Features/auth/domain/entities/user_entity.dart';
import 'package:fitness_app/Features/auth/domain/repo/auth_repo_contract.dart';
import 'package:fitness_app/core/base_response/base_response.dart';
import 'package:injectable/injectable.dart';

@injectable
class RegisterUseCase {
  final AuthRepoContract _authRepositoryContract;
  @factoryMethod
  RegisterUseCase(this._authRepositoryContract);
  Future<BaseResponse<UserEntity>> register(RegisterParams params) {
    return _authRepositoryContract.register(params);
  }
}
