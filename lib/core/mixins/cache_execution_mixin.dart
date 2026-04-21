import 'package:fitness_app/core/base_response/base_response.dart';
import 'package:fitness_app/core/errors/error_strings.dart';
import 'package:fitness_app/core/errors/handel_errors.dart';
import 'package:fitness_app/core/network/network_info.dart';
import 'package:flutter/foundation.dart';

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

    final cachedData = await fetchFromCache();
    final bool hasCache = !_isCacheEmpty(cachedData);

    if (hasCache) {

      if (isOnline) {

        unawaited(_syncWithServer(fetchFromRemote, saveToCache));
      }

      return SuccessResponse(data: cacheMapper(cachedData));

    } else {
      if (isOnline) {
        return _executeOnlineOnly(
          fetchFromRemote: fetchFromRemote,
          saveToCache: saveToCache,
          remoteMapper: remoteMapper,
        );
      } else {
        return const ErrorResponse(errorMessage: ErrorStrings.emptyCacheError);
      }
    }
  }



  /// دالة لجلب الداتا من السيرفر والانتظار (تُستخدم فقط لو الكاش فاضي)
  Future<BaseResponse<T>> _executeOnlineOnly<RemoteData, T>({
    required Future<RemoteData> Function() fetchFromRemote,
    required Future<void> Function(RemoteData data) saveToCache,
    required T Function(RemoteData data) remoteMapper,
  }) async {
    try {
      final remoteData = await fetchFromRemote();
      unawaited(_persistToCache(remoteData, saveToCache));
      return SuccessResponse(data: remoteMapper(remoteData));
    } catch (e) {
      return ErrorResponse(errorMessage: ErrorHandler.handleError(e));
    }
  }

  /// دالة تحديث الكاش في الخلفية (Silent Sync)
  Future<void> _syncWithServer<RemoteData>(
    Future<RemoteData> Function() fetchFromRemote,
    Future<void> Function(RemoteData data) saveToCache,
  ) async {
    try {
      final remoteData = await fetchFromRemote();
      await _persistToCache(remoteData, saveToCache);
      debugPrint('Background Sync Complete: Hive is updated with fresh data.');
    } catch (e) {
      debugPrint(' Background Sync Failed (Ignored): $e');
    }
  }

  Future<void> _persistToCache<RemoteData>(
    RemoteData data,
    Future<void> Function(RemoteData data) saveToCache,
  ) async {
    try {
      await saveToCache(data);
    } catch (e) {
      debugPrint(' Hive write failed: $e');
    }
  }

  bool _isCacheEmpty(dynamic data) {
    if (data == null) return true;
    if (data is List) return data.isEmpty;
    return false;
  }
}

void unawaited(Future<void> future) {}
