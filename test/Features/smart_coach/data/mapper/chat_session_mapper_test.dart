import 'package:flutter_test/flutter_test.dart';
import 'package:fitness_app/Features/smart_coach/data/mapper/chat_session_mapper.dart';
import 'package:fitness_app/Features/smart_coach/data/models/chat_session_hive_model.dart';
import 'package:fitness_app/Features/smart_coach/data/models/message_hive_model.dart';
import 'package:fitness_app/Features/smart_coach/domain/entities/chat_session_entity.dart';

void main() {
  final tCreatedAt = DateTime(2023, 6, 15, 10, 0);
  final tUpdatedAt = DateTime(2023, 6, 15, 12, 0);
  final tMsgTimestamp = DateTime(2023, 6, 15, 11, 0);

  group('ChatSessionHiveModelMapper (toEntity)', () {
    test('should map all fields correctly including nested messages', () {
      final hiveModel = ChatSessionHiveModel(
        id: 'session-1',
        title: 'My Session',
        messages: [
          MessageHiveModel(
            id: 'msg-1',
            content: 'Hello',
            isUser: true,
            timestamp: tMsgTimestamp,
          ),
        ],
        createdAt: tCreatedAt,
        updatedAt: tUpdatedAt,
      );

      final entity = hiveModel.toEntity();

      expect(entity, isA<ChatSessionEntity>());
      expect(entity.id, 'session-1');
      expect(entity.title, 'My Session');
      expect(entity.messages.length, 1);
      expect(entity.messages.first.id, 'msg-1');
      expect(entity.messages.first.content, 'Hello');
      expect(entity.createdAt, tCreatedAt);
      expect(entity.updatedAt, tUpdatedAt);
    });

    test('should map session with empty messages list', () {
      final hiveModel = ChatSessionHiveModel(
        id: 'session-2',
        title: 'Empty',
        messages: [],
        createdAt: tCreatedAt,
        updatedAt: tUpdatedAt,
      );

      final entity = hiveModel.toEntity();

      expect(entity.messages, isEmpty);
    });

    test('should map session with multiple messages preserving order', () {
      final hiveModel = ChatSessionHiveModel(
        id: 'session-3',
        title: 'Multi',
        messages: [
          MessageHiveModel(id: 'a', content: 'First', isUser: true, timestamp: tMsgTimestamp),
          MessageHiveModel(id: 'b', content: 'Second', isUser: false, timestamp: tMsgTimestamp),
          MessageHiveModel(id: 'c', content: 'Third', isUser: true, timestamp: tMsgTimestamp),
        ],
        createdAt: tCreatedAt,
        updatedAt: tUpdatedAt,
      );

      final entity = hiveModel.toEntity();

      expect(entity.messages.length, 3);
      expect(entity.messages[0].id, 'a');
      expect(entity.messages[1].id, 'b');
      expect(entity.messages[2].id, 'c');
    });
  });

  group('ChatSessionEntityMapper (toHiveModel)', () {
    test('should map entity back to Hive model correctly', () {
      final entity = ChatSessionEntity(
        id: 'session-1',
        title: 'My Session',
        messages: [],
        createdAt: tCreatedAt,
        updatedAt: tUpdatedAt,
      );

      final hiveModel = entity.toHiveModel();

      expect(hiveModel, isA<ChatSessionHiveModel>());
      expect(hiveModel.id, 'session-1');
      expect(hiveModel.title, 'My Session');
      expect(hiveModel.messages, isEmpty);
      expect(hiveModel.createdAt, tCreatedAt);
      expect(hiveModel.updatedAt, tUpdatedAt);
    });
  });

  group('ChatSessionHiveModelListMapper (toEntityList)', () {
    test('should map list of Hive models to list of entities', () {
      final hiveModels = [
        ChatSessionHiveModel(
          id: 's-1',
          title: 'First',
          messages: [],
          createdAt: tCreatedAt,
          updatedAt: tUpdatedAt,
        ),
        ChatSessionHiveModel(
          id: 's-2',
          title: 'Second',
          messages: [],
          createdAt: tCreatedAt,
          updatedAt: tUpdatedAt,
        ),
      ];

      final entities = hiveModels.toEntityList();

      expect(entities.length, 2);
      expect(entities[0].id, 's-1');
      expect(entities[1].id, 's-2');
    });

    test('should return empty list for null list', () {
      List<ChatSessionHiveModel>? nullList;

      final entities = nullList.toEntityList();

      expect(entities, isEmpty);
    });

    test('should return empty list for empty list', () {
      final emptyList = <ChatSessionHiveModel>[];

      final entities = emptyList.toEntityList();

      expect(entities, isEmpty);
    });
  });
}
