import 'package:injectable/injectable.dart';
import 'package:fitness_app/Features/profile/data/models/change_password_request/change_password_request.dart';
import 'package:fitness_app/Features/profile/domain/entities/change_password_entity.dart';
import 'package:fitness_app/Features/profile/domain/repo/profile_repo_contract.dart';
import 'package:fitness_app/core/base_response/base_response.dart';
@injectable
class ChangPasswordUseCase {
  final ProfileRepoContract _contract;
  ChangPasswordUseCase(this._contract);
  Future<BaseResponse<ChangePasswordEntity>> call(ChangePasswordRequest request) async {
    return await _contract.changePassword(request);
  }
}