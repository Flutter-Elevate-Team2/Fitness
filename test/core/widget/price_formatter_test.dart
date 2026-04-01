import 'package:fitness_app/core/widget/price_formatter.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('PriceFormatter', () {
    test('formats price correctly for English locale', () {
      final result = PriceFormatter.formatPrice(1234, locale: 'en');
      // Verify expected format: 1,234 EGP
      // Note: The space is a non-breaking space or standard space depending on implementation.
      // We match likely output.
      expect(result, contains('1,234'));
      expect(result, contains('EGP'));
    });

    test('formats price correctly for Arabic locale', () {
      final result = PriceFormatter.formatPrice(5678, locale: 'ar');
      // Verify expected format: 5,678 جنيه
      expect(result, contains('5,678'));
      expect(result, contains('جنيه'));
    });

    test('formats zero correctly', () {
      final result = PriceFormatter.formatPrice(0, locale: 'en');
      expect(result, contains('0'));
      expect(result, contains('EGP'));
    });
  });
}
