import 'package:fitness_app/core/theming/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('AppColors Tests', () {
    test('should verify all colors are defined correctly', () {
      expect(AppColors.primary, const Color(0xFFFF4100));
      expect(AppColors.white, const Color(0xFFFFFFFF));
      expect(AppColors.black, const Color(0xFF000000));
      expect(AppColors.red, const Color(0xFFE53935));

      expect(AppColors.light200, isA<Color>());
      expect(AppColors.orange100, isA<Color>());
      expect(AppColors.dark100, isA<Color>());
      expect(AppColors.blackSoft, isA<Color>());
    });
  });
}