import 'package:fitness_app/Features/smart_coach/domain/entities/message_entity.dart';
import 'package:fitness_app/Features/smart_coach/domain/repo/smart_coach_repo_contract.dart';
import 'package:fitness_app/core/base_response/base_response.dart';
import 'package:injectable/injectable.dart';

/// Persists a [MessageEntity] into the given session.
///
/// The repository implementation handles:
///  - Updating `session.updatedAt` to [DateTime.now].
///  - Generating the session title on the first user message.
@injectable
class SaveMessageUseCase {
  final SmartCoachRepoContract _repo;

  SaveMessageUseCase(this._repo);

  Future<BaseResponse<void>> call({
    required String sessionId,
    required MessageEntity message,
    required String defaultTitle,
  }) {
    return _repo.saveMessage(
      sessionId: sessionId,
      message: message,
      defaultTitle: defaultTitle,
    );
  }
}
