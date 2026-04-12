import 'package:fitness_app/core/app_router/app_router.dart';
import 'package:fitness_app/core/constants/api_constants.dart';
import 'package:fitness_app/core/di/di.dart';
import 'package:fitness_app/core/extension/context_extention.dart';
import 'package:fitness_app/core/theming/app_theming.dart';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class SessionExpiredHandler {
  static bool _isShowing = false;

  static void handle() {
    if (_isShowing) return;

    final context = AppRouter.rootNavigatorKey.currentState?.context;
    if (context == null || !context.mounted) return;

    _isShowing = true;

    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (_) => AlertDialog(
        title: Text(context.l10n.sessionExpiredTitle),
        content: Text(context.l10n.sessionExpiredMessage),
        actions: [
          TextButton(
            onPressed: _onLoginPressed,
            child: Text(
              context.l10n.loginTitle,
              style: TextStyle(color: AppTheme.darkTheme.primaryColor),
            ),
          ),
        ],
      ),
    ).then((_) => _isShowing = false);
  }

  static Future<void> _onLoginPressed() async {
    final secureStorage = getIt<FlutterSecureStorage>();
    await secureStorage.delete(key: ApiConstants.tokenKey);
    AppRouter.router.go(Routes.loginPath);
  }
}
