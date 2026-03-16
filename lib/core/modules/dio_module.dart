import 'package:dio/dio.dart';
import 'package:dio_cache_interceptor/dio_cache_interceptor.dart';
import 'package:fitness_app/core/constants/api_constants.dart';
import 'package:fitness_app/core/interceptors/auth_interceptors.dart';
import 'package:flutter/foundation.dart';
import 'package:injectable/injectable.dart';
import 'package:pretty_dio_logger/pretty_dio_logger.dart';
@module
abstract class DioModule {
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
  MemCacheStore get memCacheStore => MemCacheStore();

  @singleton
  CacheOptions cacheOptions(MemCacheStore memCacheStore) {
    return CacheOptions(
      store: memCacheStore,
      policy: CachePolicy.request,
      priority: CachePriority.normal,
      maxStale: const Duration(days: 7),
    );
  }

  @singleton
  Dio dio(
    AuthInterceptor authInterceptor,
    PrettyDioLogger dioLogger,
    CacheOptions cacheOptions,
  ) {
    final dio = Dio(
      BaseOptions(
        baseUrl: ApiConstants.apiBaseUrl,
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
        },
        connectTimeout: const Duration(seconds: 30),
        receiveTimeout: const Duration(seconds: 30),
      ),
    );

    dio.interceptors.addAll([
      authInterceptor,
      DioCacheInterceptor(options: cacheOptions),
    ]);

    if (kDebugMode) {
      dio.interceptors.add(dioLogger);
    }
    return dio;
  }
}
