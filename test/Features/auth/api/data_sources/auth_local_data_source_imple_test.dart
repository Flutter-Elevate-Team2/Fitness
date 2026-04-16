import 'package:fitness_app/Features/auth/api/data_sources/auth_local_data_source_imple.dart';
import 'package:fitness_app/core/constants/api_constants.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'auth_local_data_source_imple_test.mocks.dart';

@GenerateMocks([SharedPreferences, FlutterSecureStorage])
void main() {
  late AuthLocalDataSourceImpl localDataSource;
  late MockSharedPreferences mockSharedPreferences;
  late MockFlutterSecureStorage mockSecureStorage;

  setUp(() {
    mockSharedPreferences = MockSharedPreferences();
    mockSecureStorage = MockFlutterSecureStorage();
    localDataSource = AuthLocalDataSourceImpl(
      mockSharedPreferences,
      mockSecureStorage,
    );
  });

  group('AuthLocalDataSourceImpl - saveToken', () {
    test(
      'should write the token to FlutterSecureStorage under the correct key',
      () async {
        // ARRANGE
        const tToken = 'test_token';
        when(
          mockSecureStorage.write(key: ApiConstants.tokenKey, value: tToken),
        ).thenAnswer((_) async => null);

        // ACT
        await localDataSource.saveToken(tToken);

        // ASSERT
        verify(
          mockSecureStorage.write(key: ApiConstants.tokenKey, value: tToken),
        ).called(1);
      },
    );
  });

  group('AuthLocalDataSourceImpl - getToken', () {
    test(
      'should read and return the token string from FlutterSecureStorage',
      () async {
        // ARRANGE
        const tToken = 'test_token';
        when(
          mockSecureStorage.read(key: ApiConstants.tokenKey),
        ).thenAnswer((_) async => tToken);

        // ACT
        final result = await localDataSource.getToken();

        // ASSERT
        expect(result, tToken);
        verify(mockSecureStorage.read(key: ApiConstants.tokenKey)).called(1);
      },
    );

    test(
      'should return null when no token has been previously saved',
      () async {
        // ARRANGE
        when(
          mockSecureStorage.read(key: ApiConstants.tokenKey),
        ).thenAnswer((_) async => null);

        // ACT
        final result = await localDataSource.getToken();

        // ASSERT
        expect(result, isNull);
      },
    );
  });

  group('AuthLocalDataSourceImpl - saveRememberMe', () {
    test('should persist the value to SharedPreferences', () async {
      // ARRANGE
      when(
        mockSharedPreferences.setBool(ApiConstants.rememberMeKey, true),
      ).thenAnswer((_) async => true);

      // ACT
      await localDataSource.saveRememberMe(true);

      // ASSERT
      verify(
        mockSharedPreferences.setBool(ApiConstants.rememberMeKey, true),
      ).called(1);
    });
  });

  group('AuthLocalDataSourceImpl - getRememberMe', () {
    test('should return true when stored value is true', () async {
      // ARRANGE
      when(
        mockSharedPreferences.getBool(ApiConstants.rememberMeKey),
      ).thenReturn(true);

      // ACT
      final result = await localDataSource.getRememberMe();

      // ASSERT
      expect(result, isTrue);
    });

    test(
      'should return false (default) when SharedPreferences returns null',
      () async {
        // ARRANGE
        when(
          mockSharedPreferences.getBool(ApiConstants.rememberMeKey),
        ).thenReturn(null);

        // ACT
        final result = await localDataSource.getRememberMe();

        // ASSERT
        expect(result, isFalse);
      },
    );
  });

  group('AuthLocalDataSourceImpl - clearUserData', () {
    test('should delete token and remove rememberMe key', () async {
      // ARRANGE
      when(
        mockSecureStorage.delete(key: ApiConstants.tokenKey),
      ).thenAnswer((_) async => null);
      when(
        mockSharedPreferences.remove(ApiConstants.rememberMeKey),
      ).thenAnswer((_) async => true);

      // ACT
      await localDataSource.clearUserData();

      // ASSERT
      verify(mockSecureStorage.delete(key: ApiConstants.tokenKey)).called(1);
      verify(
        mockSharedPreferences.remove(ApiConstants.rememberMeKey),
      ).called(1);
    });
  });
}
