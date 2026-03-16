// coverage:ignore-file

class ErrorStrings {
  ErrorStrings._(); // Private constructor to prevent instantiation

  // --- Network Errors ---
  static const String noInternet = "NO_INTERNET";
  static const String connectionTimeout = "CONNECTION_TIMEOUT";
  static const String sendTimeout = "SEND_TIMEOUT";
  static const String receiveTimeout = "RECEIVE_TIMEOUT";
  static const String requestCancelled = "REQUEST_CANCELLED";
  static const String badCertificate = "BAD_CERTIFICATE";
  static const String connectionError = "CONNECTION_ERROR";
  static const String networkError = "NETWORK_ERROR";

  // --- HTTP Status Codes ---
  static const String badRequest = "BAD_REQUEST";
  static const String unauthorized = "UNAUTHORIZED";
  static const String forbidden = "FORBIDDEN";
  static const String notFound = "NOT_FOUND";
  static const String conflict = "CONFLICT";
  static const String internalServerError = "INTERNAL_SERVER_ERROR";
  static const String serviceUnavailable = "SERVICE_UNAVAILABLE";

  // --- Data & Parsing ---
  static const String parsingError = "PARSING_ERROR";
  static const String formatException = "FORMAT_EXCEPTION";

  // --- Firebase Auth ---
  static const String firebaseUserNotFound = "FIREBASE_USER_NOT_FOUND";
  static const String firebaseWrongPassword = "FIREBASE_WRONG_PASSWORD";
  static const String firebaseEmailInUse = "FIREBASE_EMAIL_IN_USE";
  static const String firebaseInvalidEmail = "FIREBASE_INVALID_EMAIL";
  static const String firebaseWeakPassword = "FIREBASE_WEAK_PASSWORD";
  static const String firebaseAccountDisabled = "FIREBASE_ACCOUNT_DISABLED";
  static const String firebaseTooManyRequests = "FIREBASE_TOO_MANY_REQUESTS";
  static const String firebaseAuthUnknown = "FIREBASE_AUTH_UNKNOWN";

  // --- Firebase General ---
  static const String firebasePermissionDenied = "FIREBASE_PERMISSION_DENIED";
  static const String firebaseUnavailable = "FIREBASE_UNAVAILABLE";

  // --- Local Storage ---
  static const String hiveError = "HIVE_ERROR";
  static const String platformError = "PLATFORM_ERROR";

  // --- Fallback ---
  static const String defaultError = "DEFAULT_ERROR";
  static const String unknownError = "UNKNOWN_ERROR";
}
