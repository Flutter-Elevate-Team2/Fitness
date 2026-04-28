/// Application-level configuration sourced from compile-time defines.
///
/// Values are injected via `--dart-define` or `--dart-define-from-file`.
/// Example: `flutter run --dart-define=GEMINI_API_KEY=<your-key>`
class AppConfig {
  AppConfig._();

  /// Gemini API key — NEVER hard-code this value.
  static const String geminiApiKey = String.fromEnvironment('AIzaSyAO477c4ZaakaohTBZzutSURJhXn6hdKqM');
}
