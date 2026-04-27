import 'package:fitness_app/Features/profile/data/models/edit_profile_request.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('EditProfileRequest Tests', () {
    test('should convert instance to JSON correctly', () {
      final request = EditProfileRequest(
        firstName: 'Ziad',
        lastName: 'Ahmed',
        email: 'ziad@example.com',
        phone: '0123456789',
      );

      final json = request.toJson();

      expect(json['firstName'], 'Ziad');
      expect(json['lastName'], 'Ahmed');
      expect(json['email'], 'ziad@example.com');
      expect(json['phone'], '0123456789');
    });

    test('should handle null fields in toJson', () {
      final request = EditProfileRequest(
        firstName: 'Ziad',
        email: null,
      );

      final json = request.toJson();

      expect(json['firstName'], 'Ziad');
      expect(json['lastName'], isNull);
      expect(json['email'], isNull);
      expect(json['phone'], isNull);
    });

    test('should create instance with all null values', () {
      final request = EditProfileRequest();

      final json = request.toJson();

      expect(json['firstName'], isNull);
      expect(json['lastName'], isNull);
      expect(json['email'], isNull);
      expect(json['phone'], isNull);
    });
  });
}