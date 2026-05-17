import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:fitness_app/Features/smart_coach/data/repo/smart_coach_repo_impl.dart';
import 'package:fitness_app/Features/smart_coach/data/data_source_contract/smart_coach_local_data_source_contract.dart';
import 'package:fitness_app/Features/smart_coach/data/data_source_contract/smart_coach_remote_data_source_contract.dart';
import 'package:fitness_app/Features/smart_coach/data/models/chat_session_hive_model.dart';
import 'package:fitness_app/Features/smart_coach/data/models/message_hive_model.dart';
import 'package:fitness_app/Features/smart_coach/domain/entities/chat_session_entity.dart';
import 'package:fitness_app/Features/smart_coach/domain/entities/message_entity.dart';
import 'package:fitness_app/core/base_response/base_response.dart';

class MockSmartCoachLocalDataSource extends Mock
    implements SmartCoachLocalDataSourceContract {}

class MockSmartCoachRemoteDataSource extends Mock
    implements SmartCoachRemoteDataSourceContract {}

class FakeChatSessionHiveModel extends Fake implements ChatSessionHiveModel {}

class FakeMessageHiveModel extends Fake implements MessageHiveModel {}

void main() {
  late MockSmartCoachLocalDataSource mockLocalDataSource;
  late MockSmartCoachRemoteDataSource mockRemoteDataSource;
  late SmartCoachRepoImpl repo;

  setUpAll(() {
    dotenv.loadFromString(envString: 'GEMINI_API_KEY=test_key');
    registerFallbackValue(FakeChatSessionHiveModel());
    registerFallbackValue(FakeMessageHiveModel());
  });

  setUp(() {
    mockLocalDataSource = MockSmartCoachLocalDataSource();
    mockRemoteDataSource = MockSmartCoachRemoteDataSource();
    repo = SmartCoachRepoImpl(mockRemoteDataSource, mockLocalDataSource);
  });

  // ─────────────────────────────────────────────
  // createSession
  // ─────────────────────────────────────────────

  group('createSession', () {
    const tDefaultTitle = 'New Chat';

    test(
        'should save new session to local data source and return SuccessResponse',
        () async {
      when(() => mockLocalDataSource.saveSession(any()))
          .thenAnswer((_) async {});

      final result = await repo.createSession(defaultTitle: tDefaultTitle);

      expect(result, isA<SuccessResponse<ChatSessionEntity>>());
      final session = (result as SuccessResponse<ChatSessionEntity>).data;
      expect(session.title, tDefaultTitle);
      expect(session.messages, isEmpty);
      verify(() =>
              mockLocalDataSource.saveSession(any(that: isA<ChatSessionHiveModel>())))
          .called(1);
    });

    test('should return ErrorResponse when local data source fails', () async {
      when(() => mockLocalDataSource.saveSession(any()))
          .thenThrow(Exception('DB Error'));

      final result = await repo.createSession(defaultTitle: tDefaultTitle);

      expect(result, isA<ErrorResponse>());
    });
  });

  // ─────────────────────────────────────────────
  // sendMessage
  // ─────────────────────────────────────────────

  group('sendMessage', () {
    test(
        'should NOT slice history when it has less than 20 messages',
        () {
      final history = List.generate(
        10,
        (i) => MessageEntity(
          id: '$i',
          content: 'msg $i',
          isUser: i.isEven,
          timestamp: DateTime(2023),
        ),
      );

      when(() => mockRemoteDataSource.streamMessage(
            apiKey: any(named: 'apiKey'),
            history: any(named: 'history'),
            systemInstruction: any(named: 'systemInstruction'),
          )).thenAnswer((_) => Stream.value('ok'));

      repo.sendMessage(
        sessionId: 'session-1',
        userMessage: 'msg 9',
        history: history,
      );

      final captured = verify(() => mockRemoteDataSource.streamMessage(
            apiKey: any(named: 'apiKey'),
            history: captureAny(named: 'history'),
            systemInstruction: any(named: 'systemInstruction'),
          )).captured;

      final capturedHistory = captured.first as List<ChatMessageRecord>;
      expect(capturedHistory.length, 10);
    });

    test(
        'should apply sliding window of 20 when history exceeds 20 messages',
        () {
      final history = List.generate(
        25,
        (i) => MessageEntity(
          id: '$i',
          content: 'msg $i',
          isUser: i.isEven,
          timestamp: DateTime(2023),
        ),
      );

      when(() => mockRemoteDataSource.streamMessage(
            apiKey: any(named: 'apiKey'),
            history: any(named: 'history'),
            systemInstruction: any(named: 'systemInstruction'),
          )).thenAnswer((_) => Stream.value('response'));

      repo.sendMessage(
        sessionId: 'session-1',
        userMessage: 'msg 24',
        history: history,
      );

      final captured = verify(() => mockRemoteDataSource.streamMessage(
            apiKey: any(named: 'apiKey'),
            history: captureAny(named: 'history'),
            systemInstruction: any(named: 'systemInstruction'),
          )).captured;

      final capturedHistory = captured.first as List<ChatMessageRecord>;
      expect(capturedHistory.length, 20);
      // First element in window = original index 5
      expect(capturedHistory.first.content, 'msg 5');
      expect(capturedHistory.last.content, 'msg 24');
    });

    test('should correctly map MessageEntity to ChatMessageRecord', () {
      final history = [
        MessageEntity(
          id: 'u1',
          content: 'User msg',
          isUser: true,
          timestamp: DateTime(2023),
        ),
        MessageEntity(
          id: 'a1',
          content: 'AI msg',
          isUser: false,
          timestamp: DateTime(2023),
        ),
      ];

      when(() => mockRemoteDataSource.streamMessage(
            apiKey: any(named: 'apiKey'),
            history: any(named: 'history'),
            systemInstruction: any(named: 'systemInstruction'),
          )).thenAnswer((_) => Stream.value('ok'));

      repo.sendMessage(
        sessionId: 'session-1',
        userMessage: 'User msg',
        history: history,
      );

      final captured = verify(() => mockRemoteDataSource.streamMessage(
            apiKey: any(named: 'apiKey'),
            history: captureAny(named: 'history'),
            systemInstruction: any(named: 'systemInstruction'),
          )).captured;

      final records = captured.first as List<ChatMessageRecord>;
      expect(records[0].content, 'User msg');
      expect(records[0].isUser, true);
      expect(records[1].content, 'AI msg');
      expect(records[1].isUser, false);
    });

    test('should return the stream from remote data source', () {
      when(() => mockRemoteDataSource.streamMessage(
            apiKey: any(named: 'apiKey'),
            history: any(named: 'history'),
            systemInstruction: any(named: 'systemInstruction'),
          )).thenAnswer((_) => Stream.fromIterable(['Hello', ' world!']));

      final stream = repo.sendMessage(
        sessionId: 'session-1',
        userMessage: 'Hi',
        history: [],
      );

      expect(stream, emitsInOrder(['Hello', ' world!', emitsDone]));
    });
  });

  // ─────────────────────────────────────────────
  // saveMessage
  // ─────────────────────────────────────────────

  group('saveMessage', () {
    const tSessionId = 'session-123';
    const tDefaultTitle = 'New Chat';

    test(
        'should save message, update timestamp, and NOT generate title for AI messages',
        () async {
      final tMessage = MessageEntity(
        id: 'msg-1',
        content: 'AI response',
        isUser: false,
        timestamp: DateTime(2023),
      );

      when(() => mockLocalDataSource.saveMessage(any(), any()))
          .thenAnswer((_) async {});
      when(() => mockLocalDataSource.updateSessionTimestamp(any(), any()))
          .thenAnswer((_) async {});

      final result = await repo.saveMessage(
        sessionId: tSessionId,
        message: tMessage,
        defaultTitle: tDefaultTitle,
      );

      expect(result, isA<SuccessResponse<void>>());
      verify(() => mockLocalDataSource.saveMessage(
          tSessionId, any(that: isA<MessageHiveModel>()))).called(1);
      verify(() =>
              mockLocalDataSource.updateSessionTimestamp(tSessionId, any()))
          .called(1);
      // Should NOT try to generate title for AI messages
      verifyNever(() => mockLocalDataSource.getSession(any()));
    });

    test(
        'should generate title from first user message when title is default (≥4 words → first 5)',
        () async {
      final tMessage = MessageEntity(
        id: 'msg-1',
        content: 'What is the best workout for chest and triceps?',
        isUser: true,
        timestamp: DateTime(2023),
      );

      final tSession = ChatSessionHiveModel(
        id: tSessionId,
        title: tDefaultTitle, // Still the default
        messages: [],
        createdAt: DateTime(2023),
        updatedAt: DateTime(2023),
      );

      when(() => mockLocalDataSource.saveMessage(any(), any()))
          .thenAnswer((_) async {});
      when(() => mockLocalDataSource.updateSessionTimestamp(any(), any()))
          .thenAnswer((_) async {});
      when(() => mockLocalDataSource.getSession(tSessionId))
          .thenAnswer((_) async => tSession);
      when(() => mockLocalDataSource.updateSessionTitle(any(), any()))
          .thenAnswer((_) async {});

      await repo.saveMessage(
        sessionId: tSessionId,
        message: tMessage,
        defaultTitle: tDefaultTitle,
      );

      verify(() => mockLocalDataSource.updateSessionTitle(
          tSessionId, 'What is the best workout')).called(1);
    });

    test(
        'should use full text as title when user message has fewer than 4 words',
        () async {
      final tMessage = MessageEntity(
        id: 'msg-1',
        content: 'Help me',
        isUser: true,
        timestamp: DateTime(2023),
      );

      final tSession = ChatSessionHiveModel(
        id: tSessionId,
        title: tDefaultTitle,
        messages: [],
        createdAt: DateTime(2023),
        updatedAt: DateTime(2023),
      );

      when(() => mockLocalDataSource.saveMessage(any(), any()))
          .thenAnswer((_) async {});
      when(() => mockLocalDataSource.updateSessionTimestamp(any(), any()))
          .thenAnswer((_) async {});
      when(() => mockLocalDataSource.getSession(tSessionId))
          .thenAnswer((_) async => tSession);
      when(() => mockLocalDataSource.updateSessionTitle(any(), any()))
          .thenAnswer((_) async {});

      await repo.saveMessage(
        sessionId: tSessionId,
        message: tMessage,
        defaultTitle: tDefaultTitle,
      );

      verify(() =>
              mockLocalDataSource.updateSessionTitle(tSessionId, 'Help me'))
          .called(1);
    });

    test('should NOT update title if session title already differs from default',
        () async {
      final tMessage = MessageEntity(
        id: 'msg-1',
        content: 'Another question',
        isUser: true,
        timestamp: DateTime(2023),
      );

      final tSession = ChatSessionHiveModel(
        id: tSessionId,
        title: 'Already Modified Title',
        messages: [],
        createdAt: DateTime(2023),
        updatedAt: DateTime(2023),
      );

      when(() => mockLocalDataSource.saveMessage(any(), any()))
          .thenAnswer((_) async {});
      when(() => mockLocalDataSource.updateSessionTimestamp(any(), any()))
          .thenAnswer((_) async {});
      when(() => mockLocalDataSource.getSession(tSessionId))
          .thenAnswer((_) async => tSession);

      await repo.saveMessage(
        sessionId: tSessionId,
        message: tMessage,
        defaultTitle: tDefaultTitle,
      );

      verifyNever(() => mockLocalDataSource.updateSessionTitle(any(), any()));
    });

    test('should NOT update title if session is not found', () async {
      final tMessage = MessageEntity(
        id: 'msg-1',
        content: 'Hello World',
        isUser: true,
        timestamp: DateTime(2023),
      );

      when(() => mockLocalDataSource.saveMessage(any(), any()))
          .thenAnswer((_) async {});
      when(() => mockLocalDataSource.updateSessionTimestamp(any(), any()))
          .thenAnswer((_) async {});
      when(() => mockLocalDataSource.getSession(tSessionId))
          .thenAnswer((_) async => null);

      await repo.saveMessage(
        sessionId: tSessionId,
        message: tMessage,
        defaultTitle: tDefaultTitle,
      );

      verifyNever(() => mockLocalDataSource.updateSessionTitle(any(), any()));
    });

    test('should return ErrorResponse when saving fails', () async {
      final tMessage = MessageEntity(
        id: 'msg-1',
        content: 'Hello',
        isUser: true,
        timestamp: DateTime(2023),
      );

      when(() => mockLocalDataSource.saveMessage(any(), any()))
          .thenThrow(Exception('DB Error'));

      final result = await repo.saveMessage(
        sessionId: tSessionId,
        message: tMessage,
        defaultTitle: tDefaultTitle,
      );

      expect(result, isA<ErrorResponse>());
    });
  });

  // ─────────────────────────────────────────────
  // getChatHistory
  // ─────────────────────────────────────────────

  group('getChatHistory', () {
    test('should fetch from local and sort by updatedAt descending', () async {
      final session1 = ChatSessionHiveModel(
        id: '1',
        title: 'Old',
        messages: [],
        createdAt: DateTime(2023),
        updatedAt: DateTime(2023, 1, 1),
      );
      final session2 = ChatSessionHiveModel(
        id: '2',
        title: 'New',
        messages: [],
        createdAt: DateTime(2023),
        updatedAt: DateTime(2023, 1, 5),
      );
      final session3 = ChatSessionHiveModel(
        id: '3',
        title: 'Middle',
        messages: [],
        createdAt: DateTime(2023),
        updatedAt: DateTime(2023, 1, 3),
      );

      when(() => mockLocalDataSource.getAllSessions())
          .thenAnswer((_) async => [session1, session2, session3]);

      final result = await repo.getChatHistory();

      expect(result, isA<SuccessResponse<List<ChatSessionEntity>>>());
      final sessions = (result as SuccessResponse<List<ChatSessionEntity>>).data;
      expect(sessions.length, 3);
      expect(sessions[0].id, '2'); // Most recent
      expect(sessions[1].id, '3'); // Middle
      expect(sessions[2].id, '1'); // Oldest
    });

    test('should return empty list when no sessions exist', () async {
      when(() => mockLocalDataSource.getAllSessions())
          .thenAnswer((_) async => []);

      final result = await repo.getChatHistory();

      expect(result, isA<SuccessResponse<List<ChatSessionEntity>>>());
      final sessions = (result as SuccessResponse<List<ChatSessionEntity>>).data;
      expect(sessions, isEmpty);
    });

    test('should return ErrorResponse when fetching fails', () async {
      when(() => mockLocalDataSource.getAllSessions())
          .thenThrow(Exception('Fetch Error'));

      final result = await repo.getChatHistory();

      expect(result, isA<ErrorResponse>());
    });
  });

  // ─────────────────────────────────────────────
  // deleteSession
  // ─────────────────────────────────────────────

  group('deleteSession', () {
    test('should delete session via local data source and return Success',
        () async {
      when(() => mockLocalDataSource.deleteSession('123'))
          .thenAnswer((_) async {});

      final result = await repo.deleteSession('123');

      expect(result, isA<SuccessResponse<void>>());
      verify(() => mockLocalDataSource.deleteSession('123')).called(1);
    });

    test('should return ErrorResponse when delete fails', () async {
      when(() => mockLocalDataSource.deleteSession('123'))
          .thenThrow(Exception('Delete Error'));

      final result = await repo.deleteSession('123');

      expect(result, isA<ErrorResponse>());
    });
  });

  // ─────────────────────────────────────────────
  // deleteMessage
  // ─────────────────────────────────────────────

  group('deleteMessage', () {
    test('should delete message via local data source and return Success',
        () async {
      when(() => mockLocalDataSource.deleteMessage('session-1', 'msg-1'))
          .thenAnswer((_) async {});

      final result =
          await repo.deleteMessage(sessionId: 'session-1', messageId: 'msg-1');

      expect(result, isA<SuccessResponse<void>>());
      verify(() => mockLocalDataSource.deleteMessage('session-1', 'msg-1'))
          .called(1);
    });

    test('should return ErrorResponse when delete fails', () async {
      when(() => mockLocalDataSource.deleteMessage('session-1', 'msg-1'))
          .thenThrow(Exception('Delete Error'));

      final result =
          await repo.deleteMessage(sessionId: 'session-1', messageId: 'msg-1');

      expect(result, isA<ErrorResponse>());
    });
  });
}
