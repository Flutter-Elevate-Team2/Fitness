import 'package:fitness_app/Features/profile/data/models/change_password_response/change_password_response.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('ChangePasswordResponse Tests', () {
    test('should create an instance from JSON', () {
      final json = {
        'message': 'Password changed successfully',
        'token': 'abc123token',
      };

      final result = ChangePasswordResponse.fromJson(json);

      expect(result.message, 'Password changed successfully');
      expect(result.token, 'abc123token');
    });

    test('should convert instance to JSON', () {
      final response = ChangePasswordResponse(
        message: 'Success',
        token: 'xyz789token',
      );

      final json = response.toJson();

      expect(json['message'], 'Success');
      expect(json['token'], 'xyz789token');
    });

    test('should return null when JSON fields are missing', () {
      final json = <String, dynamic>{};

      final result = ChangePasswordResponse.fromJson(json);

      expect(result.message, isNull);
      expect(result.token, isNull);
    });
  });
}