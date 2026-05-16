import 'package:fitness_app/core/base_response/base_response.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('BaseResponse', () {
    test('SuccessResponse should hold data', () {
      const data = 'test data';
      final response = SuccessResponse<String>(data: data);

      expect(response, isA<BaseResponse<String>>());
      expect(response.data, data);
    });

    test('ErrorResponse should hold error message', () {
      const errorMessage = 'test error';
      final response = ErrorResponse<String>(errorMessage: errorMessage);

      expect(response, isA<BaseResponse<String>>());
      expect(response.errorMessage, errorMessage);
    });
  });
}
