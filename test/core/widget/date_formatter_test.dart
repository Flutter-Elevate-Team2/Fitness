import 'package:fitness_app/core/widget/date_formatter.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('formatDate Utility Tests', () {

    test('should format ISO date string correctly', () {
      // Arrange
      const inputDate = "2026-02-05T14:30:00.000Z";

      // Act
      final result = formatDate(inputDate);

      // Assert
      expect(result, "5 Feb 2026");
    });

    test('should format simple date string correctly', () {
      const inputDate = "2024-01-01";
      final result = formatDate(inputDate);
      expect(result, "1 Jan 2024");
    });

    test('should return original string if date format is invalid', () {
      // Arrange
      const invalidDate = "not-a-date";

      // Act
      final result = formatDate(invalidDate);

      // Assert
      expect(result, "not-a-date");
    });

    test('should handle empty string gracefully', () {
      const emptyInput = "";
      final result = formatDate(emptyInput);
      expect(result, "");
    });
  });
}