import 'package:fitness_app/Features/auth/data/models/login_models/login_response.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('LoginResponse JSON Tests', () {
    final tJson = {
      "message": "Success",
      "token": "abc123",
    };

    final tLoginResponse = LoginResponse(
      message: "Success",
      token: "abc123",
    );

    test('fromJson should return valid LoginResponse object', () {
      final result = LoginResponse.fromJson(tJson);

      expect(result, isA<LoginResponse>());
      expect(result.message, tLoginResponse.message);
      expect(result.token, tLoginResponse.token);
    });

    test('toJson should return proper Map', () {
      final result = tLoginResponse.toJson();

      expect(result, isA<Map<String, dynamic>>());
      expect(result['message'], tJson['message']);
      expect(result['token'], tJson['token']);
    });

    test('should handle null fields', () {
      final emptyResponse = LoginResponse();

      final json = emptyResponse.toJson();
      expect(json['message'], null);
      expect(json['token'], null);
    });
  });
}
