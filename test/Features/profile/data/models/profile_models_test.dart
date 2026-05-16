import 'package:fitness_app/Features/profile/data/models/user_profile_response.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('UserProfileResponse', () {
    test('fromJson should deserialize correctly', () {
      // Arrange
      final json = {
        'message': 'Profile fetched successfully',
        'user': {
          '_id': 'user123',
          'country': 'Egypt',
          'firstName': 'Ahmed',
          'lastName': 'Mohamed',
          'vehicleType': 'Sedan',
          'vehicleNumber': 'ABC123',
          'vehicleLicense': 'LIC123',
          'NID': '12345678901234',
          'NIDImg': 'https://example.com/nid.jpg',
          'email': 'ahmed@example.com',
          'gender': 'male',
          'phone': '+201234567890',
          'photo': 'https://example.com/photo.jpg',
          'role': 'user',
          'createdAt': '2024-01-01T00:00:00Z',
        },
      };

      // Act
      final response = UserProfileResponse.fromJson(json);

      // Assert
      expect(response.message, 'Profile fetched successfully');
      expect(response.user, isNotNull);
      expect(response.user!.id, 'user123');
      expect(response.user!.firstName, 'Ahmed');
      expect(response.user!.lastName, 'Mohamed');
      expect(response.user!.email, 'ahmed@example.com');
      expect(response.user!.gender, 'male');
    });

    test('should handle null values', () {
      // Arrange
      final json = <String, dynamic>{};

      // Act
      final response = UserProfileResponse.fromJson(json);

      // Assert
      expect(response.message, isNull);
      expect(response.user, isNull);
    });
  });

  group('UserModel', () {
    test('fromJson should deserialize correctly with all fields', () {
      // Arrange
      final json = {
        '_id': 'user456',
        'country': 'Egypt',
        'firstName': 'John',
        'lastName': 'Doe',
        'email': 'john@example.com',
        'gender': 'male',
        'photo': 'https://example.com/photo2.jpg',
        'age': 20,
        'weight': 70,
        'height': 170,
        'activityLevel': 'Intermediate',
        'goal': 'Lose Weight',
        'createdAt': '2024-02-01T00:00:00Z',
      };

      // Act
      final user = User.fromJson(json);

      // Assert
      expect(user.id, 'user456');
      expect(user.firstName, 'John');
      expect(user.lastName, 'Doe');
      expect(user.email, 'john@example.com');
      expect(user.gender, 'male');
      expect(user.age, 20);
      expect(user.weight, 70);
      expect(user.height, 170);
      expect(user.activityLevel, 'Intermediate');
      expect(user.goal, 'Lose Weight');
      expect(user.photo, 'https://example.com/photo2.jpg');
      expect(user.createdAt, '2024-02-01T00:00:00Z');
    });

    test('should handle null values', () {
      // Arrange
      final json = <String, dynamic>{};

      // Act
      final user = User.fromJson(json);

      // Assert
      expect(user.id, isNull);
      expect(user.firstName, isNull);
      expect(user.lastName, isNull);
      expect(user.email, isNull);
    });
  });
}
