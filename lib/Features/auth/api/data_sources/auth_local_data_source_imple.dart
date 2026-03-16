import 'package:fitness_app/Features/auth/data/data_sources/auth_local_data_source_contract.dart';
import 'package:fitness_app/core/constants/api_constants.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:injectable/injectable.dart';
import 'package:shared_preferences/shared_preferences.dart';

@Injectable(as: AuthLocalDataSourceContract)
class AuthLocalDataSourceImpl implements AuthLocalDataSourceContract {
  final SharedPreferences _prefs;
  final FlutterSecureStorage _secureStorage;

  static const String _tokenKey = ApiConstants.tokenKey;
  static const String _rememberMeKey = ApiConstants.rememberMeKey;

  AuthLocalDataSourceImpl(this._prefs, this._secureStorage);

  @override
  Future<void> saveToken(String token) async {
    await _secureStorage.write(key: _tokenKey, value: token);
  }

  @override
  Future<String?> getToken() async {
    return await _secureStorage.read(key: _tokenKey);
  }

  @override
  Future<void> saveRememberMe(bool value) async {
    await _prefs.setBool(_rememberMeKey, value);
  }

  @override
  Future<bool> getRememberMe() async {
    return _prefs.getBool(_rememberMeKey) ?? false;
  }

  @override
  Future<void> clearUserData() async {
    await _secureStorage.delete(key: _tokenKey);
    await _prefs.remove(_rememberMeKey);
  }
}
