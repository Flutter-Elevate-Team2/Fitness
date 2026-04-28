import 'package:fitness_app/core/data_base/constants.dart';
import 'package:hive_ce/hive.dart';

part 'message_hive_model.g.dart';

/// Hive-persisted model for a single chat message.
///
/// **Does NOT extend [HiveObject]** — this is intentional.
/// Because [MessageHiveModel] is stored as a nested list inside
/// [ChatSessionHiveModel], extending [HiveObject] would cause
/// Hive serialisation issues with nested object lists.
@HiveType(typeId: HiveTypes.chatMessage)
class MessageHiveModel {
  @HiveField(0)
  final String id;

  @HiveField(1)
  final String content;

  @HiveField(2)
  final bool isUser;

  @HiveField(3)
  final DateTime timestamp;

  @HiveField(4)
  final bool isPartial;

  MessageHiveModel({
    required this.id,
    required this.content,
    required this.isUser,
    required this.timestamp,
    this.isPartial = false,
  });
}
