import 'package:fitness_app/core/base_response/base_response.dart';
import 'package:fitness_app/core/errors/error_strings.dart';
import 'package:fitness_app/core/errors/handel_errors.dart';
import 'package:fitness_app/core/network/network_info.dart';
import 'package:flutter/foundation.dart';
import 'package:isar/isar.dart';


mixin CacheExecutionMixin {
  NetworkInfo get networkInfo;


  Future<BaseResponse<T>> executeWithCache<RemoteData, LocalData, T>({
    required Future<RemoteData> Function() fetchFromRemote,
    required Future<LocalData> Function() fetchFromCache,
    required Future<void> Function(RemoteData data) saveToCache,
    required T Function(RemoteData data) remoteMapper,
    required T Function(LocalData data) cacheMapper,
  }) async {
    final isOnline = await networkInfo.isConnected;

    if (isOnline) {
      return _executeOnline(
        fetchFromRemote: fetchFromRemote,
        fetchFromCache: fetchFromCache,
        saveToCache: saveToCache,
        remoteMapper: remoteMapper,
        cacheMapper: cacheMapper,
      );
    } else {
      return _executeOffline(
        fetchFromCache: fetchFromCache,
        cacheMapper: cacheMapper,
      );
    }
  }


  Future<BaseResponse<T>> _executeOnline<RemoteData, LocalData, T>({
    required Future<RemoteData> Function() fetchFromRemote,
    required Future<LocalData> Function() fetchFromCache,
    required Future<void> Function(RemoteData data) saveToCache,
    required T Function(RemoteData data) remoteMapper,
    required T Function(LocalData data) cacheMapper,
  }) async {
    try {
      // 1. Fetch from network
      final remoteData = await fetchFromRemote();

      // 2. Persist to Isar in the background — never block the UI on a write
      unawaited(_persistToCache(remoteData, saveToCache));

      // 3. Return fresh data
      return SuccessResponse(data: remoteMapper(remoteData));
    } catch (e) {
      // 4. Remote failed → try stale cache as fallback
      debugPrint(
        '⚠️  CacheExecutionMixin: remote failed, falling back to cache. Error: $e',
      );
      return _executeOffline(
        fetchFromCache: fetchFromCache,
        cacheMapper: cacheMapper,
      );
    }
  }

  Future<BaseResponse<T>> _executeOffline<LocalData, T>({
    required Future<LocalData> Function() fetchFromCache,
    required T Function(LocalData data) cacheMapper,
  }) async {
    try {
      final cachedData = await fetchFromCache();

      if (_isCacheEmpty(cachedData)) {
        return const ErrorResponse(errorMessage: ErrorStrings.emptyCacheError);
      }

      return SuccessResponse(data: cacheMapper(cachedData));
    } on IsarError catch (e) {
      debugPrint('🚨 CacheExecutionMixin: IsarError reading cache: $e');
      return const ErrorResponse(errorMessage: ErrorStrings.isarError);
    } catch (e) {
      final message = ErrorHandler.handleError(e);
      return ErrorResponse(errorMessage: message);
    }
  }
  Future<void> _persistToCache<RemoteData>(
    RemoteData data,
    Future<void> Function(RemoteData data) saveToCache,
  ) async {
    try {
      await saveToCache(data);
    } on IsarError catch (e) {
      debugPrint('⚠️  CacheExecutionMixin: Isar write failed (non-fatal): $e');
    } catch (e) {
      debugPrint('⚠️  CacheExecutionMixin: cache write failed (non-fatal): $e');
    }
  }


  bool _isCacheEmpty(dynamic data) {
    if (data == null) return true;
    if (data is List) return data.isEmpty;
    return false;
  }
}


void unawaited(Future<void> future) {
}
