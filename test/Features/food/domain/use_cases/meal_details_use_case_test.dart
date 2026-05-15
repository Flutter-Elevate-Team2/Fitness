import 'package:fitness_app/Features/food/domain/entities/meal_details_entity.dart';
import 'package:fitness_app/Features/food/domain/repo/food_repo_contract.dart';
import 'package:fitness_app/Features/food/domain/use_cases/meal_details_use_case.dart';
import 'package:fitness_app/core/base_response/base_response.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

import 'meal_details_use_case_test.mocks.dart';

@GenerateMocks([FoodRepoContract])
void main() {
  late MockFoodRepoContract mockRepo;
  late GetMealDetailsUseCase getMealDetailsUseCase;

  setUpAll(() {
    provideDummy<BaseResponse<MealDetailEntity>>(
      SuccessResponse(
        data: MealDetailEntity(
          id: '',
          name: '',
          category: '',
          area: '',
          instructions: '',
          image: '',
          ingredients: [],
        ),
      ),
    );
  });

  setUp(() {
    mockRepo = MockFoodRepoContract();
    getMealDetailsUseCase = GetMealDetailsUseCase(mockRepo);
  });

  group('Food Domain Use Cases Tests', () {
    test(
      'GetMealDetailsUseCase should call getMealDetails from repository',
      () async {
        // Arrange
        const tId = '52772';
        final tEntity = MealDetailEntity(
          id: tId,
          name: 'Test',
          category: '',
          area: '',
          instructions: '',
          image: '',
          ingredients: [],
        );
        final tResponse = SuccessResponse<MealDetailEntity>(data: tEntity);

        when(mockRepo.getMealDetails(tId)).thenAnswer((_) async => tResponse);

        // Act
        final result = await getMealDetailsUseCase.call(tId);

        // Assert
        expect(result, tResponse);
        verify(mockRepo.getMealDetails(tId)).called(1);
      },
    );
  });
}
