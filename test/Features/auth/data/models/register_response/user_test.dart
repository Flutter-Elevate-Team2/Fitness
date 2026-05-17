import 'package:flutter_test/flutter_test.dart';
import 'package:fitness_app/Features/auth/data/models/register_response/user.dart';

void main() {
  group('User Model Test', () {
    final tCreatedAt = DateTime.parse("2024-03-20T10:00:00Z");

    final tUser = User(
      id: '123',
      firstName: 'Malak',
      lastName: 'Malak',
      email: 'test@example.com',
      gender: 'female',
      age: 22,
      weight: 60,
      height: 165,
      activityLevel: 'active',
      goal: 'fitness',
      photo: 'url_to_photo',
      createdAt: tCreatedAt,
    );

    final tJson = {
      '_id': '123',
      'firstName': 'Malak',
      'lastName': 'Malak',
      'email': 'test@example.com',
      'gender': 'female',
      'age': 22,
      'weight': 60,
      'height': 165,
      'activityLevel': 'active',
      'goal': 'fitness',
      'photo': 'url_to_photo',
      'createdAt': tCreatedAt.toIso8601String(),
    };

    test('should return a valid model from JSON', () {
      // Act
      final result = User.fromJson(tJson);

      // Assert
      expect(result.id, tUser.id);
      expect(result.firstName, tUser.firstName);
      expect(result.createdAt, tUser.createdAt);
    });

    test('should return a JSON map containing the proper data', () {
      // Act
      final result = tUser.toJson();

      // Assert
      expect(result, tJson);
      expect(result.containsKey('_id'), true);
      expect(result['_id'], '123');
    });

    test('should handle null values correctly', () {
      // Act
      final result = User.fromJson({});

      // Assert
      expect(result.id, null);
      expect(result.email, null);
    });
  });
}