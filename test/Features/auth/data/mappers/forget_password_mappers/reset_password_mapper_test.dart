import 'package:flutter_test/flutter_test.dart';
import 'package:fitness_app/Features/auth/data/mappers/forget_password_mappers/reset_password_mapper.dart';
import 'package:fitness_app/Features/auth/data/models/forget_password_models/response/reset_password_response/reset_password_response.dart';
import 'package:fitness_app/Features/auth/domain/entities/forget_password_entities/reset_password_entity.dart';

void main() {
  group('ResetPasswordMapper', () {
    test(
      'should map ResetPasswordResponse to ResetPasswordEntity correctly',
      () {
        // arrange
        final response = ResetPasswordResponse(
          message: 'Password reset successfully',
          token: 'token_123',
        );

        // act
        final entity = response.toEntity();

        // assert
        expect(entity, isA<ResetPasswordEntity>());
        expect(entity.message, 'Password reset successfully');
        expect(entity.token, 'token_123');
      },
    );

    test('should return empty strings when response fields are null', () {
      // arrange
      final response = ResetPasswordResponse();

      // act
      final entity = response.toEntity();

      // assert
      expect(entity.message, '');
      expect(entity.token, '');
    });
  });
}
