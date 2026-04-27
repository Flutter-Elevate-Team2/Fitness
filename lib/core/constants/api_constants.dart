import 'package:flutter_dotenv/flutter_dotenv.dart';
// coverage:ignore-file

class ApiConstants {
  static String get apiBaseUrl => dotenv.env['BASE_URL'] ?? "";
  static String get mealsBaseUrl => dotenv.env['MEALS_BASE_URL'] ?? "";

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
  static const String defaultPassword = "Test@123";

  //================ Meals Endpoints ===========================
  static const String mealsCategories = "categories.php";
  static const String mealsByCategory = "filter.php";
  static const String mealDetails = "lookup.php";
  //================ Workouts Endpoints ===========================
  static const String difficultyLevelsByPrimeMover =
      'levels/difficulty-levels/by-prime-mover';
  static const String exercisesByMuscleDifficulty =
      'exercises/by-muscle-difficulty';

  //================ Workouts Endpoints ===========================
  static const String musclesRandom = 'muscles/random';
  static const String muscles = "muscles";
  static const String musclesByGroup = "musclesGroup/{id}";
  static const String levels = "levels";

  //================ Profile Endpoints ===========================
  static const String getUserProfile = "auth/profile-data";
  static const String editProfile = "/auth/editProfile";
  static const String logout = "/drivers/logout";

}
