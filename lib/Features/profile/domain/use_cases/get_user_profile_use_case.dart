import 'package:fitness_app/Features/profile/domain/entities/user_entity.dart';
import 'package:fitness_app/Features/profile/domain/repo/profile_repo_contract.dart';
import 'package:fitness_app/core/base_response/base_response.dart';
import 'package:injectable/injectable.dart';

@injectable
class GetUserProfileUseCase {
  final ProfileRepoContract _repo;

  @factoryMethod
  GetUserProfileUseCase(this._repo);

  Future<BaseResponse<UserEntity>> call() async {
    return await _repo.getUserProfile();
  }
}
