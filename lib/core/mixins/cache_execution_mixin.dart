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
    required Future<bool> Function() isExpired,
  }) async {
    final isOnline = await networkInfo.isConnected;
    final cachedData = await fetchFromCache();

    final bool hasCache = !_isCacheEmpty(cachedData);
    final bool expired = await isExpired();

    debugPrint('--- Cache TTL Logs ---');
    debugPrint('Is Online: $isOnline');
    debugPrint('Has Cache: $hasCache');
    debugPrint('Is Expired: $expired');
    debugPrint('----------------------');

    if (hasCache && !expired) {
      debugPrint("📦 Cache is VALID. Returning local data ONLY (No API Call).");
      return SuccessResponse(data: cacheMapper(cachedData));
    }

    if (isOnline) {
      debugPrint(expired && hasCache
          ? "⏰ Cache EXPIRED. Fetching fresh data from API..."
          : "☁️ No cache. Fetching from API...");

      try {
        final remoteData = await fetchFromRemote();
        await saveToCache(remoteData);
        return SuccessResponse(data: remoteMapper(remoteData));
      } catch (e) {
        if (hasCache) {
          debugPrint("⚠️ API Failed, but old cache exists. Returning stale cache as fallback.");
          return SuccessResponse(data: cacheMapper(cachedData));
        }
        return ErrorResponse(errorMessage: ErrorHandler.handleError(e));
      }
    }

    if (hasCache) {
      debugPrint("📴 Offline Mode. Returning cached data (Fallback).");
      return SuccessResponse(data: cacheMapper(cachedData));
    }

    debugPrint("❌ Offline AND No Cache!");
    return const ErrorResponse(errorMessage: ErrorStrings.emptyCacheError);
  }

  bool _isCacheEmpty(dynamic data) {
  if (data == null) return true;
  if (data is List) return data.isEmpty; // ✅
  return false;
}
}
