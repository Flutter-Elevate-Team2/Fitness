import 'package:flutter_test/flutter_test.dart';
import 'package:fitness_app/Features/auth/data/models/forget_password_models/request/reset_password_request/reset_password_request.dart';

void main() {
  group('ResetPasswordRequest', () {
    test('toJson returns correct map', () {
      final request = ResetPasswordRequest(
        email: 'test@test.com',
        newPassword: '12345678',
      );

      final json = request.toJson();

      expect(json, {'email': 'test@test.com', 'newPassword': '12345678'});
    });

    test('fromJson creates correct object', () {
      final json = {'email': 'test@test.com', 'newPassword': '12345678'};

      final request = ResetPasswordRequest.fromJson(json);

      expect(request.email, 'test@test.com');
      expect(request.newPassword, '12345678');
    });
  });
}
