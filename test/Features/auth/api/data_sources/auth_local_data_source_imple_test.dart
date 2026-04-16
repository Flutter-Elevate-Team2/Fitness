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
  late AuthLocalDataSourceImpl dataSource;
  late MockSharedPreferences mockPrefs;
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
        const tToken = 'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.test_token';
        when(
          mockSecureStorage.write(
            key: ApiConstants.tokenKey,
            value: tToken,
          ),
        ).thenAnswer((_) async {
          return null;
        });

        // ACT
        await localDataSource.saveToken(tToken);

        // ASSERT
        verify(
          mockSecureStorage.write(
            key: ApiConstants.tokenKey,
            value: tToken,
          ),
        ).called(1);
        verifyZeroInteractions(mockSharedPreferences);
      },
    );
  });

  test('saveToken should save token in flutter secure storage', () async {
    // act
    await dataSource.saveToken('token');
  group('AuthLocalDataSourceImpl - getToken', () {
    test(
      'should read and return the token string from FlutterSecureStorage',
      () async {
        // ARRANGE
        const tToken = 'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.test_token';
        when(
          mockSecureStorage.read(key: ApiConstants.tokenKey),
        ).thenAnswer((_) async => tToken);

    // assert
    verify(
      mockSecureStorage.write(key: ApiConstants.tokenKey, value: 'token'),
    ).called(1);
  });
        // ACT
        final result = await localDataSource.getToken();

        // ASSERT
        expect(result, tToken);
        verify(
          mockSecureStorage.read(key: ApiConstants.tokenKey),
        ).called(1);
        verifyZeroInteractions(mockSharedPreferences);
      },
    );

  test('getToken should return token from flutter secure storage', () async {
    // arrange
    when(
      mockSecureStorage.read(key: ApiConstants.tokenKey),
    ).thenAnswer((_) async => 'token');
    test(
      'should return null when no token has been previously saved',
      () async {
        // ARRANGE
        when(
          mockSecureStorage.read(key: ApiConstants.tokenKey),
        ).thenAnswer((_) async => null);

    // act
    final result = await dataSource.getToken();
        // ACT
        final result = await localDataSource.getToken();

    // assert
    expect(result, 'token');
    verify(mockSecureStorage.read(key: ApiConstants.tokenKey)).called(1);
        // ASSERT
        expect(result, isNull);
        verify(
          mockSecureStorage.read(key: ApiConstants.tokenKey),
        ).called(1);
      },
    );
  });

  test('saveRememberMe should save value in shared preferences', () async {
    // arrange
    when(
      mockPrefs.setBool('is_remember_me', true),
    ).thenAnswer((_) async => true);
  group('AuthLocalDataSourceImpl - saveRememberMe', () {
    test(
      'should persist the "true" value to SharedPreferences under the correct key',
      () async {
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
        verifyZeroInteractions(mockSecureStorage);
      },
    );

    test(
      'should persist the "false" value to SharedPreferences under the correct key',
      () async {
        // ARRANGE
        when(
          mockSharedPreferences.setBool(ApiConstants.rememberMeKey, false),
        ).thenAnswer((_) async => true);

    // act
    await dataSource.saveRememberMe(true);
        // ACT
        await localDataSource.saveRememberMe(false);

    // assert
    verify(mockPrefs.setBool('is_remember_me', true)).called(1);
    verifyNoMoreInteractions(mockPrefs);
        // ASSERT
        verify(
          mockSharedPreferences.setBool(ApiConstants.rememberMeKey, false),
        ).called(1);
        verifyZeroInteractions(mockSecureStorage);
      },
    );
  });

  test('getRememberMe should return false when value is null', () async {
    // arrange
    when(mockPrefs.getBool('is_remember_me')).thenReturn(null);
  group('AuthLocalDataSourceImpl - getRememberMe', () {
    test(
      'should return true when SharedPreferences has a stored "true" value',
      () async {
        // ARRANGE
        when(
          mockSharedPreferences.getBool(ApiConstants.rememberMeKey),
        ).thenReturn(true);

    // act
    final result = await dataSource.getRememberMe();
        // ACT
        final result = await localDataSource.getRememberMe();

    // assert
    expect(result, false);
    verify(mockPrefs.getBool('is_remember_me')).called(1);
    verifyNoMoreInteractions(mockPrefs);
  });
        // ASSERT
        expect(result, isTrue);
        verify(
          mockSharedPreferences.getBool(ApiConstants.rememberMeKey),
        ).called(1);
        verifyZeroInteractions(mockSecureStorage);
      },
    );

  test('getRememberMe should return stored value when exists', () async {
    // arrange
    when(mockPrefs.getBool('is_remember_me')).thenReturn(true);
    test(
      'should return false (default) when SharedPreferences returns null for the key',
      () async {
        // ARRANGE
        when(
          mockSharedPreferences.getBool(ApiConstants.rememberMeKey),
        ).thenReturn(null);

    // act
    final result = await dataSource.getRememberMe();
        // ACT
        final result = await localDataSource.getRememberMe();

    // assert
    expect(result, true);
    verify(mockPrefs.getBool('is_remember_me')).called(1);
    verifyNoMoreInteractions(mockPrefs);
        // ASSERT
        // Fallback is `?? false` as defined in the implementation
        expect(result, isFalse);
        verify(
          mockSharedPreferences.getBool(ApiConstants.rememberMeKey),
        ).called(1);
      },
    );
  });

  test(
    'clearUserData should remove token from secure storage and remember me from prefs',
    () async {
      // arrange
      when(
        mockSecureStorage.delete(key: ApiConstants.tokenKey),
      ).thenAnswer((_) async => {});
      when(
        mockPrefs.remove(ApiConstants.rememberMeKey),
      ).thenAnswer((_) async => true);
  group('AuthLocalDataSourceImpl - clearUserData', () {
    test(
      'should delete the token from SecureStorage and remove rememberMe from SharedPreferences',
      () async {
        // ARRANGE
        when(
          mockSecureStorage.delete(key: ApiConstants.tokenKey),
        ).thenAnswer((_) async {
          return null;
        });
        when(
          mockSharedPreferences.remove(ApiConstants.rememberMeKey),
        ).thenAnswer((_) async => true);

      // act
      await dataSource.clearUserData();
        // ACT
        await localDataSource.clearUserData();

      // assert
      verify(mockSecureStorage.delete(key: ApiConstants.tokenKey)).called(1);
      verify(mockPrefs.remove(ApiConstants.rememberMeKey)).called(1);
    },
  );
        // ASSERT
        verify(
          mockSecureStorage.delete(key: ApiConstants.tokenKey),
        ).called(1);
        verify(
          mockSharedPreferences.remove(ApiConstants.rememberMeKey),
        ).called(1);
        verifyNoMoreInteractions(mockSecureStorage);
        verifyNoMoreInteractions(mockSharedPreferences);
      },
    );
  });
}
