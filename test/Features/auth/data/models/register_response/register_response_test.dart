import 'package:fitness_app/Features/auth/data/models/register_response/register_response.dart';
import 'package:fitness_app/Features/auth/data/models/register_response/user.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('RegisterResponse Model Test', () {
    final tUser = User(
      id: '123',
      email: 'test@example.com',
      firstName: 'malak',
      lastName: 'malak',
      gender: 'female',
      height: 0,
      weight: 0,
      age: 0,
    );

    final tRegisterResponse = RegisterResponse(
      message: 'Success',
      token: 'fake_token_123',
      user: tUser,
    );

    final tJson = {
      'message': 'Success',
      'token': 'fake_token_123',
      'user': {
        '_id': '123',
        'email': 'test@example.com',
        'firstName': 'malak',
        'lastName': 'malak',
        'gender': 'female',
        'height': 0,
        'weight': 0,
        'age': 0,
        'activityLevel': null,
        'goal': null,
        'photo': null,
        'createdAt': null,
      },
    };

    test('should return a valid model from JSON', () {
      // Act
      final result = RegisterResponse.fromJson(tJson);

      // Assert
      expect(result.message, tRegisterResponse.message);
      expect(result.token, tRegisterResponse.token);
      expect(result.user?.email, tRegisterResponse.user?.email);
    });

    test('should return a JSON map containing the proper data', () {
      // Act
      final result = tRegisterResponse.toJson();

      // Assert
      expect(result, tJson);
    });

    test('should handle null values when JSON is empty', () {
      // Act
      final result = RegisterResponse.fromJson({});

      // Assert
      expect(result.message, null);
      expect(result.user, null);
      expect(result.token, null);
    });
  });
}