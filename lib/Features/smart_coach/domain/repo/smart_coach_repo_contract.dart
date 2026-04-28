import 'package:fitness_app/Features/smart_coach/domain/entities/chat_session_entity.dart';
import 'package:fitness_app/Features/smart_coach/domain/entities/message_entity.dart';
import 'package:fitness_app/core/base_response/base_response.dart';

/// Repository contract for the Smart Coach chat feature.
///
/// The implementation owns:
///  - Sliding-window slicing (last 20 messages) before every Gemini call.
///  - `updatedAt` timestamp management on every [saveMessage].
///  - Session title generation from the first user message.
abstract class SmartCoachRepoContract {
  /// Creates a new empty chat session with a generated ID.
  ///
  /// [defaultTitle] is the localized default session title, passed from
  /// the presentation layer since the repo has no access to [BuildContext].
  Future<BaseResponse<ChatSessionEntity>> createSession({
    required String defaultTitle,
  });

  /// Sends the user message + history context to Gemini and returns a
  /// token-by-token stream.
  ///
  /// [history] should include the latest user message. The implementation
  /// applies a sliding window (last 20 messages) and prepends system
  /// instructions before calling the Gemini API.
  Stream<String> sendMessage({
    required String sessionId,
    required String userMessage,
    required List<MessageEntity> history,
  });

  /// Persists [message] into [sessionId] and updates `session.updatedAt`.
  ///
  /// On the first user message the implementation also generates the
  /// session title from the message content.
  ///
  /// [defaultTitle] is compared against the current title to decide
  /// whether title generation is needed.
  Future<BaseResponse<void>> saveMessage({
    required String sessionId,
    required MessageEntity message,
    required String defaultTitle,
  });

  /// Returns all sessions sorted by `updatedAt` descending.
  Future<BaseResponse<List<ChatSessionEntity>>> getChatHistory();

  /// Permanently deletes the session identified by [sessionId].
  Future<BaseResponse<void>> deleteSession(String sessionId);

  /// Deletes a single message from a session.
  ///
  /// Used by the retry flow to remove a failed/partial AI message
  /// before re-invoking [sendMessage].
  Future<BaseResponse<void>> deleteMessage({
    required String sessionId,
    required String messageId,
  });
}
