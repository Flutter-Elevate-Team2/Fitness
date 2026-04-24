import 'package:fitness_app/core/base_response/base_response.dart';
import 'package:fitness_app/core/errors/error_strings.dart';
import 'package:fitness_app/core/mixins/cache_execution_mixin.dart';
import 'package:fitness_app/core/network/network_info.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'cache_execution_mixin_test.mocks.dart';

class FakeCacheRepo with CacheExecutionMixin {
  @override
  final NetworkInfo networkInfo;
  FakeCacheRepo(this.networkInfo);
}

@GenerateMocks([NetworkInfo])
void main() {
  late FakeCacheRepo sut;
  late MockNetworkInfo mockNetworkInfo;


  Future<BaseResponse<String>> runMixin({
    required bool isOnline,
    required String? cachedData,
    required bool isExpired,
    String remoteResult = 'remote_data',
    bool remoteThrows = false,
  }) {
    when(mockNetworkInfo.isConnected).thenAnswer((_) async => isOnline);

    return sut.executeWithCache<String, String?, String>(
      fetchFromRemote: () async {
        if (remoteThrows) throw Exception('API error');
        return remoteResult;
      },
      fetchFromCache: () async => cachedData,
      saveToCache: (_) async {},
      remoteMapper: (data) => 'mapped_$data',
      cacheMapper: (data) => 'cached_$data',
      isExpired: () async => isExpired,
    );
  }

  setUp(() {
    mockNetworkInfo = MockNetworkInfo();
    sut = FakeCacheRepo(mockNetworkInfo);
  });

  // ── 1. Cache valid (not expired) ──────────────────────────────────────────────
  group('when cache is valid and not expired', () {
    test('returns cached data without calling API', () async {
      final result = await runMixin(
        isOnline: true,
        cachedData: 'local_data',
        isExpired: false,
      );

      expect(result, isA<SuccessResponse<String>>());
      expect((result as SuccessResponse).data, 'cached_local_data');
    });

    test('returns cached data even when offline', () async {
      final result = await runMixin(
        isOnline: false,
        cachedData: 'local_data',
        isExpired: false,
      );

      expect(result, isA<SuccessResponse<String>>());
      expect((result as SuccessResponse).data, 'cached_local_data');
    });
  });

  // ── 2. Cache expired + online ─────────────────────────────────────────────────
  group('when cache is expired and online', () {
    test('fetches from API and returns fresh data', () async {
      final result = await runMixin(
        isOnline: true,
        cachedData: 'old_data',
        isExpired: true,
        remoteResult: 'fresh_data',
      );

      expect(result, isA<SuccessResponse<String>>());
      expect((result as SuccessResponse).data, 'mapped_fresh_data');
    });
  });

  // ── 3. No cache + online ──────────────────────────────────────────────────────
  group('when no cache and online', () {
    test('fetches from API and returns remote data', () async {
      final result = await runMixin(
        isOnline: true,
        cachedData: null,
        isExpired: true,
        remoteResult: 'new_data',
      );

      expect(result, isA<SuccessResponse<String>>());
      expect((result as SuccessResponse).data, 'mapped_new_data');
    });
  });

  // ── 4. API fails + has stale cache ────────────────────────────────────────────
  group('when API fails', () {
    test('returns stale cache as fallback when cache exists', () async {
      final result = await runMixin(
        isOnline: true,
        cachedData: 'stale_data',
        isExpired: true,
        remoteThrows: true,
      );

      expect(result, isA<SuccessResponse<String>>());
      expect((result as SuccessResponse).data, 'cached_stale_data');
    });

    test('returns error when API fails and no cache exists', () async {
      final result = await runMixin(
        isOnline: true,
        cachedData: null,
        isExpired: true,
        remoteThrows: true,
      );

      expect(result, isA<ErrorResponse<String>>());
    });
  });

  // ── 5. Offline ────────────────────────────────────────────────────────────────
  group('when offline', () {
    test('returns cached data when cache exists', () async {
      final result = await runMixin(
        isOnline: false,
        cachedData: 'offline_data',
        isExpired: true,
      );

      expect(result, isA<SuccessResponse<String>>());
      expect((result as SuccessResponse).data, 'cached_offline_data');
    });

    test('returns error when offline and no cache', () async {
      final result = await runMixin(
        isOnline: false,
        cachedData: null,
        isExpired: true,
      );

      expect(result, isA<ErrorResponse<String>>());
      expect(
        (result as ErrorResponse).errorMessage,
        ErrorStrings.emptyCacheError,
      );
    });
  });

  // ── 6. Empty list cache ───────────────────────────────────────────────────────
  group('empty list cache', () {
    test('treats empty list as "No Cache" and fetches from API (Current Logic)', () async {
      // ترتيب: الكاش يحتوي على قائمة فارغة
      when(mockNetworkInfo.isConnected).thenAnswer((_) async => true);

      final result = await sut.executeWithCache<String, List<String>?, List<String>>(
        fetchFromRemote: () async => 'remote_data',
        fetchFromCache: () async => [], // الميكسن سيعتبر هذا "hasCache = false"
        saveToCache: (_) async {},
        remoteMapper: (data) => ['mapped_$data'], // سيحولها لقائمة تحتوي على عنصر
        cacheMapper: (data) => data ?? [],
        isExpired: () async => false,
      );

      // التأكد من أن النتيجة هي البيانات القادمة من الـ API (Remote)
      // لأن الميكسن اعتبر القائمة الفارغة "No Cache"
      expect(result, isA<SuccessResponse<List<String>>>());
      expect((result as SuccessResponse).data, contains('mapped_remote_data'));
      expect((result as SuccessResponse).data!.length, 1);
    });
  });
}
