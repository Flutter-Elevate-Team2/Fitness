import 'dart:math';

/// Unified ID generator for the Smart Coach feature.
///
/// Used by both the Repository (session IDs) and ViewModel (message IDs)
/// to keep generation logic consistent and DRY.
class SmartCoachIdGenerator {
  SmartCoachIdGenerator._();

  static final _random = Random();

  /// Generates a locally-unique ID using timestamp + random suffix.
  ///
  /// No external UUID package needed since these IDs are local-only
  /// (never synced to a server).
  static String generate({String prefix = ''}) {
    final now = DateTime.now().microsecondsSinceEpoch;
    final suffix = _random.nextInt(999999).toString().padLeft(6, '0');
    return prefix.isEmpty ? '${now}_$suffix' : '${prefix}_${now}_$suffix';
  }

  /// Shorthand for session IDs.
  static String sessionId() => generate(prefix: 'session');

  /// Shorthand for message IDs.
  static String messageId() => generate(prefix: 'msg');
}
