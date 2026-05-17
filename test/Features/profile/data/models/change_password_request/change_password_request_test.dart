// ignore_for_file: depend_on_referenced_packages

import 'package:fitness_app/Features/profile/data/models/change_password_request/change_password_request.dart';
import 'package:test/test.dart';

void main() {
  group('ChangePasswordRequest Tests', () {
    test('should create an instance from JSON', () {
      final json = {
        'password': 'old_password_123',
        'newPassword': 'new_password_456',
      };

      final result = ChangePasswordRequest.fromJson(json);

      expect(result.password, 'old_password_123');
      expect(result.newPassword, 'new_password_456');
    });

    test('should convert instance to JSON', () {
      final request = ChangePasswordRequest(
        password: 'current_password',
        newPassword: 'next_password',
      );

      final json = request.toJson();

      expect(json['password'], 'current_password');
      expect(json['newPassword'], 'next_password');
    });

    test('should handle null values', () {
      final json = <String, dynamic>{
        'password': null,
        'newPassword': null,
      };

      final result = ChangePasswordRequest.fromJson(json);

      expect(result.password, isNull);
      expect(result.newPassword, isNull);
    });
  });
}