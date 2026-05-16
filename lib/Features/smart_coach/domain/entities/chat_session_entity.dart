import 'package:equatable/equatable.dart';
import 'package:fitness_app/Features/smart_coach/domain/entities/message_entity.dart';

/// Represents a single coaching conversation session.
///
/// Pure Dart — no Flutter, Hive, or serialisation imports.
class ChatSessionEntity extends Equatable {
  final String id;
  final String title;
  final List<MessageEntity> messages;

  /// Written once at creation — never updated.
  final DateTime createdAt;

  /// Updated on every new message — used for sorting.
  final DateTime updatedAt;

  const ChatSessionEntity({
    required this.id,
    required this.title,
    required this.messages,
    required this.createdAt,
    required this.updatedAt,
  });

  @override
  List<Object?> get props => [id, title, messages, createdAt, updatedAt];
}
