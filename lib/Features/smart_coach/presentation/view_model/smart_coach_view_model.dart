import 'dart:async';

import 'package:fitness_app/Features/smart_coach/domain/entities/chat_session_entity.dart';
import 'package:fitness_app/Features/smart_coach/domain/entities/message_entity.dart';
import 'package:fitness_app/Features/smart_coach/domain/use_cases/create_chat_session_use_case.dart';
import 'package:fitness_app/Features/smart_coach/domain/use_cases/delete_chat_session_use_case.dart';
import 'package:fitness_app/Features/smart_coach/domain/use_cases/delete_message_use_case.dart';
import 'package:fitness_app/Features/smart_coach/domain/use_cases/get_chat_history_use_case.dart';
import 'package:fitness_app/Features/smart_coach/domain/use_cases/save_message_use_case.dart';
import 'package:fitness_app/Features/smart_coach/domain/use_cases/send_message_use_case.dart';
import 'package:fitness_app/Features/smart_coach/domain/utils/id_generator.dart';
import 'package:fitness_app/Features/smart_coach/presentation/view_model/smart_coach_state.dart';
import 'package:fitness_app/core/base_response/base_response.dart';
import 'package:fitness_app/core/errors/gemini_safety_exception.dart';
import 'package:fitness_app/core/errors/handel_errors.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';

/// ViewModel (Cubit) for the Smart Coach chat feature.
///
/// Depends exclusively on use cases — never on repositories or data sources
/// (CLAUDE.md §B.1).
///
/// Fix #9: All user-facing strings are passed as parameters from the UI layer
/// via [setLocalizedStrings]. The ViewModel never hard-codes display text.
@injectable
class SmartCoachViewModel extends Cubit<SmartCoachState> {
  final CreateChatSessionUseCase _createSession;
  final SendMessageUseCase _sendMessage;
  final SaveMessageUseCase _saveMessage;
  final GetChatHistoryUseCase _getChatHistory;
  final DeleteChatSessionUseCase _deleteChatSession;
  final DeleteMessageUseCase _deleteMessage;

  SmartCoachViewModel(
    this._createSession,
    this._sendMessage,
    this._saveMessage,
    this._getChatHistory,
    this._deleteChatSession,
    this._deleteMessage,
  ) : super(const SmartCoachInitial());

  // ─── Internal State ────────────────────────────────────────────────────────

  /// List of all chat sessions for the history panel.
  List<ChatSessionEntity> historySessions = [];

  /// Messages in **reverse chronological** order (newest at index 0)
  /// to match `ListView(reverse: true)`.
  final List<MessageEntity> _messages = [];

  String? _currentSessionId;
  StreamSubscription<String>? _streamSubscription;

  /// Last user message — kept for retry (refinement #3).
  MessageEntity? _lastUserMessage;

  /// Accumulated AI content during streaming.
  String _partialAiContent = '';

  /// ID of the AI message currently being streamed.
  String? _currentAiMessageId;

  bool _isStreaming = false;

  // ── Localized strings (Fix #9) ──
  String _defaultSessionTitle = '';
  String _safetyBlockMessage = '';

  // ─── Public Getters ────────────────────────────────────────────────────────

  /// `true` while the AI stream is active — UI disables input.
  bool get isStreaming => _isStreaming;

  /// Active session ID, if any.
  String? get currentSessionId => _currentSessionId;

  // ─── Localization Injection (Fix #9) ───────────────────────────────────────

  /// Must be called once from the UI layer (via `context.l10n`) before
  /// any action that needs localized strings.
  void setLocalizedStrings({
    required String defaultSessionTitle,
    required String safetyBlockMessage,
  }) {
    _defaultSessionTitle = defaultSessionTitle;
    _safetyBlockMessage = safetyBlockMessage;
  }

  // ─── Load Chat History ─────────────────────────────────────────────────────

  /// Fetches all sessions sorted by `updatedAt` DESC.
  ///
  /// Must be re-called after [deleteSession] or [sendMessage]
  /// to keep the history panel in sync (refinement #6).
  void loadHistory() async {
    // Show loading only if we are not already in a chat
    if (state is SmartCoachInitial || state is SmartCoachLoading) {
      emit(const SmartCoachLoading());
    }

    final result = await _getChatHistory();

    switch (result) {
      case SuccessResponse(:final data):
        historySessions = data; // Save to the new variable

        // If the user is NOT in a chat, show the welcome screen state
        if (_currentSessionId == null) {
          emit(SmartCoachSessionLoaded(sessions: data));
        } else {
          // If the user IS in a chat, just re-emit the chat state to refresh the UI quietly
          emit(SmartCoachStreamDone(messages: List.unmodifiable(_messages)));
        }
      case ErrorResponse(:final errorMessage):
        if (_currentSessionId == null) {
          emit(SmartCoachError(errorMessage: errorMessage, messages: const []));
        }
    }
  }

  // ─── Create Session ────────────────────────────────────────────────────────

  /// Creates a new empty session and returns its ID.
  ///
  /// Returns `null` if creation failed.
  Future<String?> createSession() async {
    final result = await _createSession(defaultTitle: _defaultSessionTitle);

    switch (result) {
      case SuccessResponse(:final data):
        _currentSessionId = data.id;
        _messages.clear();
        emit(SmartCoachStreamDone(messages: List.unmodifiable(_messages)));
        return data.id;
      case ErrorResponse(:final errorMessage):
        emit(SmartCoachError(errorMessage: errorMessage, messages: const []));
        return null;
    }
  }

  // ─── Load Existing Session ─────────────────────────────────────────────────

  /// Opens a session from history — populates messages and jumps to bottom.
  void loadSession(String sessionId, List<MessageEntity> messages) {
    _currentSessionId = sessionId;
    _messages
      ..clear()
      ..addAll(messages.reversed); // reverse to newest-first
    emit(SmartCoachStreamDone(messages: List.unmodifiable(_messages)));
  }

  // ─── Send Message ──────────────────────────────────────────────────────────

  /// Sends a user message and starts streaming the AI response.
  ///
  /// Input is locked ([isStreaming] = true) until the stream completes
  /// or an error occurs.
  void sendMessage(String sessionId, String text) async {
    if (_isStreaming || text.trim().isEmpty) return;

    _isStreaming = true;
    _currentSessionId = sessionId;

    // 1. Create user message.
    final userMessage = MessageEntity(
      id: SmartCoachIdGenerator.messageId(),
      content: text.trim(),
      isUser: true,
      timestamp: DateTime.now(),
    );
    _lastUserMessage = userMessage;

    // FIX #2: Capture history BEFORE inserting user message into _messages.
    final chronologicalHistory = _messages.reversed.toList()..add(userMessage);

    // 2. Insert user message into UI list (index 0 for reversed ListView).
    _messages.insert(0, userMessage);
    emit(SmartCoachStreaming(messages: List.unmodifiable(_messages)));

    // 3. Persist user message.
    await _saveMessage(
      sessionId: sessionId,
      message: userMessage,
      defaultTitle: _defaultSessionTitle,
    );

    // FIX #3: Delegate stream logic to extracted method.
    _startGeminiStream(sessionId, text.trim(), chronologicalHistory);
  }

  // ─── Retry Last Message (Fix #3) ───────────────────────────────────────────

  /// Retries the last failed message (refinement #3).
  ///
  /// FIX #3: Does NOT re-save the user message. Only deletes the failed
  /// AI message, creates a new placeholder, and calls [_startGeminiStream].
  void retryLastMessage() async {
    if (_lastUserMessage == null || _currentSessionId == null) return;
    if (_isStreaming) return;

    _isStreaming = true;

    // Remove failed AI message (index 0 if it's not a user message).
    if (_messages.isNotEmpty && !_messages[0].isUser) {
      final failedAiMessage = _messages.removeAt(0);
      await _deleteMessage(
        sessionId: _currentSessionId!,
        messageId: failedAiMessage.id,
      );
    }

    // Build chronological history from current _messages (user msg is already in list).
    final chronologicalHistory = _messages.reversed.toList();

    // Start a new stream — no duplicate user message save.
    _startGeminiStream(
      _currentSessionId!,
      _lastUserMessage!.content,
      chronologicalHistory,
    );
  }

  // ─── Delete Session ────────────────────────────────────────────────────────

  /// Deletes a session and reloads history (refinement #6).
  void deleteSession(String sessionId) async {
    await _deleteChatSession(sessionId);

    // Clear current chat if the deleted session was active.
    if (_currentSessionId == sessionId) {
      _currentSessionId = null;
      _messages.clear();
    }

    // Re-fetch history to keep the panel in sync.
    loadHistory();
  }

  // ─── Lifecycle ─────────────────────────────────────────────────────────────

  /// Cancels the active stream and saves partial content (edge case #2).
  @override
  Future<void> close() async {
    if (_isStreaming &&
        _currentSessionId != null &&
        _partialAiContent.isNotEmpty) {
      // Save whatever content arrived before cancellation.
      final partialMessage = MessageEntity(
        id: _currentAiMessageId ?? SmartCoachIdGenerator.messageId(),
        content: _partialAiContent,
        isUser: false,
        timestamp: DateTime.now(),
        isPartial: true,
      );
      await _saveMessage(
        sessionId: _currentSessionId!,
        message: partialMessage,
        defaultTitle: _defaultSessionTitle,
      );
    }
    await _streamSubscription?.cancel();
    return super.close();
  }

  // ─── Private: Gemini Stream (Fix #3 — extracted) ───────────────────────────

  /// Core streaming logic shared by [sendMessage] and [retryLastMessage].
  ///
  /// Creates an AI placeholder, subscribes to Gemini, and handles
  /// chunk/done/error callbacks.
  void _startGeminiStream(
    String sessionId,
    String userText,
    List<MessageEntity> chronologicalHistory,
  ) {
    // 1. Insert empty AI placeholder for streaming UI.
    _currentAiMessageId = SmartCoachIdGenerator.messageId();
    _partialAiContent = '';
    final aiPlaceholder = MessageEntity(
      id: _currentAiMessageId!,
      content: '',
      isUser: false,
      timestamp: DateTime.now(),
    );
    _messages.insert(0, aiPlaceholder);
    emit(SmartCoachStreaming(messages: List.unmodifiable(_messages)));

    // 2. Subscribe to Gemini stream.
    _streamSubscription = _sendMessage(
      sessionId: sessionId,
      userMessage: userText,
      history: chronologicalHistory,
    ).listen(
      _onStreamChunk,
      onDone: () => _onStreamDone(sessionId),
      onError: (Object error) => _onStreamError(sessionId, error),
    );
  }

  // ─── Private Stream Callbacks ──────────────────────────────────────────────

  void _onStreamChunk(String chunk) {
    _partialAiContent += chunk;
    if (_messages.isNotEmpty && !_messages[0].isUser) {
      _messages[0] = _messages[0].copyWith(content: _partialAiContent);
    }
    emit(SmartCoachStreaming(messages: List.unmodifiable(_messages)));
  }

  void _onStreamDone(String sessionId) async {
    _isStreaming = false;

    // Persist final AI message.
    if (_messages.isNotEmpty && !_messages[0].isUser) {
      await _saveMessage(
        sessionId: sessionId,
        message: _messages[0],
        defaultTitle: _defaultSessionTitle,
      );
    }

    emit(SmartCoachStreamDone(messages: List.unmodifiable(_messages)));
  }

  void _onStreamError(String sessionId, Object error) async {
    _isStreaming = false;

    if (error is GeminiSafetyException) {
      // Replace placeholder with safety-block message.
      if (_messages.isNotEmpty && !_messages[0].isUser) {
        _messages[0] = _messages[0].copyWith(content: _safetyBlockMessage);
      }

      // FIX #8: Persist the safety block message to Hive so it shows in history.
      await _saveMessage(
        sessionId: sessionId,
        message: _messages[0],
        defaultTitle: _defaultSessionTitle,
      );

      emit(SmartCoachSafetyBlocked(messages: List.unmodifiable(_messages)));
    } else {
      // Keep whatever partial content arrived.
      if (_messages.isNotEmpty &&
          !_messages[0].isUser &&
          _partialAiContent.isNotEmpty) {
        _messages[0] = _messages[0].copyWith(
          content: _partialAiContent,
          isPartial: true,
        );
      }
      emit(SmartCoachError(
        errorMessage: ErrorHandler.handleError(error),
        messages: List.unmodifiable(_messages),
      ));
    }
  }
}
