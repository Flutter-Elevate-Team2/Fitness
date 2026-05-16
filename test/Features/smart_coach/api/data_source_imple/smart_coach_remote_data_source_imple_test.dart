import 'package:flutter_test/flutter_test.dart';
import 'package:fitness_app/Features/smart_coach/api/data_source_imple/smart_coach_remote_data_source_imple.dart';
import 'package:fitness_app/Features/smart_coach/data/data_source_contract/smart_coach_remote_data_source_contract.dart';

/// NOTE: [SmartCoachRemoteDataSourceImpl] creates a [GenerativeModel] internally
/// on every call, making it impossible to inject a mock without refactoring.
///
/// These tests verify **structural correctness** — that the class implements
/// its contract and can be instantiated — rather than network behaviour.
/// Full integration/E2E tests against the Gemini API belong in a separate suite.
void main() {
  group('SmartCoachRemoteDataSourceImpl', () {
    test('should implement SmartCoachRemoteDataSourceContract', () {
      final dataSource = SmartCoachRemoteDataSourceImpl();

      expect(dataSource, isA<SmartCoachRemoteDataSourceContract>());
    });

    test('should be instantiable without arguments', () {
      expect(() => SmartCoachRemoteDataSourceImpl(), returnsNormally);
    });

    test('streamMessage should return a Stream<String>', () {
      final dataSource = SmartCoachRemoteDataSourceImpl();

      // We can verify the return type without awaiting (which would hit network).
      // Calling streamMessage returns an async* generator — the Stream itself
      // is created lazily and won't execute until listened to.
      final result = dataSource.streamMessage(
        apiKey: 'fake-key',
        history: [],
        systemInstruction: 'Test prompt',
      );

      expect(result, isA<Stream<String>>());
    });
  });
}
