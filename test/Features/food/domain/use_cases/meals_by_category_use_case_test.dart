import 'package:fitness_app/Features/food/domain/entities/meals_by_category_entity.dart';
import 'package:fitness_app/Features/food/domain/repo/food_repo_contract.dart';
import 'package:fitness_app/Features/food/domain/use_cases/meals_by_category_use_case.dart';
import 'package:fitness_app/core/base_response/base_response.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

import 'meals_by_category_use_case_test.mocks.dart';

@GenerateMocks([FoodRepoContract])
void main() {
  late MockFoodRepoContract mockRepo;
  late GetMealsByCategoryUseCase getMealsByCategoryUseCase;

  setUpAll(() {
    provideDummy<BaseResponse<List<MealsByCategoryEntity>>>(
      SuccessResponse(data: []),
    );
  });

  setUp(() {
    mockRepo = MockFoodRepoContract();
    getMealsByCategoryUseCase = GetMealsByCategoryUseCase(mockRepo);
  });

  group('Food Domain Use Cases Tests', () {
    test(
      'GetMealsByCategoryUseCase should call getMealsByCategory from repository',
      () async {
        // Arrange
        const tCategory = 'Seafood';
        final tResponse = SuccessResponse<List<MealsByCategoryEntity>>(
          data: [],
        );
        when(
          mockRepo.getMealsByCategory(tCategory),
        ).thenAnswer((_) async => tResponse);

        // Act
        final result = await getMealsByCategoryUseCase.call(tCategory);

        // Assert
        expect(result, tResponse);
        verify(mockRepo.getMealsByCategory(tCategory)).called(1);
      },
    );
  });
}
