import 'package:fitness_app/core/theming/app_colors.dart';
import 'package:fitness_app/core/theming/app_theming.dart';
import 'package:fitness_app/core/theming/app_typography.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('AppTheme Tests', () {
    // test('lightTheme should have correct configuration', () {
    //   final theme = AppTheme.lightTheme;
    //
    //   expect(theme.useMaterial3, isTrue);
    //
    //   expect(theme.textTheme.bodyLarge?.fontFamily, AppTypography.fontFamily);
    //
    //   expect(theme.colorScheme.primary, AppColors.primary);
    //   expect(theme.colorScheme.error, AppColors.red);
    //   expect(theme.colorScheme.onSurface, AppColors.primary);
    //
    //   // 3. فحص AppBarTheme
    //   expect(theme.appBarTheme.centerTitle, isTrue);
    //   expect(theme.appBarTheme.elevation, 0);
    //   expect(theme.appBarTheme.iconTheme?.color, AppColors.white);
    //
    //   // 4. فحص الـ TextTheme
    //   expect(theme.textTheme.headlineLarge, AppTypography.headlineLarge);
    //   expect(theme.textTheme.bodyMedium, AppTypography.bodyMedium);
    //
    //   // 5. فحص الـ ElevatedButtonTheme
    //   final btnStyle = theme.elevatedButtonTheme.style;
    //
    //   // بنستخدم {} لأننا بنفحص الحالة الافتراضية (Default/Enabled)
    //   expect(btnStyle?.backgroundColor?.resolve({}), AppColors.primary);
    //   expect(btnStyle?.foregroundColor?.resolve({}), AppColors.white);
    //
    //   final shape = btnStyle?.shape?.resolve({}) as RoundedRectangleBorder;
    //   expect(shape.borderRadius, BorderRadius.circular(12));
    // });

    test('InputDecorationTheme should have correct borders', () {
      final inputTheme = AppTheme.lightTheme.inputDecorationTheme;

      // فحص الـ Enabled Border
      final enabledBorder = inputTheme.enabledBorder as OutlineInputBorder;
      expect(enabledBorder.borderSide.color, AppColors.light400);
      expect(enabledBorder.borderRadius, BorderRadius.circular(12));

      // فحص الـ Focused Border
      final focusedBorder = inputTheme.focusedBorder as OutlineInputBorder;
      expect(focusedBorder.borderSide.color, AppColors.primary);
      expect(focusedBorder.borderSide.width, 1.5);

      // فحص الـ Error Border
      final errorBorder = inputTheme.errorBorder as OutlineInputBorder;
      expect(errorBorder.borderSide.color, AppColors.red);
    });
  });
}