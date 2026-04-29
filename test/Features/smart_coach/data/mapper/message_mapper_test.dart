import 'package:flutter_test/flutter_test.dart';
import 'package:fitness_app/Features/smart_coach/data/mapper/message_mapper.dart';
import 'package:fitness_app/Features/smart_coach/data/models/message_hive_model.dart';
import 'package:fitness_app/Features/smart_coach/domain/entities/message_entity.dart';

void main() {
  final tTimestamp = DateTime(2023, 6, 15, 10, 30);

  group('MessageHiveModelMapper (toEntity)', () {
    test('should map all fields correctly from Hive model to entity', () {
      final hiveModel = MessageHiveModel(
        id: 'msg-1',
        content: 'Hello Coach',
        isUser: true,
        timestamp: tTimestamp,
        isPartial: false,
      );

      final entity = hiveModel.toEntity();

      expect(entity, isA<MessageEntity>());
      expect(entity.id, 'msg-1');
      expect(entity.content, 'Hello Coach');
      expect(entity.isUser, true);
      expect(entity.timestamp, tTimestamp);
      expect(entity.isPartial, false);
    });

    test('should map isPartial=true correctly', () {
      final hiveModel = MessageHiveModel(
        id: 'msg-2',
        content: 'Partial AI response',
        isUser: false,
        timestamp: tTimestamp,
        isPartial: true,
      );

      final entity = hiveModel.toEntity();

      expect(entity.isPartial, true);
      expect(entity.isUser, false);
    });
  });

  group('MessageEntityMapper (toHiveModel)', () {
    test('should map all fields correctly from entity to Hive model', () {
      final entity = MessageEntity(
        id: 'msg-1',
        content: 'Hello Coach',
        isUser: true,
        timestamp: tTimestamp,
        isPartial: false,
      );

      final hiveModel = entity.toHiveModel();

      expect(hiveModel, isA<MessageHiveModel>());
      expect(hiveModel.id, 'msg-1');
      expect(hiveModel.content, 'Hello Coach');
      expect(hiveModel.isUser, true);
      expect(hiveModel.timestamp, tTimestamp);
      expect(hiveModel.isPartial, false);
    });

    test('should preserve isPartial=true in round-trip', () {
      final entity = MessageEntity(
        id: 'msg-3',
        content: 'Interrupted',
        isUser: false,
        timestamp: tTimestamp,
        isPartial: true,
      );

      final hiveModel = entity.toHiveModel();

      expect(hiveModel.isPartial, true);
    });

    test('round-trip: entity → hive → entity should produce equal entity', () {
      final original = MessageEntity(
        id: 'msg-rt',
        content: 'Round trip',
        isUser: true,
        timestamp: tTimestamp,
        isPartial: false,
      );

      final roundTripped = original.toHiveModel().toEntity();

      expect(roundTripped, original);
    });
  });
}
