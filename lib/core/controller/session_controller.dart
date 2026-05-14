import 'dart:async';
import 'package:fitness_app/core/constants/api_constants.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:injectable/injectable.dart';

import '../../Features/profile/domain/entities/user_entity.dart';

enum SessionEndReason { logout, guest, passwordChanged }

@singleton
class SessionController {
  final FlutterSecureStorage _secureStorage;

  SessionController(this._secureStorage);

  String? _token;

  String? get token => _token;

  UserEntity? _user;

  UserEntity? get user => _user;

  bool get isLoggedIn => _token != null && _token!.isNotEmpty;

  final StreamController<void> _sessionExpiredController = StreamController<void>.broadcast();
  final StreamController<void> _loginController = StreamController<void>.broadcast();
  final StreamController<SessionEndReason> _logoutController = StreamController<SessionEndReason>.broadcast();

  Stream<void> get onSessionExpired => _sessionExpiredController.stream;
  Stream<void> get onLogin => _loginController.stream;
  Stream<SessionEndReason> get onLogout => _logoutController.stream;

  Future<void> initSession() async {
    _token = await _secureStorage.read(key: ApiConstants.tokenKey);
  }

  void saveUser(UserEntity user) {
    _user = user;
  }

  void updateUser(UserEntity updatedUser) {
    _user = updatedUser;
  }

  Future<void> updateSessionAuth(String newToken) async {
    _token = newToken;
    await _secureStorage.write(key: ApiConstants.tokenKey, value: newToken);
    notifyLogin();
  }

  Future<void> expireSession() async {
    await _secureStorage.delete(key: ApiConstants.tokenKey);
    _user = null;
    if (!_sessionExpiredController.isClosed) {
      _sessionExpiredController.add(null);
    }
  }

  void notifyLogin() {
    if (!_loginController.isClosed) {
      _loginController.add(null);
    }
  }

  Future<void> notifyLogout(SessionEndReason reason) async {
    _token = null;
    _user = null;
    await _secureStorage.delete(key: ApiConstants.tokenKey);
    if (!_logoutController.isClosed) {
      _logoutController.add(reason);
    }
  }

  @disposeMethod
  void dispose() {
    _sessionExpiredController.close();
    _loginController.close();
    _logoutController.close();
  }
}
