import 'package:flutter_test/flutter_test.dart';
import 'package:fitness_app/Features/auth/data/mappers/forget_password_mappers/verify_reset_password_mapper.dart';
import 'package:fitness_app/Features/auth/data/models/forget_password_models/response/verify_reset_password_response/verify_reset_password_response.dart';
import 'package:fitness_app/Features/auth/domain/entities/forget_password_entities/verify_reset_password_entity.dart';

void main() {
  group('VerifyResetPasswordMapper', () {
    test(
      'should map VerifyResetPasswordResponse to VerifyResetPasswordEntity correctly',
      () {
        // arrange
        final response = VerifyResetPasswordResponse(status: 'success');

        // act
        final entity = response.toEntity();

        // assert
        expect(entity, isA<VerifyResetPasswordEntity>());
        expect(entity.status, 'success');
      },
    );

    test('should return empty string when status is null', () {
      // arrange
      final response = VerifyResetPasswordResponse();

      // act
      final entity = response.toEntity();

      // assert
      expect(entity.status, '');
    });
  });
}
