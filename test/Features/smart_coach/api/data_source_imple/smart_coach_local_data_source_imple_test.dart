import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:hive_ce/hive.dart';
import 'package:fitness_app/Features/smart_coach/api/data_source_imple/smart_coach_local_data_source_imple.dart';
import 'package:fitness_app/Features/smart_coach/data/models/chat_session_hive_model.dart';
import 'package:fitness_app/Features/smart_coach/data/models/message_hive_model.dart';
import 'package:fitness_app/core/data_base/hive_database_service.dart';

class MockHiveDatabaseService extends Mock implements HiveDatabaseService {}

class MockBox extends Mock implements Box<ChatSessionHiveModel> {}

class FakeChatSessionHiveModel extends Fake implements ChatSessionHiveModel {}

void main() {
  late MockHiveDatabaseService mockHiveService;
  late MockBox mockBox;
  late SmartCoachLocalDataSourceImpl dataSource;

  setUpAll(() {
    registerFallbackValue(FakeChatSessionHiveModel());
  });

  setUp(() {
    mockHiveService = MockHiveDatabaseService();
    mockBox = MockBox();
    dataSource = SmartCoachLocalDataSourceImpl(mockHiveService);

    // Stub the generic openBox<ChatSessionHiveModel> call specifically.
    when(() => mockHiveService.openBox<ChatSessionHiveModel>(any()))
        .thenAnswer((_) async => mockBox);
  });

  // ─────────────────────────────────────────────
  // saveSession
  // ─────────────────────────────────────────────

  group('saveSession', () {
    test('should put the session into the box with its id as key', () async {
      final session = ChatSessionHiveModel(
        id: 'session-1',
        title: 'Test',
        messages: [],
        createdAt: DateTime(2023),
        updatedAt: DateTime(2023),
      );

      when(() => mockBox.put(any(), any<ChatSessionHiveModel>()))
          .thenAnswer((_) async {});

      await dataSource.saveSession(session);

      verify(() => mockBox.put('session-1', session)).called(1);
    });
  });

  // ─────────────────────────────────────────────
  // saveMessage
  // ─────────────────────────────────────────────

  group('saveMessage', () {
    test('should append message to existing session and re-save', () async {
      final session = ChatSessionHiveModel(
        id: 'session-1',
        title: 'Test',
        messages: [],
        createdAt: DateTime(2023),
        updatedAt: DateTime(2023),
      );
      final message = MessageHiveModel(
        id: 'msg-1',
        content: 'Hello',
        isUser: true,
        timestamp: DateTime(2023),
      );

      when(() => mockBox.get('session-1')).thenReturn(session);
      when(() => mockBox.put(any(), any<ChatSessionHiveModel>()))
          .thenAnswer((_) async {});

      await dataSource.saveMessage('session-1', message);

      expect(session.messages.length, 1);
      expect(session.messages.first.id, 'msg-1');
      verify(() => mockBox.put('session-1', session)).called(1);
    });

    test('should do nothing if session is not found', () async {
      final message = MessageHiveModel(
        id: 'msg-1',
        content: 'Hello',
        isUser: true,
        timestamp: DateTime(2023),
      );

      when(() => mockBox.get('non-existent')).thenReturn(null);

      await dataSource.saveMessage('non-existent', message);

      verifyNever(() => mockBox.put(any(), any<ChatSessionHiveModel>()));
    });
  });

  // ─────────────────────────────────────────────
  // updateSessionTimestamp
  // ─────────────────────────────────────────────

  group('updateSessionTimestamp', () {
    test('should update updatedAt and re-save', () async {
      final session = ChatSessionHiveModel(
        id: 'session-1',
        title: 'Test',
        messages: [],
        createdAt: DateTime(2023),
        updatedAt: DateTime(2023),
      );
      final newTimestamp = DateTime(2024, 1, 1);

      when(() => mockBox.get('session-1')).thenReturn(session);
      when(() => mockBox.put(any(), any<ChatSessionHiveModel>()))
          .thenAnswer((_) async {});

      await dataSource.updateSessionTimestamp('session-1', newTimestamp);

      expect(session.updatedAt, newTimestamp);
      verify(() => mockBox.put('session-1', session)).called(1);
    });

    test('should do nothing if session is not found', () async {
      when(() => mockBox.get('non-existent')).thenReturn(null);

      await dataSource.updateSessionTimestamp(
          'non-existent', DateTime(2024));

      verifyNever(() => mockBox.put(any(), any<ChatSessionHiveModel>()));
    });
  });

  // ─────────────────────────────────────────────
  // updateSessionTitle
  // ─────────────────────────────────────────────

  group('updateSessionTitle', () {
    test('should update title and re-save', () async {
      final session = ChatSessionHiveModel(
        id: 'session-1',
        title: 'Old Title',
        messages: [],
        createdAt: DateTime(2023),
        updatedAt: DateTime(2023),
      );

      when(() => mockBox.get('session-1')).thenReturn(session);
      when(() => mockBox.put(any(), any<ChatSessionHiveModel>()))
          .thenAnswer((_) async {});

      await dataSource.updateSessionTitle('session-1', 'New Title');

      expect(session.title, 'New Title');
      verify(() => mockBox.put('session-1', session)).called(1);
    });

    test('should do nothing if session is not found', () async {
      when(() => mockBox.get('non-existent')).thenReturn(null);

      await dataSource.updateSessionTitle('non-existent', 'Title');

      verifyNever(() => mockBox.put(any(), any<ChatSessionHiveModel>()));
    });
  });

  // ─────────────────────────────────────────────
  // getAllSessions
  // ─────────────────────────────────────────────

  group('getAllSessions', () {
    test('should return all sessions from the box', () async {
      final sessions = [
        ChatSessionHiveModel(
          id: 's-1',
          title: 'First',
          messages: [],
          createdAt: DateTime(2023),
          updatedAt: DateTime(2023),
        ),
        ChatSessionHiveModel(
          id: 's-2',
          title: 'Second',
          messages: [],
          createdAt: DateTime(2023),
          updatedAt: DateTime(2023),
        ),
      ];

      when(() => mockBox.values).thenReturn(sessions);

      final result = await dataSource.getAllSessions();

      expect(result.length, 2);
      expect(result[0].id, 's-1');
      expect(result[1].id, 's-2');
    });

    test('should return empty list when box is empty', () async {
      when(() => mockBox.values).thenReturn([]);

      final result = await dataSource.getAllSessions();

      expect(result, isEmpty);
    });
  });

  // ─────────────────────────────────────────────
  // getSession
  // ─────────────────────────────────────────────

  group('getSession', () {
    test('should return session when found', () async {
      final session = ChatSessionHiveModel(
        id: 'session-1',
        title: 'Test',
        messages: [],
        createdAt: DateTime(2023),
        updatedAt: DateTime(2023),
      );

      when(() => mockBox.get('session-1')).thenReturn(session);

      final result = await dataSource.getSession('session-1');

      expect(result, session);
    });

    test('should return null when not found', () async {
      when(() => mockBox.get('non-existent')).thenReturn(null);

      final result = await dataSource.getSession('non-existent');

      expect(result, isNull);
    });
  });

  // ─────────────────────────────────────────────
  // deleteSession
  // ─────────────────────────────────────────────

  group('deleteSession', () {
    test('should delete session from box by id', () async {
      when(() => mockBox.delete(any())).thenAnswer((_) async {});

      await dataSource.deleteSession('session-1');

      verify(() => mockBox.delete('session-1')).called(1);
    });
  });

  // ─────────────────────────────────────────────
  // deleteMessage
  // ─────────────────────────────────────────────

  group('deleteMessage', () {
    test('should remove matching message and re-save the session', () async {
      final session = ChatSessionHiveModel(
        id: 'session-1',
        title: 'Test',
        messages: [
          MessageHiveModel(
            id: 'msg-1',
            content: 'Keep me',
            isUser: true,
            timestamp: DateTime(2023),
          ),
          MessageHiveModel(
            id: 'msg-2',
            content: 'Delete me',
            isUser: false,
            timestamp: DateTime(2023),
          ),
        ],
        createdAt: DateTime(2023),
        updatedAt: DateTime(2023),
      );

      when(() => mockBox.get('session-1')).thenReturn(session);
      when(() => mockBox.put(any(), any<ChatSessionHiveModel>()))
          .thenAnswer((_) async {});

      await dataSource.deleteMessage('session-1', 'msg-2');

      expect(session.messages.length, 1);
      expect(session.messages.first.id, 'msg-1');
      verify(() => mockBox.put('session-1', session)).called(1);
    });

    test('should do nothing if session is not found', () async {
      when(() => mockBox.get('non-existent')).thenReturn(null);

      await dataSource.deleteMessage('non-existent', 'msg-1');

      verifyNever(() => mockBox.put(any(), any<ChatSessionHiveModel>()));
    });

    test('should re-save session even if messageId is not found in list',
        () async {
      final session = ChatSessionHiveModel(
        id: 'session-1',
        title: 'Test',
        messages: [
          MessageHiveModel(
            id: 'msg-1',
            content: 'Keep me',
            isUser: true,
            timestamp: DateTime(2023),
          ),
        ],
        createdAt: DateTime(2023),
        updatedAt: DateTime(2023),
      );

      when(() => mockBox.get('session-1')).thenReturn(session);
      when(() => mockBox.put(any(), any<ChatSessionHiveModel>()))
          .thenAnswer((_) async {});

      await dataSource.deleteMessage('session-1', 'msg-non-existent');

      expect(session.messages.length, 1);
      verify(() => mockBox.put('session-1', session)).called(1);
    });
  });
}
