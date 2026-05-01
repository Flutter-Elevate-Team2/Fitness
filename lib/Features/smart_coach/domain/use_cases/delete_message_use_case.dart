import 'package:fitness_app/Features/smart_coach/domain/repo/smart_coach_repo_contract.dart';
import 'package:fitness_app/core/base_response/base_response.dart';
import 'package:injectable/injectable.dart';

/// Deletes a single message from a session in Hive.
///
/// Used by the retry flow to remove a failed/partial AI message
/// before re-invoking [SendMessageUseCase].
@injectable
class DeleteMessageUseCase {
  final SmartCoachRepoContract _repo;

  DeleteMessageUseCase(this._repo);

  Future<BaseResponse<void>> call({
    required String sessionId,
    required String messageId,
  }) {
    return _repo.deleteMessage(sessionId: sessionId, messageId: messageId);
  }
}
