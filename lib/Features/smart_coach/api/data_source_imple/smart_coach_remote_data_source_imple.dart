import 'dart:async';

import 'package:fitness_app/Features/smart_coach/data/data_source_contract/smart_coach_remote_data_source_contract.dart';
import 'package:fitness_app/core/errors/gemini_safety_exception.dart';
import 'package:google_generative_ai/google_generative_ai.dart';
import 'package:injectable/injectable.dart';

/// Gemini-backed implementation of [SmartCoachRemoteDataSourceContract].
///
/// Streams tokens one chunk at a time using [GenerativeModel.generateContentStream].
/// A new [GenerativeModel] instance is created per call because the
/// system instruction and API key may vary at runtime.
@Injectable(as: SmartCoachRemoteDataSourceContract)
class SmartCoachRemoteDataSourceImpl
    implements SmartCoachRemoteDataSourceContract {
  SmartCoachRemoteDataSourceImpl();

  @override
  Stream<String> streamMessage({
    required String apiKey,
    required List<ChatMessageRecord> history,
    required String systemInstruction,
  }) async* {
    final model = GenerativeModel(
      model: 'gemini-2.5-flash',
      apiKey: apiKey,
      systemInstruction: Content.system(systemInstruction),
    );

    final contents = history.map((record) {
      if (record.isUser) {
        return Content.text(record.content);
      } else {
        return Content.model([TextPart(record.content)]);
      }
    }).toList();

    final stream = model.generateContentStream(contents);

    await for (final chunk in stream) {
      // Check for safety block on each chunk's candidates.
      final candidate = chunk.candidates.firstOrNull;
      if (candidate?.finishReason == FinishReason.safety) {
        throw const GeminiSafetyException();
      }

      // The SDK's `.text` getter throws GenerativeAIException on
      // FinishReason.safety / recitation — catch and rethrow as our
      // domain-specific exception.
      try {
        final text = chunk.text;
        if (text != null && text.isNotEmpty) {
          yield text;
        }
      } on GenerativeAIException catch (e) {
        if (e.message.contains('safety') || e.message.contains('SAFETY')) {
          throw const GeminiSafetyException();
        }
        rethrow;
      }
    }
  }
}
