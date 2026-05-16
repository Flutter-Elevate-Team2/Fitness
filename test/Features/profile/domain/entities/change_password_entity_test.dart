import 'package:flutter_test/flutter_test.dart';
import 'package:fitness_app/Features/profile/domain/entities/change_password_entity.dart';

void main() {
  group('ChangePasswordEntity Code Coverage Tests', () {
    const String testMessage = 'Success';
    const String testToken = 'token_123';

    test('should initialize with correct values', () {
      const entity = ChangePasswordEntity(
        message: testMessage,
        token: testToken,
      );

      expect(entity.message, testMessage);
      expect(entity.token, testToken);
    });

    test('should ensure fields are assigned the correct types', () {
      const entity = ChangePasswordEntity(
        message: 'Valid Message',
        token: 'Valid Token',
      );

      expect(entity.message, isA<String>());
      expect(entity.token, isA<String>());
    });

    test('should support const constructor for optimization', () {
      const entity1 = ChangePasswordEntity(message: 'm', token: 't');
      const entity2 = ChangePasswordEntity(message: 'm', token: 't');

      expect(identical(entity1, entity2), isTrue);
    });
  });
}