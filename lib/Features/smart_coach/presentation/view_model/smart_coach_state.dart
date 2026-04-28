import 'package:fitness_app/Features/smart_coach/domain/entities/chat_session_entity.dart';
import 'package:fitness_app/Features/smart_coach/domain/entities/message_entity.dart';

/// Sealed state hierarchy for the Smart Coach chat feature.
///
/// Uses Dart 3+ sealed class — no Freezed (CLAUDE.md §B.2).
sealed class SmartCoachState {
  const SmartCoachState();
}

/// Initial state before any action is taken.
class SmartCoachInitial extends SmartCoachState {
  const SmartCoachInitial();
}

/// Loading indicator (e.g. while fetching history or creating a session).
class SmartCoachLoading extends SmartCoachState {
  const SmartCoachLoading();
}

/// Session history loaded — used by the history/side panel.
class SmartCoachSessionLoaded extends SmartCoachState {
  final List<ChatSessionEntity> sessions;

  const SmartCoachSessionLoaded({required this.sessions});
}

/// AI response is actively streaming — tokens arriving chunk by chunk.
///
/// The UI should disable the input field while in this state.
class SmartCoachStreaming extends SmartCoachState {
  final List<MessageEntity> messages;

  const SmartCoachStreaming({required this.messages});
}

/// Stream completed successfully — all tokens received and saved.
class SmartCoachStreamDone extends SmartCoachState {
  final List<MessageEntity> messages;

  const SmartCoachStreamDone({required this.messages});
}

/// An error occurred (network failure, socket exception, etc.).
///
/// [messages] is preserved so the UI can still display the conversation
/// alongside the error indicator and retry button.
class SmartCoachError extends SmartCoachState {
  final String errorMessage;
  final List<MessageEntity> messages;

  const SmartCoachError({
    required this.errorMessage,
    required this.messages,
  });
}

/// Gemini blocked the response due to safety filters.
///
/// [messages] is preserved so the UI can display the safety-block bubble
/// within the conversation context.
class SmartCoachSafetyBlocked extends SmartCoachState {
  final List<MessageEntity> messages;

  const SmartCoachSafetyBlocked({required this.messages});
}
