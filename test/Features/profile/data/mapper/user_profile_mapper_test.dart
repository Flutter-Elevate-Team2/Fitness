import 'package:fitness_app/Features/profile/data/mapper/user_profile_mapper.dart';
import 'package:fitness_app/Features/profile/data/models/user_profile_response.dart';
import 'package:fitness_app/Features/profile/domain/entities/user_entity.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('UserProfileMapper', () {
    test('toEntity should map UserProfileResponse to UserEntity', () {
      // arrange
      final response = UserProfileResponse(
        message: 'Success',
        user: User(
          id: '123',
          firstName: 'John',
          lastName: 'Doe',
          email: 'john@example.com',
           photo: 'photo.jpg',
           gender: 'Male',
           age: 20,
          weight:  70,
          height: 170,
          activityLevel: 'Intermediate',
          goal: 'Lose Weight',
         ),
      );

      // act
      final entity = response.toEntity();

      // assert
      expect(entity, isA<UserEntity>());
      expect(entity.id, '123');
      expect(entity.firstName, 'John');
      expect(entity.lastName, 'Doe');
      expect(entity.email, 'john@example.com');
       expect(entity.photo, 'photo.jpg');
       expect(entity.gender, 'Male');
       expect(entity.age, 20);
      expect(entity.weight, 70);
      expect(entity.height, 170);
      expect(entity.activityLevel, 'Intermediate');
      expect(entity.goal, 'Lose Weight');
    });

    test('toEntity should handle null user data gracefully', () {
      // arrange
      final response = UserProfileResponse(message: 'Error', user: null);

      // act
      final entity = response.toEntity();

      // assert
      expect(entity, isA<UserEntity>());
      expect(entity.id, '');
      expect(entity.firstName, '');
      expect(entity.lastName, '');
      expect(entity.email, '');
       expect(entity.photo, '');
     });
  });
}
