import 'package:fitness_app/Features/food/api/data_sources_imple/food_local_data_source_imple.dart';
import 'package:fitness_app/Features/food/data/models/meals_models/category_model.dart';
import 'package:fitness_app/Features/food/data/models/meals_models/meal_details_model.dart';
import 'package:fitness_app/Features/food/data/models/meals_models/meal_model.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:hive_ce/hive.dart';
import 'package:fitness_app/core/data_base/hive_database_service.dart';

import 'food_local_data_source_imple_test.mocks.dart';

@GenerateMocks([HiveDatabaseService, Box])
void main() {
  late FoodLocalDataSourceImple localDataSource;
  late MockHiveDatabaseService mockHiveDb;
  late MockBox mockBox;
  late MockBox mockMetadataBox;

  setUp(() {
    mockHiveDb = MockHiveDatabaseService();
    mockBox = MockBox();
    mockMetadataBox = MockBox();

    HiveDatabaseService.instance = mockHiveDb;

    localDataSource = FoodLocalDataSourceImple();

    when(mockHiveDb.openBox(any)).thenAnswer((invocation) async {
      final boxName = invocation.positionalArguments[0] as String;
      if (boxName == 'cache_metadata_box') {
        return mockMetadataBox;
      }
      return mockBox;
    });
  });

  tearDown(() {});

  group('FoodLocalDataSource Cache Logic Tests', () {
    test('isCacheExpired should return true if no timestamp exists', () async {
      when(mockMetadataBox.get(any)).thenReturn(null);

      final result = await localDataSource.isCacheExpired(
        'test_key',
        const Duration(hours: 24),
      );

      expect(result, true);
    });

    test('isCacheExpired should return false if timestamp is recent', () async {
      final recentTimestamp = DateTime.now()
          .subtract(const Duration(hours: 1))
          .millisecondsSinceEpoch;
      when(mockMetadataBox.get(any)).thenReturn(recentTimestamp);

      final result = await localDataSource.isCacheExpired(
        'test_key',
        const Duration(hours: 24),
      );
      expect(result, false);
    });
  });

  group('Meal Details Local Logic', () {
    const tId = '52772';
    final tMealModel = MealDetailsModel(
      idMeal: tId,
      strMeal: 'Teriyaki Chicken',
    );

    test(
      'saveMealDetail should save data and timestamp in correct boxes',
      () async {
        // Arrange
        when(mockBox.put(any, any)).thenAnswer((_) async => Future.value());
        when(
          mockMetadataBox.put(any, any),
        ).thenAnswer((_) async => Future.value());

        // Act
        await localDataSource.saveMealDetail(tMealModel);

        // Assert
        verify(mockBox.put('detail_$tId', tMealModel)).called(1);
        verify(mockMetadataBox.put('ts_detail_$tId', any)).called(1);
      },
    );

    test('getMealDetail should return data from box when exists', () async {
      // Arrange
      when(mockBox.get('detail_$tId')).thenReturn(tMealModel);

      // Act
      final result = await localDataSource.getMealDetail(tId);

      // Assert
      expect(result, tMealModel);
      verify(mockBox.get('detail_$tId')).called(1);
    });
  });

  group('Categories Local Logic', () {
    final tCategories = [CategoryModel(idCategory: '1', strCategory: 'Beef')];

    test('saveCategories should save list and timestamp', () async {
      when(mockBox.put(any, any)).thenAnswer((_) async => Future.value());

      await localDataSource.saveCategories(tCategories);

      verify(mockBox.put('categories_key', tCategories)).called(1);
      verify(mockMetadataBox.put('ts_categories_key', any)).called(1);
    });

    test('getCategories should return list when exists', () async {
      when(mockBox.get('categories_key')).thenReturn(tCategories);

      final result = await localDataSource.getCategories();

      expect(result, tCategories);
    });
  });

  group('Meals By Category Local Logic', () {
    const tCategoryName = 'Chicken';
    final tMeals = [MealModel(idMeal: '1', strMeal: 'Chicken Handi')];

    test(
      'saveMealsByCategory should save meals with category-specific key',
      () async {
        await localDataSource.saveMealsByCategory(tCategoryName, tMeals);

        verify(mockBox.put('meals_$tCategoryName', tMeals)).called(1);
        verify(mockMetadataBox.put('ts_meals_$tCategoryName', any)).called(1);
      },
    );

    test('getMealsByCategory should return correct meals', () async {
      when(mockBox.get('meals_$tCategoryName')).thenReturn(tMeals);

      final result = await localDataSource.getMealsByCategory(tCategoryName);

      expect(result, tMeals);
    });
  });
}
