import 'package:fitness_app/core/theming/app_typography.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('AppTypography Tests', () {
    test('should verify all text styles are defined correctly', () {
      expect(AppTypography.fontFamily, 'BalooThambi2');

      expect(AppTypography.headlineLarge.fontSize, 24);
      expect(AppTypography.headlineLarge.fontWeight, FontWeight.w800);
      expect(AppTypography.headlineLarge.height, 1.4);

      expect(AppTypography.titleLarge.fontSize, 20);
      expect(AppTypography.titleLarge.fontWeight, FontWeight.w800);

      expect(AppTypography.bodyLarge.fontSize, 18);
      expect(AppTypography.bodyMedium.fontSize, 16);

      expect(AppTypography.labelLarge.fontSize, 12);
      expect(AppTypography.labelMedium.fontSize, 8);
      expect(AppTypography.labelSmall.fontSize, 6);
    });

    test('all styles should have consistent weight', () {
      expect(AppTypography.bodyLarge.fontWeight, FontWeight.w400);
      expect(AppTypography.bodyMedium.fontWeight, FontWeight.w600);
    });
  });
}