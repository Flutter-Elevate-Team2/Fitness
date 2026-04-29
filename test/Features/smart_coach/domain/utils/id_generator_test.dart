import 'package:flutter_test/flutter_test.dart';
import 'package:fitness_app/Features/smart_coach/domain/utils/id_generator.dart';

void main() {
  group('SmartCoachIdGenerator', () {
    group('generate', () {
      test('should return a non-empty string', () {
        final id = SmartCoachIdGenerator.generate();
        expect(id, isNotEmpty);
      });

      test('should return unique IDs on consecutive calls', () {
        final id1 = SmartCoachIdGenerator.generate();
        final id2 = SmartCoachIdGenerator.generate();
        expect(id1, isNot(id2));
      });

      test('should contain underscore separating timestamp and suffix', () {
        final id = SmartCoachIdGenerator.generate();
        expect(id, contains('_'));
      });

      test('should prepend prefix when provided', () {
        final id = SmartCoachIdGenerator.generate(prefix: 'test');
        expect(id, startsWith('test_'));
      });

      test('should NOT have prefix when prefix is empty', () {
        final id = SmartCoachIdGenerator.generate();
        // Without prefix, it should be just timestamp_suffix
        final parts = id.split('_');
        expect(parts.length, 2);
      });

      test('should generate 100 unique IDs without collision', () {
        final ids = List.generate(100, (_) => SmartCoachIdGenerator.generate());
        final uniqueIds = ids.toSet();
        expect(uniqueIds.length, 100);
      });
    });

    group('sessionId', () {
      test('should start with session_ prefix', () {
        final id = SmartCoachIdGenerator.sessionId();
        expect(id, startsWith('session_'));
      });

      test('should generate unique session IDs', () {
        final id1 = SmartCoachIdGenerator.sessionId();
        final id2 = SmartCoachIdGenerator.sessionId();
        expect(id1, isNot(id2));
      });
    });

    group('messageId', () {
      test('should start with msg_ prefix', () {
        final id = SmartCoachIdGenerator.messageId();
        expect(id, startsWith('msg_'));
      });

      test('should generate unique message IDs', () {
        final id1 = SmartCoachIdGenerator.messageId();
        final id2 = SmartCoachIdGenerator.messageId();
        expect(id1, isNot(id2));
      });
    });
  });
}
