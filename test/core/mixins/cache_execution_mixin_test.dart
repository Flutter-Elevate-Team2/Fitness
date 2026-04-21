import 'package:fitness_app/core/base_response/base_response.dart';
import 'package:fitness_app/core/errors/error_strings.dart';
import 'package:fitness_app/core/mixins/cache_execution_mixin.dart';
import 'package:fitness_app/core/network/network_info.dart';
import 'package:flutter_test/flutter_test.dart';

class TestCacheExecutor with CacheExecutionMixin {
  @override
  final NetworkInfo networkInfo;

  TestCacheExecutor(this.networkInfo);
}

class FakeNetworkInfo implements NetworkInfo {
  bool isOnline = true;
  @override
  Future<bool> get isConnected async => isOnline;
}

void main() {
  late TestCacheExecutor executor;
  late FakeNetworkInfo fakeNetworkInfo;

  int remoteCallCount = 0;
  int cacheCallCount = 0;
  int saveCallCount = 0;

  setUp(() {
    fakeNetworkInfo = FakeNetworkInfo();
    executor = TestCacheExecutor(fakeNetworkInfo);

    remoteCallCount = 0;
    cacheCallCount = 0;
    saveCallCount = 0;
  });
  Future<String> mockFetchRemote() async {
    remoteCallCount++;
    return "Remote Data";
  }

  Future<String?> mockFetchCache(String? cachedData) async {
    cacheCallCount++;
    return cachedData;
  }

  Future<void> mockSaveToCache(String data) async {
    saveCallCount++;
  }

  String mapper(dynamic data) => data.toString();

  group('CacheExecutionMixin Tests', () {

    test('1. Has Cache + Offline => Returns Cache instantly, No Remote Call', () async {
      fakeNetworkInfo.isOnline = false;

      final result = await executor.executeWithCache<String, String?, String>(
        fetchFromRemote: mockFetchRemote,
        fetchFromCache: () => mockFetchCache("Cached Data"),
        saveToCache: mockSaveToCache,
        remoteMapper: mapper,
        cacheMapper: mapper,
      );

      expect(result, isA<SuccessResponse<String>>());
      expect((result as SuccessResponse<String>).data, "Cached Data");
      expect(cacheCallCount, 1);
      expect(remoteCallCount, 0);
      expect(saveCallCount, 0);
    });

    test('2. Has Cache + Online => Returns Cache, then Syncs Background', () async {
      fakeNetworkInfo.isOnline = true;

      final result = await executor.executeWithCache<String, String?, String>(
        fetchFromRemote: mockFetchRemote,
        fetchFromCache: () => mockFetchCache("Cached Data"),
        saveToCache: mockSaveToCache,
        remoteMapper: mapper,
        cacheMapper: mapper,
      );

      expect(result, isA<SuccessResponse<String>>());
      expect((result as SuccessResponse<String>).data, "Cached Data");

      await Future.delayed(Duration.zero);

      expect(cacheCallCount, 1);
      expect(remoteCallCount, 1);
      expect(saveCallCount, 1);
    });

    test('3. No Cache + Online => Fetches Remote, Saves to Cache, Returns Remote', () async {
      fakeNetworkInfo.isOnline = true;

      final result = await executor.executeWithCache<String, String?, String>(
        fetchFromRemote: mockFetchRemote,
        fetchFromCache: () => mockFetchCache(null),
        saveToCache: mockSaveToCache,
        remoteMapper: mapper,
        cacheMapper: mapper,
      );

      expect(result, isA<SuccessResponse<String>>());
      expect((result as SuccessResponse<String>).data, "Remote Data");

      expect(cacheCallCount, 1);
      expect(remoteCallCount, 1);
      expect(saveCallCount, 1);
    });

    test('4. No Cache + Offline => Returns ErrorResponse(EMPTY_CACHE)', () async {
      fakeNetworkInfo.isOnline = false;

      final result = await executor.executeWithCache<String, String?, String>(
        fetchFromRemote: mockFetchRemote,
        fetchFromCache: () => mockFetchCache(null),
        saveToCache: mockSaveToCache,
        remoteMapper: mapper,
        cacheMapper: mapper,
      );

      expect(result, isA<ErrorResponse<String>>());
      expect((result as ErrorResponse<String>).errorMessage, ErrorStrings.emptyCacheError);

      expect(cacheCallCount, 1);
      expect(remoteCallCount, 0);
      expect(saveCallCount, 0);
    });
  });
}
