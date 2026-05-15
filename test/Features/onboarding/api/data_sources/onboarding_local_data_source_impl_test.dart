import 'package:fitness_app/Features/onboarding/api/data_sources/onboarding_local_data_source_impl.dart';
import 'package:fitness_app/core/constants/api_constants.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'onboarding_local_data_source_impl_test.mocks.dart';

@GenerateMocks([SharedPreferences])
void main() {
  late OnboardingLocalDataSourceImpl dataSource;
  late MockSharedPreferences mockPrefs;

  setUp(() {
    mockPrefs = MockSharedPreferences();
    dataSource = OnboardingLocalDataSourceImpl(mockPrefs);
  });

  group('saveOnboardingVisited', () {
    test('should call setBool with correct key and value', () async {
      // Arrange
      when(mockPrefs.setBool(any, any)).thenAnswer((_) async => true);

      // Act
      await dataSource.saveOnboardingVisited();

      // Assert
      verify(mockPrefs.setBool(ApiConstants.onboardingKey, true)).called(1);
    });
  });

  group('isOnboardingVisited', () {
    test('should return true when shared_preferences returns true', () {
      // Arrange
      when(mockPrefs.getBool(ApiConstants.onboardingKey)).thenReturn(true);

      // Act
      final result = dataSource.isOnboardingVisited();

      // Assert
      expect(result, true);
    });

    test(
      'should return false when shared_preferences returns null (First Time)',
      () {
        // Arrange
        when(mockPrefs.getBool(ApiConstants.onboardingKey)).thenReturn(null);

        // Act
        final result = dataSource.isOnboardingVisited();

        // Assert
        expect(result, false);
      },
    );
  });
}
