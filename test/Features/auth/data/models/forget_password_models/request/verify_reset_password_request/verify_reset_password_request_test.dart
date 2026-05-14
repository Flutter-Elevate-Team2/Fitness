import 'package:flutter_test/flutter_test.dart';
import 'package:fitness_app/Features/auth/data/models/forget_password_models/request/verify_reset_password_request/verify_reset_password_request.dart';

void main() {
  group('VerifyResetPasswordRequest', () {
    test('toJson returns correct map', () {
      final request = VerifyResetPasswordRequest(resetCode: '123456');

      final json = request.toJson();

      expect(json, {
        'resetCode': '123456',
      });
    });

    test('fromJson creates correct object', () {
      final json = {
        'resetCode': '123456',
      };

      final request = VerifyResetPasswordRequest.fromJson(json);

      expect(request.resetCode, '123456');
    });
  });
}
