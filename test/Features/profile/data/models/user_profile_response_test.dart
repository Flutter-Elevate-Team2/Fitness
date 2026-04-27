import 'package:fitness_app/Features/profile/data/models/user_profile_response.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('UserProfileResponse Serialization Tests', () {

    final jsonMap = {
      "message": "Success",
      "user": {
        "_id": "60d5ec49",
        "firstName": "Ahmed",
        "lastName": "Ali",
        "email": "ahmed@example.com",
        "gender": "male",
        "age": 28,
        "weight": 75,
        "height": 175,
        "activityLevel": "moderate",
        "goal": "fitness",
        "photo": "https://example.com/photo.jpg",
        "createdAt": "2023-01-01T10:00:00Z"
      }
    };

    test('fromJson should parse correctly', () {
      final result = UserProfileResponse.fromJson(jsonMap);

      expect(result.message, "Success");
      expect(result.user, isNotNull);

      final user = result.user!;
      expect(user.id, "60d5ec49");
      expect(user.firstName, "Ahmed");
      expect(user.lastName, "Ali");
      expect(user.email, "ahmed@example.com");
      expect(user.gender, "male");
      expect(user.age, 28);
      expect(user.weight, 75);
      expect(user.height, 175);
      expect(user.activityLevel, "moderate");
      expect(user.goal, "fitness");
      expect(user.photo, "https://example.com/photo.jpg");
    });

    test('toJson should return valid data even if user is object', () {
      final user = User(
        id: "123",
        firstName: "Salem",
        lastName: "Ali",
        email: "salem@test.com",
      );

      final response = UserProfileResponse(
        message: "Done",
        user: user,
      );

      final resultJson = response.toJson();

      expect(resultJson["message"], "Done");

      final userField = resultJson["user"];

       if (userField is User) {
        expect(userField.id, "123");
        expect(userField.firstName, "Salem");
        expect(userField.lastName, "Ali");
        expect(userField.email, "salem@test.com");
      }
       else if (userField is Map<String, dynamic>) {
        expect(userField["_id"], "123");
        expect(userField["firstName"], "Salem");
        expect(userField["lastName"], "Ali");
        expect(userField["email"], "salem@test.com");
      } else {
        fail("Unexpected type for user field");
      }
    });
    test('fromJson should handle null safely', () {
      final emptyJson = <String, dynamic>{};

      final result = UserProfileResponse.fromJson(emptyJson);

      expect(result.message, isNull);
      expect(result.user, isNull);
    });

    test('toJson should handle null user', () {
      final response = UserProfileResponse(
        message: "Only message",
        user: null,
      );

      final json = response.toJson();

      expect(json["message"], "Only message");
      expect(json["user"], isNull);
    });
  });
}