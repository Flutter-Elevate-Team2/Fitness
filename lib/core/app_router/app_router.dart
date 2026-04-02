import 'package:fitness_app/Features/auth/presentation/sign_up/views/screens/signup_screen.dart';
import 'package:fitness_app/core/constants/api_constants.dart';
import 'package:fitness_app/core/di/di.dart';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:go_router/go_router.dart';

class Routes {
  static const String onBoardingPath = '/onBoarding';
  static const String onBoardingName = 'onBoarding';

  static const String loginPath = '/login';
  static const String loginName = 'login';

  static const String signupPath = '/signup';
  static const String signupName = 'signup';

  static const String forgetPasswordPath = '/forgetpassword';
  static const String forgetPasswordName = 'forgetPassword';

  static const String verifyCodePath = '/verifycode';
  static const String verifyCodeName = 'verifyCode';

  static const String resetPasswordPath = '/resetpassword';
  static const String resetPasswordName = 'resetPassword';

  static const String homePath = '/home';
  static const String homeName = 'home';
}

class AppRouter {
  static final GlobalKey<NavigatorState> rootNavigatorKey =
      GlobalKey<NavigatorState>();

  static final GoRouter router = GoRouter(
    navigatorKey: rootNavigatorKey,
    initialLocation: Routes.signupPath,
    redirect: (context, state) async {
      final secureStorage = getIt<FlutterSecureStorage>();
      final token = await secureStorage.read(key: ApiConstants.tokenKey);
      final isLoggedIn = token != null && token.isNotEmpty;

      final isAuthRoute = state.matchedLocation == Routes.loginPath ||
          state.matchedLocation == Routes.signupPath ||
          state.matchedLocation == Routes.onBoardingPath ||
          state.matchedLocation == Routes.forgetPasswordPath ||
          state.matchedLocation == Routes.verifyCodePath ||
          state.matchedLocation == Routes.resetPasswordPath;

      if (!isLoggedIn && !isAuthRoute) {
        return Routes.loginPath;
      }

      if (isLoggedIn && isAuthRoute) {
        return Routes.homePath;
      }

      return null;
    },
    routes: [
      GoRoute(
        path: Routes.onBoardingPath,
        name: Routes.onBoardingName,
        builder: (context, state) => Container(),
      ),
      GoRoute(
        path: Routes.loginPath,
        name: Routes.loginName,
        builder: (context, state) => Container(),
      ),
      GoRoute(
        path: Routes.signupPath,
        name: Routes.signupName,
        builder: (context, state) => const SignupScreen(),
      ),
      GoRoute(
        path: Routes.forgetPasswordPath,
        name: Routes.forgetPasswordName,
        builder: (context, state) => Container(),
      ),
      GoRoute(
        path: Routes.verifyCodePath,
        name: Routes.verifyCodeName,
        builder: (context, state) => Container(),
      ),
      GoRoute(
        path: Routes.resetPasswordPath,
        name: Routes.resetPasswordName,
        builder: (context, state) => Container(),
      ),
      GoRoute(
        path: Routes.homePath,
        name: Routes.homeName,
        builder: (context, state) => Container(),
      ),

    ],
  );
}
