import 'package:fitness_app/Features/smart_coach/data/data_source_contract/smart_coach_local_data_source_contract.dart';
import 'package:fitness_app/Features/smart_coach/data/data_source_contract/smart_coach_remote_data_source_contract.dart';
import 'package:fitness_app/Features/smart_coach/data/mapper/chat_session_mapper.dart';
import 'package:fitness_app/Features/smart_coach/data/mapper/message_mapper.dart';
import 'package:fitness_app/Features/smart_coach/data/models/chat_session_hive_model.dart';
import 'package:fitness_app/Features/smart_coach/data/smart_coach_system_instructions.dart';
import 'package:fitness_app/Features/smart_coach/domain/entities/chat_session_entity.dart';
import 'package:fitness_app/Features/smart_coach/domain/entities/message_entity.dart';
import 'package:fitness_app/Features/smart_coach/domain/repo/smart_coach_repo_contract.dart';
import 'package:fitness_app/Features/smart_coach/domain/utils/id_generator.dart';
import 'package:fitness_app/core/base_response/base_response.dart';
import 'package:fitness_app/core/constants/app_config.dart';
import 'package:fitness_app/core/errors/handel_errors.dart';
import 'package:injectable/injectable.dart';

@Injectable(as: SmartCoachRepoContract)
@Injectable(as: SmartCoachRepoContract)
class SmartCoachRepoImpl implements SmartCoachRepoContract {
  final SmartCoachRemoteDataSourceContract _remoteDataSource;
  final SmartCoachLocalDataSourceContract _localDataSource;

  /// Maximum number of messages sent to Gemini per request.
  /// Prevents exceeding the context/token limit on long sessions.
  static const int _maxHistoryWindow = 20;

  /// Maximum number of words to use from the first user message as title.
  static const int _maxTitleWords = 5;

  SmartCoachRepoImpl(this._remoteDataSource, this._localDataSource);



  @override
  Future<BaseResponse<ChatSessionEntity>> createSession({
    required String defaultTitle,
  }) async {
    try {
      final now = DateTime.now();
      final session = ChatSessionHiveModel(
        id: SmartCoachIdGenerator.sessionId(),
        title: defaultTitle,
        messages: [],
        createdAt: now,
        updatedAt: now,
      );

      await _localDataSource.saveSession(session);

      return SuccessResponse(data: session.toEntity());
    } catch (e) {
      return ErrorResponse(errorMessage: ErrorHandler.handleError(e));
    }
  }



  @override
  Stream<String> sendMessage({
    required String sessionId,
    required String userMessage,
    required List<MessageEntity> history,
  }) {
    // 1. Apply sliding window: take last N messages.
    final windowedHistory = history.length > _maxHistoryWindow
        ? history.sublist(history.length - _maxHistoryWindow)
        : history;

    // 2. Map domain entities → data-layer records (refinement #1).
    final records = windowedHistory
        .map((e) => (content: e.content, isUser: e.isUser))
        .toList();

    // 3. Delegate to remote data source with system instructions.
    return _remoteDataSource.streamMessage(
      apiKey: AppConfig.geminiApiKey,
      history: records,
      systemInstruction: SmartCoachSystemInstructions.systemPrompt,
    );
  }



  @override
  Future<BaseResponse<void>> saveMessage({
    required String sessionId,
    required MessageEntity message,
    required String defaultTitle,
  }) async {
    try {
      // 1. Persist the message.
      await _localDataSource.saveMessage(sessionId, message.toHiveModel());

      // 2. Update session timestamp.
      await _localDataSource.updateSessionTimestamp(
        sessionId,
        DateTime.now(),
      );

      // 3. Generate title on first user message.
      // FIX #1: Check title instead of counting messages to avoid race condition.
      if (message.isUser) {
        await _maybeGenerateTitle(sessionId, message.content, defaultTitle);
      }

      return const SuccessResponse(data: null);
    } catch (e) {
      return ErrorResponse(errorMessage: ErrorHandler.handleError(e));
    }
  }



  @override
  Future<BaseResponse<List<ChatSessionEntity>>> getChatHistory() async {
    try {
      final sessions = await _localDataSource.getAllSessions();

      // Sort by updatedAt descending (most recent first).
      sessions.sort((a, b) => b.updatedAt.compareTo(a.updatedAt));

      return SuccessResponse(data: sessions.toEntityList());
    } catch (e) {
      return ErrorResponse(errorMessage: ErrorHandler.handleError(e));
    }
  }



  @override
  Future<BaseResponse<void>> deleteSession(String sessionId) async {
    try {
      await _localDataSource.deleteSession(sessionId);
      return const SuccessResponse(data: null);
    } catch (e) {
      return ErrorResponse(errorMessage: ErrorHandler.handleError(e));
    }
  }



  @override
  Future<BaseResponse<void>> deleteMessage({
    required String sessionId,
    required String messageId,
  }) async {
    try {
      await _localDataSource.deleteMessage(sessionId, messageId);
      return const SuccessResponse(data: null);
    } catch (e) {
      return ErrorResponse(errorMessage: ErrorHandler.handleError(e));
    }
  }



  /// Generates the session title from the first user message.
  ///
  /// FIX #1: Uses title comparison instead of message counting
  /// to avoid the race condition where save + title check happen
  /// concurrently and the count is stale.
  ///
  /// Rules:
  ///  - If the message has ≥ 4 words → take first [_maxTitleWords] words.
  ///  - If the message is empty or symbols-only → keep default title.
  ///  - Otherwise → use the full message as title.
  Future<void> _maybeGenerateTitle(
    String sessionId,
    String messageContent,
    String defaultTitle,
  ) async {
    final session = await _localDataSource.getSession(sessionId);
    if (session == null) return;

    // Only generate if title is still the default placeholder.
    if (session.title != defaultTitle) return;

    final title = _generateTitle(messageContent, defaultTitle);
    await _localDataSource.updateSessionTitle(sessionId, title);
  }

  /// Pure function that derives a session title from user message content.
  static String _generateTitle(String messageContent, String defaultTitle) {
    final trimmed = messageContent.trim();

    // Empty or symbols-only → fallback.
    if (trimmed.isEmpty || _isSymbolsOnly(trimmed)) {
      return defaultTitle;
    }

    final words = trimmed.split(RegExp(r'\s+'));

    if (words.length >= 4) {
      return words.take(_maxTitleWords).join(' ');
    }

    // Short message (< 4 words) → use the full text.
    return trimmed;
  }

  /// Returns `true` if [text] contains only non-alphanumeric characters.
  static bool _isSymbolsOnly(String text) {
    // Matches Unicode letters and digits (supports Arabic, etc.)
    return !RegExp(r'[\p{L}\p{N}]', unicode: true).hasMatch(text);
  }
}
