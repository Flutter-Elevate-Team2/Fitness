import 'package:fitness_app/Features/smart_coach/domain/entities/chat_session_entity.dart';
import 'package:fitness_app/Features/smart_coach/domain/repo/smart_coach_repo_contract.dart';
import 'package:fitness_app/core/base_response/base_response.dart';
import 'package:injectable/injectable.dart';

/// Returns all chat sessions sorted by `updatedAt` descending.
///
/// This is a one-shot [Future]. The Cubit must explicitly re-invoke
/// this use case after any [deleteSession] or [saveMessage] operation
/// to keep the history panel in sync.
@injectable
class GetChatHistoryUseCase {
  final SmartCoachRepoContract _repo;

  GetChatHistoryUseCase(this._repo);

  Future<BaseResponse<List<ChatSessionEntity>>> call() {
    return _repo.getChatHistory();
  }
}
