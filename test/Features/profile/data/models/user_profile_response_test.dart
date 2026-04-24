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

    test('should return a valid model from JSON', () {
      // Act
      final result = UserProfileResponse.fromJson(jsonMap);

      // Assert
      expect(result.message, "Success");
      expect(result.user, isA<User>());
      expect(result.user?.id, "60d5ec49");
      expect(result.user?.firstName, "Ahmed");
      expect(result.user?.age, 28);
    });

     test('should return a JSON map containing proper data from model', () {
       // Arrange
       final user = User(id: "123", firstName: "Salem");
       final response = UserProfileResponse(message: "Done", user: user);

       // Act
       final resultJson = response.toJson();

       // Assert
       expect(resultJson["message"], "Done");

        final userField = resultJson["user"];

        if (userField is User) {
         expect(userField.id, "123");
         expect(userField.firstName, "Salem");
       } else if (userField is Map) {
         expect(userField["_id"], "123");
       }
     });

     test('should handle null values gracefully', () {
       final emptyJson = <String, dynamic>{};

      // Act
      final result = UserProfileResponse.fromJson(emptyJson);

      // Assert
      expect(result.message, isNull);
      expect(result.user, isNull);
    });
  });
}