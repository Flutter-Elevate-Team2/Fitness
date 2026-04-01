import 'package:fitness_app/core/helpers/app_regex.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('AppRegex Validation Tests', () {

    // --- Email Validation ---
    test('isEmailValid returns true for valid email', () {
      expect(AppRegex.isEmailValid('test@example.com'), true);
      expect(AppRegex.isEmailValid('name.surname@domain.co'), true);
    });

    test('isEmailValid returns false for invalid email', () {
      expect(AppRegex.isEmailValid('testexample.com'), false); // Missing @
      expect(AppRegex.isEmailValid('test@com'), false); // Missing domain part
      expect(AppRegex.isEmailValid(''), false); // Empty
    });

    // --- Password Validation ---
    test('isPasswordValid returns true for strong password', () {
      // Has Upper, Lower, Digit, Special, length > 8
      expect(AppRegex.isPasswordValid('StrongP@ss1'), true);
    });

    test('isPasswordValid returns false for weak passwords', () {
      expect(AppRegex.isPasswordValid('weak'), false); // Too short
      expect(AppRegex.isPasswordValid('NoSpecialChar1'), false); // No special char
      expect(AppRegex.isPasswordValid('nohuupercase@1'), false); // No Uppercase
    });

    // --- Phone Validation ---
    test('isPhoneNumberValid returns true for valid phones', () {
      expect(AppRegex.isPhoneNumberValid('01012345678'), true);
      expect(AppRegex.isPhoneNumberValid('+201012345678'), true);
    });

    test('isPhoneNumberValid returns false for invalid phones', () {
      expect(AppRegex.isPhoneNumberValid('123'), false); // Too short
      expect(AppRegex.isPhoneNumberValid('01012345678abc'), false); // Contains letters
    });

    // --- Helper Methods Tests ---
    test('hasLowerCase checks correctly', () {
      expect(AppRegex.hasLowerCase('PASS'), false);
      expect(AppRegex.hasLowerCase('Pass'), true);
    });

    test('hasUpperCase checks correctly', () {
      expect(AppRegex.hasUpperCase('pass'), false);
      expect(AppRegex.hasUpperCase('Pass'), true);
    });

    test('hasNumber checks correctly', () {
      expect(AppRegex.hasNumber('NoNumber'), false);
      expect(AppRegex.hasNumber('Yes1Number'), true);
    });

    test('hasSpecialCharacter checks correctly', () {
      expect(AppRegex.hasSpecialCharacter('NormalText'), false);
      expect(AppRegex.hasSpecialCharacter('Special@Text'), true);
    });

    test('hasMinLength checks correctly (min 8)', () {
      expect(AppRegex.hasMinLength('1234567'), false);
      expect(AppRegex.hasMinLength('12345678'), true);
    });
  });
}
