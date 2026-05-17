import 'package:fitness_app/Features/auth/data/models/register_request/register_request.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('RegisterRequest Model Test', () {
    final tRegisterRequest = RegisterRequest(
      firstName: 'Ahmed',
      lastName: 'Ali',
      email: 'test@example.com',
      password: 'password123',
      rePassword: 'password123',
      gender: 'male',
      height: 180,
      weight: 75,
      age: 25,
      goal: 'lose_weight',
      activityLevel: 'active',
    );

    final tJson = {
      'firstName': 'Ahmed',
      'lastName': 'Ali',
      'email': 'test@example.com',
      'password': 'password123',
      'rePassword': 'password123',
      'gender': 'male',
      'height': 180,
      'weight': 75,
      'age': 25,
      'goal': 'lose_weight',
      'activityLevel': 'active',
    };

    test('should return a valid model from JSON', () {
      // Act
      final result = RegisterRequest.fromJson(tJson);

      // Assert
      expect(result.firstName, tRegisterRequest.firstName);
      expect(result.email, tRegisterRequest.email);
      expect(result.age, tRegisterRequest.age);
    });

    test('should return a JSON map containing the proper data', () {
      // Act
      final result = tRegisterRequest.toJson();

      // Assert
      expect(result, tJson);
    });

    test('should handle null values correctly', () {
      // Act
      final emptyModel = RegisterRequest();
      final json = emptyModel.toJson();

      // Assert
      expect(json['firstName'], null);
      expect(RegisterRequest.fromJson({}).firstName, null);
    });
  });
}