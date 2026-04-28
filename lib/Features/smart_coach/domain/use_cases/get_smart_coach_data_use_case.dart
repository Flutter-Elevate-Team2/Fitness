import 'package:fitness_app/Features/smart_coach/domain/entities/smart_coach_entity.dart';
import 'package:fitness_app/Features/smart_coach/domain/repo/smart_coach_repo_contract.dart';
import 'package:fitness_app/core/base_response/base_response.dart';
import 'package:injectable/injectable.dart';

@injectable
class GetSmartCoachDataUseCase {
  final SmartCoachRepoContract _repo;

  GetSmartCoachDataUseCase(this._repo);

  Future<BaseResponse<SmartCoachEntity>> call() async {
    return await _repo.getSmartCoachData();
  }
}
