import 'package:fitness_app/Features/smart_coach/domain/entities/message_entity.dart';
import 'package:fitness_app/Features/smart_coach/domain/repo/smart_coach_repo_contract.dart';
import 'package:injectable/injectable.dart';

/// Sends a user message to Gemini and returns a token-by-token [Stream].
///
/// Returns [Stream<String>] instead of [BaseResponse] because streaming
/// tokens cannot be wrapped in a single response object. Errors propagate
/// via the stream's `onError` callback.
@injectable
class SendMessageUseCase {
  final SmartCoachRepoContract _repo;

  SendMessageUseCase(this._repo);

  Stream<String> call({
    required String sessionId,
    required String userMessage,
    required List<MessageEntity> history,
  }) {
    return _repo.sendMessage(
      sessionId: sessionId,
      userMessage: userMessage,
      history: history,
    );
  }
}
