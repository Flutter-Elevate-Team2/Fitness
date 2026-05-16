import 'dart:async';
import 'dart:convert';
import 'package:fitness_app/core/constants/api_constants.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:injectable/injectable.dart';
import '../../Features/profile/domain/entities/user_entity.dart';

enum SessionEndReason { logout, guest, passwordChanged }

@singleton
class SessionController {
  final FlutterSecureStorage _secureStorage;

  static const String _userDataKey = 'cached_user_data';

  SessionController(this._secureStorage);

  String? _token;

  String? get token => _token;

  UserEntity? _user;

  UserEntity? get user => _user;

  bool get isLoggedIn => _token != null && _token!.isNotEmpty;

  final StreamController<void> _sessionExpiredController = StreamController<void>.broadcast();
  final StreamController<void> _loginController = StreamController<void>.broadcast();
  final StreamController<SessionEndReason> _logoutController = StreamController<SessionEndReason>.broadcast();

  final StreamController<UserEntity?> _userController = StreamController<UserEntity?>.broadcast();

  Stream<void> get onSessionExpired => _sessionExpiredController.stream;
  Stream<void> get onLogin => _loginController.stream;
  Stream<SessionEndReason> get onLogout => _logoutController.stream;

  Stream<UserEntity?> get onUserChanged => _userController.stream;

  Future<void> initSession() async {
    _token = await _secureStorage.read(key: ApiConstants.tokenKey);
    await _restoreUser();
  }

  void saveUser(UserEntity user) {
    _user = user;
    if (!_userController.isClosed) {
      _userController.add(_user);
    }
    _persistUser(user);
  }

  void updateUser(UserEntity updatedUser) {
    _user = updatedUser;
    if (!_userController.isClosed) {
      _userController.add(_user);
    }
    _persistUser(updatedUser);
  }

  Future<void> updateSessionAuth(String newToken) async {
    _token = newToken;
    await _secureStorage.write(key: ApiConstants.tokenKey, value: newToken);
    notifyLogin();
  }

  Future<void> expireSession() async {
    await _secureStorage.delete(key: ApiConstants.tokenKey);
    await _secureStorage.delete(key: _userDataKey);
    _user = null;
    if (!_userController.isClosed) _userController.add(null);
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
    if (!_userController.isClosed) _userController.add(null);
    await _secureStorage.delete(key: ApiConstants.tokenKey);
    await _secureStorage.delete(key: _userDataKey);
    if (!_logoutController.isClosed) {
      _logoutController.add(reason);
    }
  }

  Future<void> _persistUser(UserEntity user) async {
    final json = jsonEncode({
      'id': user.id,
      'firstName': user.firstName,
      'lastName': user.lastName,
      'email': user.email,
      'gender': user.gender,
      'age': user.age,
      'weight': user.weight,
      'height': user.height,
      'activityLevel': user.activityLevel,
      'goal': user.goal,
      'photo': user.photo,
    });
    await _secureStorage.write(key: _userDataKey, value: json);
  }

  Future<void> _restoreUser() async {
    final raw = await _secureStorage.read(key: _userDataKey);
    if (raw == null) return;
    try {
      final map = jsonDecode(raw) as Map<String, dynamic>;
      _user = UserEntity(
        id: map['id'] ?? '',
        firstName: map['firstName'] ?? '',
        lastName: map['lastName'] ?? '',
        email: map['email'] ?? '',
        gender: map['gender'] ?? '',
        age: map['age'] ?? 0,
        weight: map['weight'] ?? 0,
        height: map['height'] ?? 0,
        activityLevel: map['activityLevel'] ?? '',
        goal: map['goal'] ?? '',
        photo: map['photo'] ?? '',
      );
      if (!_userController.isClosed) {
        _userController.add(_user);
      }
    } catch (_) {
      // corrupted data — ignore
    }
  }

  @disposeMethod
  void dispose() {
    _sessionExpiredController.close();
    _loginController.close();
    _logoutController.close();
    _userController.close();
  }
}
