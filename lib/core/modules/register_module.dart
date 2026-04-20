import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:injectable/injectable.dart';
import 'package:isar/isar.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../data_base/isar_database_service.dart';


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
  Isar get isar => IsarDatabaseService.instance.db;
}
