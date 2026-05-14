import 'package:flutter_test/flutter_test.dart';
import 'package:fitness_app/Features/auth/data/models/forget_password_models/response/verify_reset_password_response/verify_reset_password_response.dart';

void main() {
  group('VerifyResetPasswordResponse', () {
    test('toJson returns correct map', () {
      final response = VerifyResetPasswordResponse(status: 'success');

      final json = response.toJson();

      expect(json, {
        'status': 'success',
      });
    });

    test('fromJson creates correct object', () {
      final json = {
        'status': 'success',
      };

      final response = VerifyResetPasswordResponse.fromJson(json);

      expect(response.status, 'success');
    });
  });
}
