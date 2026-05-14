import 'package:flutter_test/flutter_test.dart';
import 'package:fitness_app/Features/auth/data/models/forget_password_models/response/forget_password_response/forget_password_response.dart';

void main() {
  group('ForgetPasswordResponse', () {
    test('toJson returns correct map', () {
      final response = ForgetPasswordResponse(
        message: 'Email sent',
        info: 'Check your inbox',
      );

      final json = response.toJson();

      expect(json, {
        'message': 'Email sent',
        'info': 'Check your inbox',
      });
    });

    test('fromJson creates correct object', () {
      final json = {
        'message': 'Email sent',
        'info': 'Check your inbox',
      };

      final response = ForgetPasswordResponse.fromJson(json);

      expect(response.message, 'Email sent');
      expect(response.info, 'Check your inbox');
    });
  });
}
