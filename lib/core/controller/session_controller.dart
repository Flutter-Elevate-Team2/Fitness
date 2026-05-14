import 'dart:async';
import 'package:fitness_app/core/constants/api_constants.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:injectable/injectable.dart';

enum SessionEndReason { logout, guest, passwordChanged }

@singleton
class SessionController {
  final FlutterSecureStorage _secureStorage;

  SessionController(this._secureStorage);

  String? _token;

  String? get token => _token;

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

  Future<void> updateSessionAuth(String newToken) async {
    _token = newToken;
    await _secureStorage.write(key: ApiConstants.tokenKey, value: newToken);
    notifyLogin();
  }

  Future<void> expireSession() async {
    await _secureStorage.delete(key: ApiConstants.tokenKey);
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
