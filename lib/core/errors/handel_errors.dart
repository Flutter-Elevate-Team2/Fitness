import 'dart:async';
import 'dart:io';
import 'package:dio/dio.dart';
import 'package:fitness_app/core/errors/error_strings.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:hive_ce/hive.dart';

class ErrorHandler {
  /// Main entry point.
  static String handleError(dynamic error) {
    debugPrint('🚨 ErrorHandler caught: ${error.runtimeType} -> $error');
    if (error is Error) {
      debugPrint('🚨 StackTrace: ${error.stackTrace}');
    }


    if (error is DioException) {
      return _handleDioError(error);
    } else if (error is SocketException) {
      return ErrorStrings.noInternet;
    } else if (error is HandshakeException) {
      return ErrorStrings.badCertificate;
    } else if (error is TimeoutException) {
      return ErrorStrings.connectionTimeout;
    }

    else if (error is TypeError) {
      return ErrorStrings.parsingError;
    } else if (error is FormatException) {
      return ErrorStrings.formatException;
    }


    else if (error is HiveError) {
      return ErrorStrings.hiveError;
    }

    else if (error is String &&
        error == ErrorStrings.emptyCacheError) {
      return ErrorStrings.emptyCacheError;
    } else if (error is PlatformException) {
      return _handlePlatformError(error);
    }
    else if (error.toString().contains('SocketException') || 
             error.toString().contains('ClientException') ||
             error.toString().contains('Failed host lookup')) {
      return ErrorStrings.noInternet;
    }

    else {
      return ErrorStrings.unknownError;
    }
  }



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



  static String _handlePlatformError(PlatformException error) {
    if (error.code == 'network_error') {
      return ErrorStrings.noInternet;
    }
    return ErrorStrings.platformError;
  }
}
