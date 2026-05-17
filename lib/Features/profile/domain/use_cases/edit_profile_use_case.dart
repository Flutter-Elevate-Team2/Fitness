import 'package:fitness_app/Features/profile/domain/entities/user_entity.dart';
import 'package:injectable/injectable.dart';
import 'package:fitness_app/Features/profile/data/models/edit_profile_request.dart';
 import 'package:fitness_app/Features/profile/domain/repo/profile_repo_contract.dart';
import 'package:fitness_app/core/base_response/base_response.dart';
@injectable
class EditProfileUseCase {
  final ProfileRepoContract _repo;
  EditProfileUseCase(this._repo);
  Future<BaseResponse<UserEntity>> call(EditProfileRequest request) async {
    return await _repo.editProfile(request);
  }
  
}