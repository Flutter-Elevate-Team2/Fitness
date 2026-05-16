import 'package:injectable/injectable.dart';
import 'package:fitness_app/Features/profile/domain/repo/profile_repo_contract.dart';
import 'package:fitness_app/core/base_response/base_response.dart';

@injectable
class LogoutUseCase {
  final ProfileRepoContract _repo;

  LogoutUseCase(this._repo);

  Future<BaseResponse<String>> call() async {
    return await _repo.logout();
  }
}
