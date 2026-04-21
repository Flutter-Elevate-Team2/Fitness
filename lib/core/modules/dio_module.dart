import 'package:dio/dio.dart';
import 'package:fitness_app/core/constants/api_constants.dart';
import 'package:fitness_app/core/interceptors/auth_interceptors.dart';
import 'package:flutter/foundation.dart';
import 'package:injectable/injectable.dart';
import 'package:internet_connection_checker/internet_connection_checker.dart';
import 'package:pretty_dio_logger/pretty_dio_logger.dart';

// coverage:ignore-file

/// Provides core network-layer singletons to the DI container.
///
/// ⚠️  All dio_cache_interceptor / MemCacheStore / CacheOptions entries have
///     been intentionally removed. Dio is now a pure network transport —
///     caching is handled exclusively by the Hive-backed offline-first mixin,
///     preventing the double-caching bug that occurred when both layers ran.
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

  // ── Internet Connectivity ───────────────────────────────────────────────────
  /// Provides the [InternetConnectionChecker] instance that [NetworkInfoImpl]
  /// depends on. Registered as a singleton because the checker maintains an
  /// internal socket pool and is cheap to reuse.
  @singleton
  InternetConnectionChecker get internetConnectionChecker =>
      InternetConnectionChecker.createInstance();

  // ── Dio (pure transport — no caching) ──────────────────────────────────────
  @singleton
  Dio dio(
    AuthInterceptor authInterceptor,
    PrettyDioLogger dioLogger,
  ) {
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
}
