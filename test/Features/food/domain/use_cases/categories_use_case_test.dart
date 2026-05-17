import 'package:fitness_app/Features/food/domain/entities/category_entity.dart';
import 'package:fitness_app/Features/food/domain/repo/food_repo_contract.dart';
import 'package:fitness_app/Features/food/domain/use_cases/categories_use_case.dart';
import 'package:fitness_app/core/base_response/base_response.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

import 'categories_use_case_test.mocks.dart';

@GenerateMocks([FoodRepoContract])
void main() {
  late MockFoodRepoContract mockRepo;
  late GetCategoriesUseCase getCategoriesUseCase;

  setUpAll(() {
    provideDummy<BaseResponse<List<CategoryEntity>>>(SuccessResponse(data: []));
  });

  setUp(() {
    mockRepo = MockFoodRepoContract();
    getCategoriesUseCase = GetCategoriesUseCase(mockRepo);
  });

  group('Food Domain Use Cases Tests', () {
    test(
      'GetCategoriesUseCase should call getCategories from repository',
      () async {
        // Arrange
        final tResponse = SuccessResponse<List<CategoryEntity>>(data: []);
        when(mockRepo.getCategories()).thenAnswer((_) async => tResponse);

        // Act
        final result = await getCategoriesUseCase.call();

        // Assert
        expect(result, tResponse);
        verify(mockRepo.getCategories()).called(1);
        verifyNoMoreInteractions(mockRepo);
      },
    );
  });
}
