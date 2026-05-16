import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:injectable/injectable.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../data_base/hive_database_service.dart';
// coverage:ignore-file


@module
abstract class RegisterModule {

  @preResolve
  Future<SharedPreferences> get prefs => SharedPreferences.getInstance();


  @lazySingleton
  FlutterSecureStorage get secureStorage => const FlutterSecureStorage(
        aOptions: AndroidOptions(),
      );


  @singleton
  HiveDatabaseService get hiveDb => HiveDatabaseService.instance;
}
