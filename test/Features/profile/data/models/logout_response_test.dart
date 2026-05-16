import 'package:flutter_test/flutter_test.dart';
import 'package:fitness_app/Features/profile/data/models/logout_response.dart';

void main() {
  group('LogoutResponse Code Coverage Tests', () {
    const String testMessage = 'Logged out successfully';

    test('should create instance from json correctly', () {
      final json = {'message': testMessage};

      final result = LogoutResponse.fromJson(json);

      expect(result.message, testMessage);
    });

    test('should convert instance to json mapping correctly', () {
      final response = LogoutResponse(message: testMessage);

      final json = response.toJson();

      expect(json['message'], testMessage);
    });

    test('should throw an error if message key is missing in json', () {
      final json = <String, dynamic>{};

      expect(() => LogoutResponse.fromJson(json), throwsA(isA<TypeError>()));
    });

    test('should ensure message type is String in result map', () {
      final response = LogoutResponse(message: testMessage);

      final json = response.toJson();

      expect(json['message'], isA<String>());
    });
  });
}