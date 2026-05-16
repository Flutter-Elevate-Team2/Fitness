import 'package:fitness_app/Features/auth/data/mappers/login_mapper/login_mapper.dart';
import 'package:fitness_app/Features/auth/data/models/login_models/login_response.dart';
import 'package:fitness_app/Features/auth/domain/entities/login_entity/login_entity.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('LoginResponseMapper', () {
    test('toEntity should convert LoginResponse to LoginEntity correctly', () {
      // Arrange
      final loginResponse = LoginResponse(message: 'Success', token: 'abc123');

      // Act
      final entity = loginResponse.toEntity();

      // Assert
      expect(entity, isA<LoginEntity>());
      expect(entity.message, loginResponse.message);
      expect(entity.token, loginResponse.token);
    });
  });
}
