import 'dart:io';
import 'package:fitness_app/core/data_base/hive_database_service.dart';
import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();
  late Directory tempDir;

  setUpAll(() async {
    tempDir = await Directory.systemTemp.createTemp('hive_test');

    TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger
        .setMockMethodCallHandler(
      const MethodChannel('plugins.flutter.io/path_provider'),
      (MethodCall methodCall) async {
        if (methodCall.method == 'getApplicationDocumentsDirectory') {
          return tempDir.path;
        }
        return null;
      },
    );
  });

  tearDownAll(() {
    tempDir.deleteSync(recursive: true);
  });

  tearDown(() async {
    try {
      await HiveDatabaseService.instance.close();
    } catch (_) {}
  });

  group('HiveDatabaseService Tests', () {

    test('1. instance throws AssertionError if accessed before init()', () {
      expect(() => HiveDatabaseService.instance, throwsA(isA<AssertionError>()));
    });

    test('2. init() initializes Hive and instance becomes accessible', () async {
      await HiveDatabaseService.init();

      expect(HiveDatabaseService.instance, isNotNull);
    });

    test('3. init() calls registerAdapters callback', () async {
      bool adapterRegistered = false;

      await HiveDatabaseService.init(
        registerAdapters: () {
          adapterRegistered = true;
        },
      );

      expect(adapterRegistered, isTrue);
    });

    test('4. openBox() opens and returns a valid Hive box', () async {
      await HiveDatabaseService.init();

      final box = await HiveDatabaseService.instance.openBox<String>('test_box');

      expect(box.isOpen, isTrue);
      expect(box.name, 'test_box');
    });

    test('5. close() closes Hive and resets instance to null', () async {
      await HiveDatabaseService.init();
      final box = await HiveDatabaseService.instance.openBox<String>('test_box');
      expect(box.isOpen, isTrue);

      await HiveDatabaseService.instance.close();

      expect(box.isOpen, isFalse);
      expect(() => HiveDatabaseService.instance, throwsA(isA<AssertionError>()));
    });
  });
}
