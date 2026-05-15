import 'package:flutter_dotenv/flutter_dotenv.dart';

class ApiConstants {
static String get apiBaseUrl => dotenv.env['BASE_URL'] ?? "";
  // ================= Auth Endpoints =================
  static const String login = "auth/signin";
  static const String signup = "auth/signup";
  static const String forgetPassword = "auth/forgotPassword";
  static const String resetPassword = "auth/resetPassword";
  static const String verifyResetCode = "auth/verifyResetCode";
  static const String changePassword = "auth/change-password";
  
  //================ Local Data Source ===========================
   static const String tokenKey = "token";
  static const String rememberMeKey = "is_remember_me";
  static const String onboardingKey = "onboarding_visited";


}
