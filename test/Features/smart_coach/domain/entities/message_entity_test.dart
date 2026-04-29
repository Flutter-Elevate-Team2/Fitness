import 'package:flutter_test/flutter_test.dart';
import 'package:fitness_app/Features/smart_coach/domain/entities/message_entity.dart';

void main() {
  final tTimestamp = DateTime(2023, 6, 15, 10, 30);

  final tMessage = MessageEntity(
    id: 'msg-1',
    content: 'Hello Coach',
    isUser: true,
    timestamp: tTimestamp,
  );

  group('MessageEntity', () {
    test('should create instance with correct properties', () {
      expect(tMessage.id, 'msg-1');
      expect(tMessage.content, 'Hello Coach');
      expect(tMessage.isUser, true);
      expect(tMessage.timestamp, tTimestamp);
      expect(tMessage.isPartial, false);
    });

    test('should default isPartial to false', () {
      final message = MessageEntity(
        id: 'msg-2',
        content: 'Test',
        isUser: false,
        timestamp: tTimestamp,
      );
      expect(message.isPartial, false);
    });

    test('should allow setting isPartial to true', () {
      final message = MessageEntity(
        id: 'msg-3',
        content: 'Partial response',
        isUser: false,
        timestamp: tTimestamp,
        isPartial: true,
      );
      expect(message.isPartial, true);
    });

    group('copyWith', () {
      test('should return identical copy when no params provided', () {
        final copy = tMessage.copyWith();
        expect(copy, tMessage);
        expect(copy.id, tMessage.id);
        expect(copy.content, tMessage.content);
        expect(copy.isUser, tMessage.isUser);
        expect(copy.timestamp, tMessage.timestamp);
        expect(copy.isPartial, tMessage.isPartial);
      });

      test('should replace id when provided', () {
        final copy = tMessage.copyWith(id: 'msg-new');
        expect(copy.id, 'msg-new');
        expect(copy.content, tMessage.content);
      });

      test('should replace content when provided', () {
        final copy = tMessage.copyWith(content: 'Updated content');
        expect(copy.content, 'Updated content');
        expect(copy.id, tMessage.id);
      });

      test('should replace isUser when provided', () {
        final copy = tMessage.copyWith(isUser: false);
        expect(copy.isUser, false);
        expect(copy.id, tMessage.id);
      });

      test('should replace timestamp when provided', () {
        final newTime = DateTime(2024, 1, 1);
        final copy = tMessage.copyWith(timestamp: newTime);
        expect(copy.timestamp, newTime);
        expect(copy.id, tMessage.id);
      });

      test('should replace isPartial when provided', () {
        final copy = tMessage.copyWith(isPartial: true);
        expect(copy.isPartial, true);
        expect(copy.id, tMessage.id);
      });

      test('should replace multiple fields at once', () {
        final copy = tMessage.copyWith(
          content: 'New content',
          isPartial: true,
        );
        expect(copy.content, 'New content');
        expect(copy.isPartial, true);
        expect(copy.id, tMessage.id);
        expect(copy.isUser, tMessage.isUser);
      });
    });

    group('Equatable', () {
      test('should be equal when all props are the same', () {
        final message1 = MessageEntity(
          id: 'msg-1',
          content: 'Hello Coach',
          isUser: true,
          timestamp: tTimestamp,
        );
        expect(tMessage, message1);
      });

      test('should NOT be equal when id differs', () {
        final message2 = MessageEntity(
          id: 'msg-different',
          content: 'Hello Coach',
          isUser: true,
          timestamp: tTimestamp,
        );
        expect(tMessage, isNot(message2));
      });

      test('should NOT be equal when content differs', () {
        final message2 = MessageEntity(
          id: 'msg-1',
          content: 'Different',
          isUser: true,
          timestamp: tTimestamp,
        );
        expect(tMessage, isNot(message2));
      });

      test('should NOT be equal when isPartial differs', () {
        final message2 = MessageEntity(
          id: 'msg-1',
          content: 'Hello Coach',
          isUser: true,
          timestamp: tTimestamp,
          isPartial: true,
        );
        expect(tMessage, isNot(message2));
      });

      test('props should contain all fields', () {
        expect(
          tMessage.props,
          [tMessage.id, tMessage.content, tMessage.isUser, tMessage.timestamp, tMessage.isPartial],
        );
      });
    });
  });
}
