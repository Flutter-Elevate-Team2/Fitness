import 'package:flutter_test/flutter_test.dart';
import 'package:fitness_app/Features/auth/data/mappers/forget_password_mappers/forget_password_mapper.dart';
import 'package:fitness_app/Features/auth/data/models/forget_password_models/response/forget_password_response/forget_password_response.dart';
import 'package:fitness_app/Features/auth/domain/entities/forget_password_entities/forget_password_entity.dart';

void main() {
  group('ForgetPasswordMapper', () {
    test(
      'should map ForgetPasswordResponse to ForgetPasswordEntity correctly',
      () {
        // arrange
        final response = ForgetPasswordResponse(
          message: 'Code sent successfully',
          info: 'Check your email',
        );

        // act
        final entity = response.toEntity();

        // assert
        expect(entity, isA<ForgetPasswordEntity>());
        expect(entity.message, 'Code sent successfully');
        expect(entity.info, 'Check your email');
      },
    );

    test('should return empty strings when response fields are null', () {
      // arrange
      final response = ForgetPasswordResponse();

      // act
      final entity = response.toEntity();

      // assert
      expect(entity.message, '');
      expect(entity.info, '');
    });
  });
}
