/// Lightweight record used to pass message data from the Repository
/// to the Remote Data Source **without leaking domain entities** into
/// the data-source layer.
typedef ChatMessageRecord = ({String content, bool isUser});

/// Contract for the Gemini-backed remote data source.
///
/// The implementation streams tokens one chunk at a time from the
/// Gemini generative model.
abstract class SmartCoachRemoteDataSourceContract {
  /// Sends [history] to Gemini with [systemInstruction] prepended
  /// and returns a token-by-token [Stream].
  ///
  /// [apiKey] is the Gemini API key injected via DI.
  /// Throws a domain-specific exception on safety blocks or network errors.
  Stream<String> streamMessage({
    required String apiKey,
    required List<ChatMessageRecord> history,
    required String systemInstruction,
  });
}
