 import 'package:fitness_app/Features/auth/presentation/forget_password/views/screens/forget_password_screen.dart';
import 'package:fitness_app/Features/auth/domain/use_cases/login_use_cases/valid_token_use_case.dart';
import 'package:fitness_app/Features/auth/presentation/login/views/screens/login_screen.dart';
import 'package:fitness_app/Features/onboarding/presentation/views/screens/onboarding_screen.dart';
import 'package:fitness_app/core/constants/api_constants.dart';
import 'package:fitness_app/core/di/di.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:shared_preferences/shared_preferences.dart';

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
    initialLocation: Routes.homePath,
    redirect: (context, state) async {
      // جلب الـ UseCase من GetIt
      final hasValidTokenUseCase = getIt<HasValidTokenUseCase>();
      final prefs = getIt<SharedPreferences>();

      // التحقق من الحالات
      final bool isLoggedIn = await hasValidTokenUseCase.call();
      final bool hasVisitedOnboarding =
          prefs.getBool(ApiConstants.onboardingKey) ?? false;

      // تحديد هل المسار الحالي هو مسار مصادقة (Auth Route)
      final isAuthRoute =
          state.matchedLocation == Routes.loginPath ||
          state.matchedLocation == Routes.signupPath ||
          state.matchedLocation == Routes.forgetPasswordPath ||
          state.matchedLocation == Routes.verifyCodePath ||
          state.matchedLocation == Routes.resetPasswordPath;

      // 2. منطق التوجيه (The Logic)

      // أول مرة يفتح التطبيق وما شافش الـ Onboarding
      if (!hasVisitedOnboarding &&
          state.matchedLocation != Routes.onBoardingPath) {
        return Routes.onBoardingPath;
      }

      // لو شاف الـ Onboarding وبيحاول يرجعله.. وديه للوجن
      if (hasVisitedOnboarding &&
          state.matchedLocation == Routes.onBoardingPath) {
        return Routes.loginPath;
      }

      // لو مش مسجل دخول وبيحاول يدخل صفحة محمية (زي الهوم)
      if (!isLoggedIn &&
          !isAuthRoute &&
          state.matchedLocation != Routes.onBoardingPath) {
        return Routes.loginPath;
      }

      // لو مسجل دخول وبيحاول يروح لصفحات اللوجن.. وديه للهوم
      if (isLoggedIn && isAuthRoute) {
        return Routes.homePath;
      }

      return null; // لا يوجد توجيه، استمر في المسار الحالي
    },
    routes: [
      GoRoute(
        path: Routes.onBoardingPath,
        name: Routes.onBoardingName,
        builder: (context, state) => OnboardingScreen(),
      ),
      GoRoute(
        path: Routes.loginPath,
        name: Routes.loginName,
        builder: (context, state) => LoginScreen(),
      ),
      GoRoute(
        path: Routes.signupPath,
        name: Routes.signupName,
        builder: (context, state) => Container(),
      ),
      GoRoute(
        path: Routes.forgetPasswordPath,
        name: Routes.forgetPasswordName,
        builder: (context, state) => ForgetPasswordScreen(),
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
