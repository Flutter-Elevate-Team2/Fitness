import 'package:fitness_app/Features/food/api/data_sources_imple/food_remote_data_source_impl.dart';
import 'package:fitness_app/Features/food/data/models/meals_response/meal_details_response.dart';
import 'package:fitness_app/Features/food/data/models/meals_response/meals_by_category_response.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:fitness_app/Features/food/api/api_client/food_api.dart';
import 'package:fitness_app/Features/food/data/models/meals_response/categories_response.dart';

import 'food_remote_data_source_impl_test.mocks.dart';

@GenerateMocks([FoodApi])
void main() {
  late FoodRemoteDataSourceImpl remoteDataSource;
  late MockFoodApi mockFoodApi;

  setUp(() {
    mockFoodApi = MockFoodApi();
    remoteDataSource = FoodRemoteDataSourceImpl(mockFoodApi);
  });

  group('FoodRemoteDataSource Tests', () {
    test(
      'getCategories should call FoodApi.getCategories and return data',
      () async {
        final tCategoriesResponse = CategoriesResponse(categories: []);

        when(
          mockFoodApi.getCategories(),
        ).thenAnswer((_) async => tCategoriesResponse);

        final result = await remoteDataSource.getCategories();

        expect(result, tCategoriesResponse);
        verify(mockFoodApi.getCategories()).called(1);
      },
    );

    test(
      'getMealsByCategory should call FoodApi.getMealsByCategory with correct parameter',
      () async {
        const tCategory = 'Beef';
        final tMealsResponse = MealsByCategoryResponse(meals: []);

        when(
          mockFoodApi.getMealsByCategory(any),
        ).thenAnswer((_) async => tMealsResponse);

        final result = await remoteDataSource.getMealsByCategory(tCategory);

        expect(result, tMealsResponse);
        verify(mockFoodApi.getMealsByCategory(tCategory)).called(1);
      },
    );

    test(
      'getMealDetails should call FoodApi with correct id and return data',
      () async {
        const tId = '52772';
        final tResponse = MealDetailsResponse(meals: []);

        when(
          mockFoodApi.getMealDetails(any),
        ).thenAnswer((_) async => tResponse);

        final result = await remoteDataSource.getMealDetails(tId);

        expect(result, tResponse);
        verify(mockFoodApi.getMealDetails(tId)).called(1);
      },
    );
  });
}
