import 'package:flutter/material.dart';

class AppTypography {
  AppTypography._(); // Private Constructor

  static const String fontFamily = 'BalooThambi2';

  static const TextStyle displayLarge = TextStyle(
    fontSize: 31,
    fontWeight: FontWeight.w700,
    height: 1.2,
  );

  static const TextStyle displayMedium = TextStyle(
    fontSize: 24,
    fontWeight: FontWeight.w700,
    height: 1.2,
  );

  static const TextStyle titleLarge = TextStyle(
    fontSize: 20,
    fontWeight: FontWeight.w600,
  );

  static const TextStyle bodyLarge = TextStyle(
    fontSize: 16,
    fontWeight: FontWeight.w400,
  );

  static const TextStyle bodyMedium = TextStyle(
    fontSize: 13,
    fontWeight: FontWeight.w400,
  );

  static const TextStyle labelLarge = TextStyle(
    fontSize: 10,
    fontWeight: FontWeight.w400,
  );

  static const TextStyle labelMedium = TextStyle(
    fontSize: 8,
    fontWeight: FontWeight.w400,
  );

  static const TextStyle labelSmall = TextStyle(
    fontSize: 6,
    fontWeight: FontWeight.w400,
  );
}
