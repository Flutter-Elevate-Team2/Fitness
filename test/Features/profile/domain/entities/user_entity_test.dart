import 'package:fitness_app/Features/profile/domain/entities/user_entity.dart';
import 'package:flutter_test/flutter_test.dart';
 void main() {
  group('UserEntity Tests', () {
     final tUserEntity = UserEntity(
      id: '1',
      firstName: 'Ahmed',
      lastName: 'Ali',
      email: 'ahmed@example.com',
      photo: 'photo_url',
      gender: 'male',
      age: 25,
      weight: 80,
      height: 180,
      activityLevel: 'active',
      goal: 'lose weight',
    );

    test('should create UserEntity instance with correct properties', () {
      // Assert
      expect(tUserEntity.id, '1');
      expect(tUserEntity.firstName, 'Ahmed');
      expect(tUserEntity.age, 25);
    });

    group('copyWith', () {
      test('should return a new object with updated values when copyWith is called', () {
        // Act
        final updatedUser = tUserEntity.copyWith(firstName: 'Khalid', age: 30);

        // Assert
        expect(updatedUser.firstName, 'Khalid');
        expect(updatedUser.age, 30);
        expect(updatedUser.id, tUserEntity.id);
        expect(updatedUser.email, tUserEntity.email);
      });

      test('should keep original values if copyWith is called with no arguments', () {
        // Act
        final updatedUser = tUserEntity.copyWith();

        // Assert
        expect(updatedUser.id, tUserEntity.id);
        expect(updatedUser.firstName, tUserEntity.firstName);
      });
    });
  });
}