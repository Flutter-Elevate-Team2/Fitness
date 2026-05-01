import 'package:fitness_app/Features/smart_coach/data/models/message_hive_model.dart';
import 'package:fitness_app/Features/smart_coach/domain/entities/message_entity.dart';

/// Maps between [MessageHiveModel] and [MessageEntity].
extension MessageHiveModelMapper on MessageHiveModel {
  MessageEntity toEntity() {
    return MessageEntity(
      id: id,
      content: content,
      isUser: isUser,
      timestamp: timestamp,
      isPartial: isPartial,
    );
  }
}

/// Maps a [MessageEntity] back to [MessageHiveModel] for persistence.
extension MessageEntityMapper on MessageEntity {
  MessageHiveModel toHiveModel() {
    return MessageHiveModel(
      id: id,
      content: content,
      isUser: isUser,
      timestamp: timestamp,
      isPartial: isPartial,
    );
  }
}
