import 'package:flutter_test/flutter_test.dart';
import 'package:fitness_app/Features/auth/data/models/forget_password_models/request/forget_password_request/forget_password_request.dart';

void main() {
  group('ForgetPasswordRequest', () {
    test('toJson returns correct map', () {
      final request = ForgetPasswordRequest(email: 'test@test.com');

      final json = request.toJson();

      expect(json, {
        'email': 'test@test.com',
      });
    });

    test('fromJson creates correct object', () {
      final json = {
        'email': 'test@test.com',
      };

      final request = ForgetPasswordRequest.fromJson(json);

      expect(request.email, 'test@test.com');
    });
  });
}
