import 'package:fitness_app/Features/smart_coach/domain/entities/chat_session_entity.dart';
import 'package:fitness_app/Features/smart_coach/domain/repo/smart_coach_repo_contract.dart';
import 'package:fitness_app/core/base_response/base_response.dart';
import 'package:injectable/injectable.dart';

/// Creates a new empty [ChatSessionEntity] with a repository-generated ID.
@injectable
class CreateChatSessionUseCase {
  final SmartCoachRepoContract _repo;

  CreateChatSessionUseCase(this._repo);

  Future<BaseResponse<ChatSessionEntity>> call({
    required String defaultTitle,
  }) {
    return _repo.createSession(defaultTitle: defaultTitle);
  }
}
