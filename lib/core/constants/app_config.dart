import 'package:flutter_dotenv/flutter_dotenv.dart';

/// Application-level configuration.
///
/// Values are injected via the .env file.
class AppConfig {
  AppConfig._();

  /// Gemini API key — NEVER hard-code this value.
  static String get geminiApiKey => dotenv.env['GEMINI_API_KEY'] ?? '';
}
