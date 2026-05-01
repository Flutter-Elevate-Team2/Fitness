/// Thrown when the Gemini API blocks a response due to safety filters.
///
/// The Cubit maps this exception to [SmartCoachSafetyBlocked] state,
/// which displays a localised safety message to the user.
class GeminiSafetyException implements Exception {
  final String message;

  const GeminiSafetyException([
    this.message = 'Response blocked by Gemini safety filters.',
  ]);

  @override
  String toString() => 'GeminiSafetyException: $message';
}
