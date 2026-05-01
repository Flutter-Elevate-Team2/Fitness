import 'package:flutter_test/flutter_test.dart';
import 'package:fitness_app/Features/smart_coach/domain/entities/chat_session_entity.dart';
import 'package:fitness_app/Features/smart_coach/domain/entities/message_entity.dart';

void main() {
  final tCreatedAt = DateTime(2023, 6, 15, 10, 0);
  final tUpdatedAt = DateTime(2023, 6, 15, 12, 0);

  final tMessages = [
    MessageEntity(
      id: 'msg-1',
      content: 'Hello',
      isUser: true,
      timestamp: tCreatedAt,
    ),
  ];

  final tSession = ChatSessionEntity(
    id: 'session-1',
    title: 'My Session',
    messages: tMessages,
    createdAt: tCreatedAt,
    updatedAt: tUpdatedAt,
  );

  group('ChatSessionEntity', () {
    test('should create instance with correct properties', () {
      expect(tSession.id, 'session-1');
      expect(tSession.title, 'My Session');
      expect(tSession.messages, tMessages);
      expect(tSession.createdAt, tCreatedAt);
      expect(tSession.updatedAt, tUpdatedAt);
    });

    test('should support empty messages list', () {
      final emptySession = ChatSessionEntity(
        id: 'session-2',
        title: 'Empty',
        messages: const [],
        createdAt: tCreatedAt,
        updatedAt: tUpdatedAt,
      );
      expect(emptySession.messages, isEmpty);
    });

    group('Equatable', () {
      test('should be equal when all props are the same', () {
        final session2 = ChatSessionEntity(
          id: 'session-1',
          title: 'My Session',
          messages: tMessages,
          createdAt: tCreatedAt,
          updatedAt: tUpdatedAt,
        );
        expect(tSession, session2);
      });

      test('should NOT be equal when id differs', () {
        final session2 = ChatSessionEntity(
          id: 'session-different',
          title: 'My Session',
          messages: tMessages,
          createdAt: tCreatedAt,
          updatedAt: tUpdatedAt,
        );
        expect(tSession, isNot(session2));
      });

      test('should NOT be equal when title differs', () {
        final session2 = ChatSessionEntity(
          id: 'session-1',
          title: 'Different Title',
          messages: tMessages,
          createdAt: tCreatedAt,
          updatedAt: tUpdatedAt,
        );
        expect(tSession, isNot(session2));
      });

      test('should NOT be equal when updatedAt differs', () {
        final session2 = ChatSessionEntity(
          id: 'session-1',
          title: 'My Session',
          messages: tMessages,
          createdAt: tCreatedAt,
          updatedAt: DateTime(2024, 1, 1),
        );
        expect(tSession, isNot(session2));
      });

      test('should NOT be equal when messages differ', () {
        final session2 = ChatSessionEntity(
          id: 'session-1',
          title: 'My Session',
          messages: const [],
          createdAt: tCreatedAt,
          updatedAt: tUpdatedAt,
        );
        expect(tSession, isNot(session2));
      });

      test('props should contain all fields', () {
        expect(
          tSession.props,
          [tSession.id, tSession.title, tSession.messages, tSession.createdAt, tSession.updatedAt],
        );
      });
    });
  });
}
