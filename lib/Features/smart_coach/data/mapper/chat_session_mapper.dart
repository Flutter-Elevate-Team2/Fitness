import 'package:fitness_app/Features/smart_coach/data/mapper/message_mapper.dart';
import 'package:fitness_app/Features/smart_coach/data/models/chat_session_hive_model.dart';
import 'package:fitness_app/Features/smart_coach/data/models/message_hive_model.dart';
import 'package:fitness_app/Features/smart_coach/domain/entities/chat_session_entity.dart';
import 'package:fitness_app/Features/smart_coach/domain/entities/message_entity.dart';

/// Maps between [ChatSessionHiveModel] and [ChatSessionEntity].
extension ChatSessionHiveModelMapper on ChatSessionHiveModel {
  ChatSessionEntity toEntity() {
    return ChatSessionEntity(
      id: id,
      title: title,
      messages: messages.map((m) => m.toEntity()).toList(),
      createdAt: createdAt,
      updatedAt: updatedAt,
    );
  }
}

/// Maps a [ChatSessionEntity] back to [ChatSessionHiveModel] for persistence.
extension ChatSessionEntityMapper on ChatSessionEntity {
  ChatSessionHiveModel toHiveModel() {
    return ChatSessionHiveModel(
      id: id,
      title: title,
      messages: messages.map((m) => m.toHiveModel()).toList(),
      createdAt: createdAt,
      updatedAt: updatedAt,
    );
  }
}

/// Convenience mapper for nullable lists returned from Hive.
extension ChatSessionHiveModelListMapper on List<ChatSessionHiveModel>? {
  List<ChatSessionEntity> toEntityList() {
    return this?.map((model) => model.toEntity()).toList() ?? [];
  }
}
