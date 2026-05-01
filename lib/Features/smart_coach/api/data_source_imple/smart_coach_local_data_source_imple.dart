import 'package:fitness_app/Features/smart_coach/data/data_source_contract/smart_coach_local_data_source_contract.dart';
import 'package:fitness_app/Features/smart_coach/data/models/chat_session_hive_model.dart';
import 'package:fitness_app/Features/smart_coach/data/models/message_hive_model.dart';
import 'package:fitness_app/Features/smart_coach/data/models/smart_coach_hive_constants.dart';
import 'package:fitness_app/core/data_base/hive_database_service.dart';
import 'package:hive_ce/hive.dart';
import 'package:injectable/injectable.dart';

/// Hive-backed implementation of [SmartCoachLocalDataSourceContract].
///
/// All box access goes through [HiveDatabaseService.instance.openBox] —
/// never calls [Hive.openBox] directly.
@Injectable(as: SmartCoachLocalDataSourceContract)
class SmartCoachLocalDataSourceImpl
    implements SmartCoachLocalDataSourceContract {
  final HiveDatabaseService _hiveService;

  SmartCoachLocalDataSourceImpl(this._hiveService);

  Future<Box<ChatSessionHiveModel>> get _box =>
      _hiveService.openBox<ChatSessionHiveModel>(
        SmartCoachHiveConstants.sessionsBoxName,
      );

  @override
  Future<void> saveSession(ChatSessionHiveModel session) async {
    final box = await _box;
    await box.put(session.id, session);
  }

  @override
  Future<void> saveMessage(String sessionId, MessageHiveModel message) async {
    final box = await _box;
    final session = box.get(sessionId);
    if (session == null) return;

    session.messages.add(message);
    await box.put(sessionId, session);
  }

  @override
  Future<void> updateSessionTimestamp(
    String sessionId,
    DateTime updatedAt,
  ) async {
    final box = await _box;
    final session = box.get(sessionId);
    if (session == null) return;

    session.updatedAt = updatedAt;
    await box.put(sessionId, session);
  }

  @override
  Future<void> updateSessionTitle(String sessionId, String title) async {
    final box = await _box;
    final session = box.get(sessionId);
    if (session == null) return;

    session.title = title;
    await box.put(sessionId, session);
  }

  @override
  Future<List<ChatSessionHiveModel>> getAllSessions() async {
    final box = await _box;
    return box.values.toList();
  }

  @override
  Future<ChatSessionHiveModel?> getSession(String sessionId) async {
    final box = await _box;
    return box.get(sessionId);
  }

  @override
  Future<void> deleteSession(String sessionId) async {
    final box = await _box;
    await box.delete(sessionId);
  }

  @override
  Future<void> deleteMessage(String sessionId, String messageId) async {
    final box = await _box;
    final session = box.get(sessionId);
    if (session == null) return;

    session.messages.removeWhere((m) => m.id == messageId);
    await box.put(sessionId, session);
  }
}
