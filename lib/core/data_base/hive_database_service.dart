import 'package:hive_flutter/hive_flutter.dart';

/// Central Hive database service — singleton that provides a simple
/// init / openBox / close API for the entire app.
class HiveDatabaseService {
  HiveDatabaseService._();

  static HiveDatabaseService? _instance;

  static HiveDatabaseService get instance {
    assert(
      _instance != null,
      'HiveDatabaseService.init() must be called before accessing instance.',
    );
    return _instance!;
  }

  /// Initialise Hive (call once in `main()`).
  ///
  /// [registerAdapters] – optional callback to register TypeAdapters before
  /// any box is opened.
  static Future<void> init({
    void Function()? registerAdapters,
  }) async {
    if (_instance != null) return;

    await Hive.initFlutter();

    registerAdapters?.call();

    _instance = HiveDatabaseService._();
  }

  /// Open (or return an already-open) box of type [T].
  Future<Box<T>> openBox<T>(String name) => Hive.openBox<T>(name);

  /// Close every open box and reset the singleton.
  Future<void> close() async {
    await Hive.close();
    _instance = null;
  }
}
