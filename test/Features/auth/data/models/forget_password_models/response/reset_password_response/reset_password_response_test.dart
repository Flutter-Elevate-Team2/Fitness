import 'package:flutter_test/flutter_test.dart';
import 'package:fitness_app/Features/auth/data/models/forget_password_models/response/reset_password_response/reset_password_response.dart';

void main() {
  group('ResetPasswordResponse', () {
    test('toJson returns correct map', () {
      final response = ResetPasswordResponse(
        message: 'Password reset successful',
        token: 'new_token_123',
      );

      final json = response.toJson();

      expect(json, {
        'message': 'Password reset successful',
        'token': 'new_token_123',
      });
    });

    test('fromJson creates correct object', () {
      final json = {
        'message': 'Password reset successful',
        'token': 'new_token_123',
      };

      final response = ResetPasswordResponse.fromJson(json);

      expect(response.message, 'Password reset successful');
      expect(response.token, 'new_token_123');
    });
  });
}
