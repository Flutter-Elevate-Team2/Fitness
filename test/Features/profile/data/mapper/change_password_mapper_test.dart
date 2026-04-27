import 'package:flutter_test/flutter_test.dart';
import 'package:fitness_app/Features/profile/data/mapper/change_password_mapper.dart';
import 'package:fitness_app/Features/profile/data/models/change_password_response/change_password_response.dart';

void main() {
  group('ChangePasswordMapper', () {
    test('toEntity maps message and token correctly', () {
      final response = ChangePasswordResponse(
        message: 'Password changed',
        token: 'new_token_123',
      );

      final entity = response.toEntity();

      expect(entity.message, 'Password changed');
      expect(entity.token, 'new_token_123');
    });

    test('toEntity maps null message to empty string', () {
      final response = ChangePasswordResponse(message: null, token: 'token');

      final entity = response.toEntity();

      expect(entity.message, '');
    });

    test('toEntity maps null token to empty string', () {
      final response = ChangePasswordResponse(message: 'msg', token: null);

      final entity = response.toEntity();

      expect(entity.token, '');
    });

    test('toEntity maps all null fields to empty strings', () {
      final response = ChangePasswordResponse();

      final entity = response.toEntity();

      expect(entity.message, '');
      expect(entity.token, '');
    });

    test('toEntity preserves empty string values', () {
      final response = ChangePasswordResponse(message: '', token: '');

      final entity = response.toEntity();

      expect(entity.message, '');
      expect(entity.token, '');
    });
  });
}
