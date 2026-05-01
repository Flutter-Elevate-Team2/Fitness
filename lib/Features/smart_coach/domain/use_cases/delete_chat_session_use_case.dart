import 'package:fitness_app/Features/smart_coach/domain/repo/smart_coach_repo_contract.dart';
import 'package:fitness_app/core/base_response/base_response.dart';
import 'package:injectable/injectable.dart';

/// Permanently deletes a chat session by its [sessionId].
@injectable
class DeleteChatSessionUseCase {
  final SmartCoachRepoContract _repo;

  DeleteChatSessionUseCase(this._repo);

  Future<BaseResponse<void>> call(String sessionId) {
    return _repo.deleteSession(sessionId);
  }
}
