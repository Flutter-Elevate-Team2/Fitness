import 'dart:async';
import 'dart:io';
import 'package:dio/dio.dart';
import 'package:fitness_app/core/errors/error_strings.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:hive/hive.dart';

class ErrorHandler {
  // === Helper Getter to access Localization Globally ===
  /// Main entry point.
  static String handleError(dynamic error) {
    debugPrint('🚨 ErrorHandler caught: ${error.runtimeType} -> $error');
    if (error is Error) {
      debugPrint('🚨 StackTrace: ${error.stackTrace}');
    }

    // -------------------------------------------------------------------------
    // SECTION 1: NETWORK & CONNECTION ERRORS
    // -------------------------------------------------------------------------
    if (error is DioException) {
      return _handleDioError(error);
    } else if (error is SocketException) {
      return ErrorStrings.noInternet;
    } else if (error is HandshakeException) {
      return ErrorStrings.badCertificate;
    } else if (error is TimeoutException) {
      return ErrorStrings.connectionTimeout;
    }
    // -------------------------------------------------------------------------
    // SECTION 2: DATA & LOGIC ERRORS
    // -------------------------------------------------------------------------
    else if (error is TypeError) {
      return ErrorStrings.parsingError;
    } else if (error is FormatException) {
      return ErrorStrings.formatException;
    }
    // -------------------------------------------------------------------------
    // SECTION 3: FIREBASE ERRORS
    // -------------------------------------------------------------------------
    // else if (error is FirebaseAuthException) {
    //   return _handleFirebaseAuthError(error);
    // } else if (error is FirebaseException) {
    //   return _handleFirebaseGeneralError(error);
    // }
    // -------------------------------------------------------------------------
    // SECTION 4: LOCAL STORAGE ERRORS
    // -------------------------------------------------------------------------
    else if (error is HiveError) {
      return ErrorStrings.hiveError;
    } else if (error is PlatformException) {
      return _handlePlatformError(error);
    }
    // -------------------------------------------------------------------------
    // SECTION 5: UNKNOWN / FALLBACK
    // -------------------------------------------------------------------------
    else {
      return ErrorStrings.unknownError;
    }
  }

  // ===========================================================================
  // HELPER METHODS
  // ===========================================================================

  static String _handleDioError(DioException error) {
    return switch (error.type) {
      DioExceptionType.connectionTimeout => ErrorStrings.connectionTimeout,
      DioExceptionType.sendTimeout => ErrorStrings.sendTimeout,
      DioExceptionType.receiveTimeout => ErrorStrings.receiveTimeout,
      DioExceptionType.badResponse => _handleBadResponse(error),
      DioExceptionType.cancel => ErrorStrings.requestCancelled,
      DioExceptionType.connectionError => ErrorStrings.connectionError,
      DioExceptionType.badCertificate => ErrorStrings.badCertificate,
      DioExceptionType.unknown => _handleUnknownError(error),
    };
  }

  static String _handleBadResponse(DioException error) {
    final statusCode = error.response?.statusCode;
    return switch (statusCode) {
      400 => _extractErrorMessage(error, ErrorStrings.badRequest),
      401 => _extractErrorMessage(error, ErrorStrings.unauthorized),
      403 => ErrorStrings.forbidden,
      404 => _extractErrorMessage(error, ErrorStrings.notFound),
      409 => _extractErrorMessage(error, ErrorStrings.conflict),

      500 => ErrorStrings.internalServerError,
      503 => ErrorStrings.serviceUnavailable,

      _ => _extractErrorMessage(error, ErrorStrings.defaultError),
    };
  }

  static String _extractErrorMessage(
    DioException error,
    String defaultMessage,
  ) {
    try {
      final data = error.response?.data;
      if (data is Map<String, dynamic>) {
        return data['message']?.toString() ??
            data['error']?.toString() ??
            defaultMessage;
      }
      return defaultMessage;
    } catch (e) {
      return defaultMessage;
    }
  }

  static String _handleUnknownError(DioException error) {
    if (error.error is SocketException) {
      return ErrorStrings.noInternet;
    }
    if (error.error is HandshakeException) {
      return ErrorStrings.badCertificate;
    }

    final message = error.message ?? '';
    if (message.contains('SocketException')) {
      return ErrorStrings.noInternet;
    }
    return ErrorStrings.networkError;
  }

  // static String _handleFirebaseAuthError(FirebaseAuthException error) {
  //   switch (error.code) {
  //     case 'user-not-found':
  //       return ErrorStrings.firebaseUserNotFound;
  //     case 'wrong-password':
  //       return ErrorStrings.firebaseWrongPassword;
  //     case 'email-already-in-use':
  //       return ErrorStrings.firebaseEmailInUse;
  //     case 'invalid-email':
  //       return ErrorStrings.firebaseInvalidEmail;
  //     case 'weak-password':
  //       return ErrorStrings.firebaseWeakPassword;
  //     case 'user-disabled':
  //       return ErrorStrings.firebaseAccountDisabled;
  //     case 'too-many-requests':
  //       return ErrorStrings.firebaseTooManyRequests;
  //     case 'network-request-failed':
  //       return ErrorStrings.noInternet;
  //     default:
  //       return error.message ?? ErrorStrings.firebaseAuthUnknown;
  //   }
  // }

  // static String _handleFirebaseGeneralError(FirebaseException error) {
  //   switch (error.code) {
  //     case 'permission-denied':
  //       return ErrorStrings.firebasePermissionDenied;
  //     case 'unavailable':
  //       return ErrorStrings.firebaseUnavailable;
  //     case 'network-request-failed':
  //       return ErrorStrings.noInternet;
  //     default:
  //       return ErrorStrings.unknownError;
  //   }
  // }

  static String _handlePlatformError(PlatformException error) {
    if (error.code == 'network_error') {
      return ErrorStrings.noInternet;
    }
    return ErrorStrings.platformError;
  }
}
