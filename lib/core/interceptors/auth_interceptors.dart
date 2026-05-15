import 'package:dio/dio.dart';
import 'package:fitness_app/core/constants/api_constants.dart';
import 'package:fitness_app/core/controller/session_controller.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:get_it/get_it.dart';
import 'package:injectable/injectable.dart';

@injectable
class AuthInterceptor extends Interceptor {
  final FlutterSecureStorage _secureStorage;
  bool _isLoggingOut = false;

  AuthInterceptor(this._secureStorage);

  SessionController get _sessionController => GetIt.instance<SessionController>();

  final _publicPaths = [
    ApiConstants.login,
    ApiConstants.signup,
    ApiConstants.forgetPassword,
    ApiConstants.verifyResetCode,
    ApiConstants.resetPassword,
  ];

  @override
  void onRequest(RequestOptions options, RequestInterceptorHandler handler) async {
   bool isPublicPath = _publicPaths.any((path) => options.path.contains(path));
    if (!isPublicPath) {
      final token = await _secureStorage.read(key: ApiConstants.tokenKey);

      if (kDebugMode && token != null) {
       }

      if (token != null && token.isNotEmpty) {
        options.headers["Authorization"] = "Bearer $token";
      }
    }
    return handler.next(options);
  }

  @override
  void onError(DioException err, ErrorInterceptorHandler handler) async {
    if (err.response?.statusCode == 401 && !_isLoggingOut) {
      bool isPublicPath = _publicPaths.any((path) => err.requestOptions.path.endsWith(path));

      if (!isPublicPath) {
        _isLoggingOut = true;
        await _performLogout();
        _isLoggingOut = false;
      }
    }
    return handler.next(err);
  }

  Future<void> _performLogout() async {
    await _secureStorage.delete(key: ApiConstants.tokenKey);
    _sessionController.expireSession();
  }
}
