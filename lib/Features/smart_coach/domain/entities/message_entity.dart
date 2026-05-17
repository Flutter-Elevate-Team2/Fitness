import 'package:equatable/equatable.dart';

/// Represents a single chat message (user or AI) in a coaching session.
///
/// Pure Dart — no Flutter, Hive, or serialisation imports.
class MessageEntity extends Equatable {
  final String id;
  final String content;
  final bool isUser;
  final DateTime timestamp;

  /// `true` when the AI stream was interrupted before completion.
  final bool isPartial;

  const MessageEntity({
    required this.id,
    required this.content,
    required this.isUser,
    required this.timestamp,
    this.isPartial = false,
  });

  /// Creates a copy with selectively replaced fields.
  MessageEntity copyWith({
    String? id,
    String? content,
    bool? isUser,
    DateTime? timestamp,
    bool? isPartial,
  }) {
    return MessageEntity(
      id: id ?? this.id,
      content: content ?? this.content,
      isUser: isUser ?? this.isUser,
      timestamp: timestamp ?? this.timestamp,
      isPartial: isPartial ?? this.isPartial,
    );
  }

  @override
  List<Object?> get props => [id, content, isUser, timestamp, isPartial];
}
