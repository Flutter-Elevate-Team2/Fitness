import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:injectable/injectable.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../data_base/hive_database_service.dart';


@module
abstract class RegisterModule {
  // ── Shared Preferences ──────────────────────────────────────────────────────
  @preResolve
  Future<SharedPreferences> get prefs => SharedPreferences.getInstance();

  // ── Secure Storage ─────────────────────────────────────────────────────────
  @lazySingleton
  FlutterSecureStorage get secureStorage => const FlutterSecureStorage(
        aOptions: AndroidOptions(),
      );


  @singleton
  HiveDatabaseService get hiveDb => HiveDatabaseService.instance;
}
