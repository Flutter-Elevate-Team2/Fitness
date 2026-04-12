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
  late MockFlutterSecureStorage mockSecureStorage;

  setUp(() {
    mockPrefs = MockSharedPreferences();
    mockSecureStorage = MockFlutterSecureStorage();
    dataSource = AuthLocalDataSourceImpl(mockPrefs, mockSecureStorage);
  });

  test('saveToken should save token in flutter secure storage', () async {
    // act
    await dataSource.saveToken('token');

    // assert
    verify(
      mockSecureStorage.write(key: ApiConstants.tokenKey, value: 'token'),
    ).called(1);
  });

  test('getToken should return token from flutter secure storage', () async {
    // arrange
    when(
      mockSecureStorage.read(key: ApiConstants.tokenKey),
    ).thenAnswer((_) async => 'token');

    // act
    final result = await dataSource.getToken();

    // assert
    expect(result, 'token');
    verify(mockSecureStorage.read(key: ApiConstants.tokenKey)).called(1);
  });

  test('saveRememberMe should save value in shared preferences', () async {
    // arrange
    when(
      mockPrefs.setBool('is_remember_me', true),
    ).thenAnswer((_) async => true);

    // act
    await dataSource.saveRememberMe(true);

    // assert
    verify(mockPrefs.setBool('is_remember_me', true)).called(1);
    verifyNoMoreInteractions(mockPrefs);
  });

  test('getRememberMe should return false when value is null', () async {
    // arrange
    when(mockPrefs.getBool('is_remember_me')).thenReturn(null);

    // act
    final result = await dataSource.getRememberMe();

    // assert
    expect(result, false);
    verify(mockPrefs.getBool('is_remember_me')).called(1);
    verifyNoMoreInteractions(mockPrefs);
  });

  test('getRememberMe should return stored value when exists', () async {
    // arrange
    when(mockPrefs.getBool('is_remember_me')).thenReturn(true);

    // act
    final result = await dataSource.getRememberMe();

    // assert
    expect(result, true);
    verify(mockPrefs.getBool('is_remember_me')).called(1);
    verifyNoMoreInteractions(mockPrefs);
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

      // act
      await dataSource.clearUserData();

      // assert
      verify(mockSecureStorage.delete(key: ApiConstants.tokenKey)).called(1);
      verify(mockPrefs.remove(ApiConstants.rememberMeKey)).called(1);
    },
  );
}
