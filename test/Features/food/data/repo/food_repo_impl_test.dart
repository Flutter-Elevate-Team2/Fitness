import 'package:fitness_app/Features/food/data/data_sources_contract/food_local_data_source_contract.dart';
import 'package:fitness_app/Features/food/data/data_sources_contract/food_remote_data_source_contract.dart';
import 'package:fitness_app/Features/food/data/models/meals_models/category_model.dart';
import 'package:fitness_app/Features/food/data/models/meals_models/meal_details_model.dart';
import 'package:fitness_app/Features/food/data/models/meals_models/meal_model.dart';
import 'package:fitness_app/Features/food/data/models/meals_response/categories_response.dart';
import 'package:fitness_app/Features/food/data/models/meals_response/meal_details_response.dart'
    as remote_details;
import 'package:fitness_app/Features/food/data/models/meals_response/meals_by_category_response.dart'
    as remote_meals;
import 'package:fitness_app/Features/food/data/repo/food_repo_impl.dart';
import 'package:fitness_app/core/base_response/base_response.dart';
import 'package:fitness_app/core/network/network_info.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

import 'food_repo_impl_test.mocks.dart';

@GenerateNiceMocks([
  MockSpec<FoodRemoteDataSourceContract>(),
  MockSpec<FoodLocalDataSourceContract>(),
  MockSpec<NetworkInfo>(),
])
void main() {
  late FoodRepoImpl repo;
  late MockFoodRemoteDataSourceContract mockRemote;
  late MockFoodLocalDataSourceContract mockLocal;
  late MockNetworkInfo mockNetworkInfo;

  setUp(() {
    mockRemote = MockFoodRemoteDataSourceContract();
    mockLocal = MockFoodLocalDataSourceContract();
    mockNetworkInfo = MockNetworkInfo();
    repo = FoodRepoImpl(mockRemote, mockLocal, mockNetworkInfo);

    when(mockLocal.isCacheExpired(any, any)).thenAnswer((_) async => true);
    when(mockLocal.saveCategories(any)).thenAnswer((_) async => Future.value());
    when(
      mockLocal.saveMealsByCategory(any, any),
    ).thenAnswer((_) async => Future.value());
    when(mockLocal.saveMealDetail(any)).thenAnswer((_) async => Future.value());
  });

  group('getCategories Tests', () {
    final tResponse = CategoriesResponse(categories: []);

    test(
      'should return remote data and cache it when online and cache expired',
      () async {
        when(mockNetworkInfo.isConnected).thenAnswer((_) async => true);
        when(mockRemote.getCategories()).thenAnswer((_) async => tResponse);
        when(mockLocal.getCategories()).thenAnswer((_) async => []);

        final result = await repo.getCategories();
        expect(result, isA<SuccessResponse>());
      },
    );

    test(
      'should return cached data when online but cache NOT expired',
      () async {
        when(mockNetworkInfo.isConnected).thenAnswer((_) async => true);
        when(mockLocal.isCacheExpired(any, any)).thenAnswer((_) async => false);
        when(
          mockLocal.getCategories(),
        ).thenAnswer((_) async => <CategoryModel>[]);

        final result = await repo.getCategories();
        expect(result, isA<SuccessResponse>());
        verifyZeroInteractions(mockRemote);
      },
    );
  });

  group('getMealsByCategory Tests', () {
    const tCategory = 'Beef';
    final tRemoteMeals = remote_meals.MealsByCategoryResponse(meals: []);

    test('should fetch from remote when online', () async {
      when(mockNetworkInfo.isConnected).thenAnswer((_) async => true);
      when(
        mockRemote.getMealsByCategory(tCategory),
      ).thenAnswer((_) async => tRemoteMeals);
      when(mockLocal.getMealsByCategory(tCategory)).thenAnswer((_) async => []);

      final result = await repo.getMealsByCategory(tCategory);
      expect(result, isA<SuccessResponse>());
    });

    test('should return cached data when offline', () async {
      when(mockNetworkInfo.isConnected).thenAnswer((_) async => false);
      when(
        mockLocal.getMealsByCategory(tCategory),
      ).thenAnswer((_) async => <MealModel>[]);

      final result = await repo.getMealsByCategory(tCategory);
      expect(result, isA<SuccessResponse>());
    });

    test(
      'should return cached data when online but cache NOT expired',
      () async {
        when(mockNetworkInfo.isConnected).thenAnswer((_) async => true);
        when(mockLocal.isCacheExpired(any, any)).thenAnswer((_) async => false);
        when(
          mockLocal.getMealsByCategory(any),
        ).thenAnswer((_) async => <MealModel>[]);

        final result = await repo.getMealsByCategory(tCategory);
        expect(result, isA<SuccessResponse>());
        verifyZeroInteractions(mockRemote);
      },
    );
  });

  group('getMealDetails Tests', () {
    const tId = '52772';
    final tResponse = remote_details.MealDetailsResponse(
      meals: [remote_details.Meals(idMeal: tId, strMeal: 'Test')],
    );

    test('should return remote data when online and cache expired', () async {
      when(mockNetworkInfo.isConnected).thenAnswer((_) async => true);
      when(mockRemote.getMealDetails(tId)).thenAnswer((_) async => tResponse);
      when(mockLocal.getMealDetail(tId)).thenAnswer((_) async => null);

      final result = await repo.getMealDetails(tId);
      expect(result, isA<SuccessResponse>());
    });

    test('should return cached data when offline', () async {
      when(mockNetworkInfo.isConnected).thenAnswer((_) async => false);
      when(mockLocal.getMealDetail(tId)).thenAnswer(
        (_) async =>
            MealDetailsModel(idMeal: tId, ingredients: [], measures: []),
      );

      final result = await repo.getMealDetails(tId);
      expect(result, isA<SuccessResponse>());
    });

    test(
      'should return cached data when online but cache NOT expired',
      () async {
        when(mockNetworkInfo.isConnected).thenAnswer((_) async => true);
        when(mockLocal.isCacheExpired(any, any)).thenAnswer((_) async => false);
        when(mockLocal.getMealDetail(any)).thenAnswer(
          (_) async =>
              MealDetailsModel(idMeal: '1', ingredients: [], measures: []),
        );

        final result = await repo.getMealDetails(tId);
        expect(result, isA<SuccessResponse>());
        verifyZeroInteractions(mockRemote);
      },
    );

    test(
      'should not call saveMealDetail if remote response meals is empty',
      () async {
        final emptyResponse = remote_details.MealDetailsResponse(meals: []);
        when(mockNetworkInfo.isConnected).thenAnswer((_) async => true);
        when(
          mockRemote.getMealDetails(any),
        ).thenAnswer((_) async => emptyResponse);
        when(mockLocal.getMealDetail(any)).thenAnswer((_) async => null);

        try {
          await repo.getMealDetails('52772');
        } catch (e) {
          expect(e, isA<Exception>());
        }

        verifyNever(mockLocal.saveMealDetail(any));
      },
    );
  });
}
