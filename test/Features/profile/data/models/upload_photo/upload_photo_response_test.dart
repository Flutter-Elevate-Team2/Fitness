import 'package:fitness_app/Features/profile/data/models/upload_photo/upload_photo_response.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('UploadPhotoResponse Tests', () {
    test('fromJson should return a valid UploadPhotoResponse model', () {
      // Arrange
      final Map<String, dynamic> jsonMap = {
        'message': 'Photo uploaded successfully',
      };

      // Act
      final result = UploadPhotoResponse.fromJson(jsonMap);

      // Assert
      expect(result.message, 'Photo uploaded successfully');
    });

    test('toJson should return a valid map from UploadPhotoResponse model', () {
      // Arrange
      final photoResponse = UploadPhotoResponse(
        message: 'Photo uploaded successfully',
      );

      // Act
      final result = photoResponse.toJson();

      // Assert
      final expectedMap = {'message': 'Photo uploaded successfully'};
      expect(result, expectedMap);
    });
  });
}
