import 'package:fitness_app/core/base_response/base_response.dart';
import 'package:fitness_app/core/helpers/api_execution_mixin.dart';
import 'package:flutter_test/flutter_test.dart';

class TestApiExecutor with ApiExecutionMixin {}

void main() {
  late TestApiExecutor executor;

  setUp(() {
    executor = TestApiExecutor();
  });

  group('ApiExecutionMixin', () {
    test('execute returns SuccessResponse when action succeeds', () async {
      final result = await executor.execute<String, int>(
        action: () async => '42',
        mapper: (data) => int.parse(data),
      );

      expect(result, isA<SuccessResponse<int>>());
      expect((result as SuccessResponse<int>).data, 42);
    });

    test('execute returns ErrorResponse when action throws', () async {
      final result = await executor.execute<String, int>(
        action: () async => throw Exception('Network error'),
        mapper: (data) => int.parse(data),
      );

      expect(result, isA<ErrorResponse<int>>());
      // The ErrorHandler.handleError(e) will return a string.
      // We don't necessarily need to check the exact string here if ErrorHandler is tested elsewhere,
      // but we verify it's an ErrorResponse.
      expect((result as ErrorResponse<int>).errorMessage, isNotEmpty);
    });
  });
}
