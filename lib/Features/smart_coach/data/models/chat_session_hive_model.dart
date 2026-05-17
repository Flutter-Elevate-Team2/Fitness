import 'package:fitness_app/Features/smart_coach/data/models/message_hive_model.dart';
import 'package:fitness_app/core/data_base/constants.dart';
import 'package:hive_ce/hive.dart';

part 'chat_session_hive_model.g.dart';

/// Hive-persisted model for a coaching chat session.
///
/// Stored as a top-level entry in the Smart Coach sessions box.
/// Contains a nested [List<MessageHiveModel>] — this works safely
/// because [MessageHiveModel] does NOT extend [HiveObject].
@HiveType(typeId: HiveTypes.chatSession)
class ChatSessionHiveModel {
  @HiveField(0)
  final String id;

  @HiveField(1)
  String title;

  @HiveField(2)
  List<MessageHiveModel> messages;

  /// Written once at creation — never updated.
  @HiveField(3)
  final DateTime createdAt;

  /// Updated on every new message — used for sorting.
  @HiveField(4)
  DateTime updatedAt;

  ChatSessionHiveModel({
    required this.id,
    required this.title,
    required this.messages,
    required this.createdAt,
    required this.updatedAt,
  });
}
