import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:dio/dio.dart';
import 'package:fitness_app/core/constants/api_constants.dart';
import 'package:fitness_app/core/interceptors/auth_interceptors.dart';
import 'package:flutter/foundation.dart';
import 'package:injectable/injectable.dart';
import 'package:pretty_dio_logger/pretty_dio_logger.dart';

// coverage:ignore-file

@module
abstract class DioModule {
  // ── Logger ──────────────────────────────────────────────────────────────────
  @singleton
  PrettyDioLogger get prettyDioLogger {
    return PrettyDioLogger(
      requestHeader: true,
      requestBody: true,
      responseBody: true,
      responseHeader: false,
      error: true,
      compact: true,
      maxWidth: 90,
    );
  }

  @singleton
  Connectivity get connectivity => Connectivity();

  @Named("PrimaryDio")
  @singleton
  Dio dio(AuthInterceptor authInterceptor, PrettyDioLogger dioLogger) {
    final dio = Dio(
      BaseOptions(
        baseUrl: ApiConstants.apiBaseUrl,
        headers: const {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
        },
        connectTimeout: const Duration(seconds: 30),
        receiveTimeout: const Duration(seconds: 30),
        sendTimeout: const Duration(seconds: 30),
      ),
    );

    dio.interceptors.add(authInterceptor);

    if (kDebugMode) {
      dio.interceptors.add(dioLogger);
    }

    return dio;
  }

  @Named("MealsDio")
  @singleton
  Dio dioMeals(PrettyDioLogger dioLogger) {
    final dio = Dio(
      BaseOptions(
        baseUrl: ApiConstants.mealsBaseUrl,
        connectTimeout: const Duration(seconds: 30),
      ),
    );

    if (kDebugMode) {
      dio.interceptors.add(dioLogger);
    }

    return dio;
  }
}
