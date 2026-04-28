import 'package:fitness_app/Features/smart_coach/data/models/chat_session_hive_model.dart';
import 'package:fitness_app/Features/smart_coach/data/models/message_hive_model.dart';

/// Contract for Hive-backed local persistence of Smart Coach sessions.
///
/// All Hive access must go through [HiveDatabaseService.instance.openBox]
/// — never call [Hive.openBox] directly.
abstract class SmartCoachLocalDataSourceContract {
  /// Persists a brand-new session (with an empty message list).
  Future<void> saveSession(ChatSessionHiveModel session);

  /// Appends [message] to the session identified by [sessionId].
  Future<void> saveMessage(String sessionId, MessageHiveModel message);

  /// Sets [updatedAt] on the session identified by [sessionId].
  Future<void> updateSessionTimestamp(String sessionId, DateTime updatedAt);

  /// Sets [title] on the session identified by [sessionId].
  Future<void> updateSessionTitle(String sessionId, String title);

  /// Returns every persisted session (unsorted — sorting is the
  /// Repository's responsibility).
  Future<List<ChatSessionHiveModel>> getAllSessions();

  /// Returns a single session, or `null` if not found.
  Future<ChatSessionHiveModel?> getSession(String sessionId);

  /// Permanently deletes the session identified by [sessionId].
  Future<void> deleteSession(String sessionId);

  /// Deletes a specific message from a session.
  ///
  /// Used by the retry flow to remove a failed/partial AI message
  /// before re-invoking the stream.
  Future<void> deleteMessage(String sessionId, String messageId);
}
