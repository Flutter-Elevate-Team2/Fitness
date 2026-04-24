import 'package:bloc_test/bloc_test.dart';
import 'package:fitness_app/Features/food/domain/entities/category_entity.dart';
import 'package:fitness_app/Features/food/domain/entities/meal_details_entity.dart';
import 'package:fitness_app/Features/food/domain/entities/meals_by_category_entity.dart';
import 'package:fitness_app/Features/food/domain/use_cases/categories_use_case.dart';
import 'package:fitness_app/Features/food/domain/use_cases/meal_details_use_case.dart';
import 'package:fitness_app/Features/food/domain/use_cases/meals_by_category_use_case.dart';
import 'package:fitness_app/Features/food/presentation/view_models/meals_event.dart';
import 'package:fitness_app/Features/food/presentation/view_models/meals_state.dart';
import 'package:fitness_app/Features/food/presentation/view_models/meals_view_model.dart';
import 'package:fitness_app/core/base_response/base_response.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

import 'meals_view_model_test.mocks.dart';

@GenerateMocks([
  GetCategoriesUseCase,
  GetMealsByCategoryUseCase,
  GetMealDetailsUseCase,
])
void main() {
  late MealsViewModel viewModel;
  late MockGetCategoriesUseCase mockCategoriesUseCase;
  late MockGetMealsByCategoryUseCase mockMealsByCategoryUseCase;
  late MockGetMealDetailsUseCase mockMealDetailsUseCase;

  setUpAll(() {
    provideDummy<BaseResponse<List<CategoryEntity>>>(SuccessResponse(data: []));
    provideDummy<BaseResponse<List<MealsByCategoryEntity>>>(
      SuccessResponse(data: []),
    );
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
    mockCategoriesUseCase = MockGetCategoriesUseCase();
    mockMealsByCategoryUseCase = MockGetMealsByCategoryUseCase();
    mockMealDetailsUseCase = MockGetMealDetailsUseCase();

    viewModel = MealsViewModel(
      mockCategoriesUseCase,
      mockMealsByCategoryUseCase,
      mockMealDetailsUseCase,
    );
  });

  group('MealsViewModel Tests', () {
    blocTest<MealsViewModel, MealsState>(
      'emits [loading, success] when FetchCategoriesEvent is added',
      build: () {
        when(mockCategoriesUseCase()).thenAnswer(
          (_) async => SuccessResponse<List<CategoryEntity>>(data: []),
        );
        return viewModel;
      },
      act: (cubit) => cubit.doIntent(FetchCategoriesEvent()),
      expect: () => [
        isA<MealsState>().having(
          (s) => s.categoriesState.isLoading,
          'loading',
          true,
        ),
        isA<MealsState>()
            .having((s) => s.categoriesState.isLoading, 'loading', false)
            .having(
              (s) => s.categoriesState.data,
              'data',
              isA<List<CategoryEntity>>(),
            ),
      ],
    );

    blocTest<MealsViewModel, MealsState>(
      'emits [loading, error] when FetchCategoriesEvent fails',
      build: () {
        when(mockCategoriesUseCase()).thenAnswer(
          (_) async =>
              ErrorResponse<List<CategoryEntity>>(errorMessage: 'Error'),
        );
        return viewModel;
      },
      act: (cubit) => cubit.doIntent(FetchCategoriesEvent()),
      expect: () => [
        isA<MealsState>().having(
          (s) => s.categoriesState.isLoading,
          'loading',
          true,
        ),
        isA<MealsState>().having(
          (s) => s.categoriesState.errorMessage,
          'error',
          'Error',
        ),
      ],
    );

    blocTest<MealsViewModel, MealsState>(
      'emits [loading, success] when FetchMealsByCategoryEvent is added',
      build: () {
        when(mockMealsByCategoryUseCase(any)).thenAnswer(
          (_) async => SuccessResponse<List<MealsByCategoryEntity>>(data: []),
        );
        return viewModel;
      },
      act: (cubit) => cubit.doIntent(FetchMealsByCategoryEvent('Beef')),
      expect: () => [
        isA<MealsState>().having(
          (s) => s.mealsByCategoryState.isLoading,
          'loading',
          true,
        ),
        isA<MealsState>().having(
          (s) => s.mealsByCategoryState.data,
          'data',
          isA<List<MealsByCategoryEntity>>(),
        ),
      ],
    );

    blocTest<MealsViewModel, MealsState>(
      'emits [loading, error] when FetchMealsByCategoryEvent fails',
      build: () {
        when(mockMealsByCategoryUseCase(any)).thenAnswer(
          (_) async => ErrorResponse<List<MealsByCategoryEntity>>(
            errorMessage: 'Network Error',
          ),
        );
        return viewModel;
      },
      act: (cubit) => cubit.doIntent(FetchMealsByCategoryEvent('Beef')),
      expect: () => [
        isA<MealsState>().having(
          (s) => s.mealsByCategoryState.isLoading,
          'loading',
          true,
        ),
        isA<MealsState>().having(
          (s) => s.mealsByCategoryState.errorMessage,
          'error',
          'Network Error',
        ),
      ],
    );

    blocTest<MealsViewModel, MealsState>(
      'emits [loading details, success details, loading similar, success similar] when FetchMealDetailsEvent succeeds',
      build: () {
        final tEntity = MealDetailEntity(
          id: '1',
          name: 'Test',
          category: 'Beef',
          area: '',
          instructions: '',
          image: '',
          ingredients: [],
        );

        when(mockMealDetailsUseCase(any)).thenAnswer(
              (_) async => SuccessResponse<MealDetailEntity>(data: tEntity),
        );

        when(mockMealsByCategoryUseCase('Beef')).thenAnswer(
              (_) async => SuccessResponse<List<MealsByCategoryEntity>>(data: []),
        );

        return viewModel;
      },
      act: (cubit) => cubit.doIntent(FetchMealDetailsEvent('52772')),
      expect: () => [
         isA<MealsState>().having((s) => s.mealDetailsState.isLoading, 'meal loading', true),

         isA<MealsState>()
            .having((s) => s.mealDetailsState.isLoading, 'meal success', false)
            .having((s) => s.mealDetailsState.data?.id, 'meal id', '1'),

         isA<MealsState>()
            .having((s) => s.mealsByCategoryState.isLoading, 'similar loading', true),

         isA<MealsState>()
            .having((s) => s.mealsByCategoryState.isLoading, 'similar success', false)
            .having((s) => s.mealsByCategoryState.data, 'similar data', []),
      ],
      verify: (_) {
        verify(mockMealDetailsUseCase('52772')).called(1);
        verify(mockMealsByCategoryUseCase('Beef')).called(1);
      },
    );

    blocTest<MealsViewModel, MealsState>(
      'emits [loading, error] when FetchMealDetailsEvent fails',
      build: () {
        when(mockMealDetailsUseCase(any)).thenAnswer(
          (_) async =>
              ErrorResponse<MealDetailEntity>(errorMessage: 'Not Found'),
        );
        return viewModel;
      },
      act: (cubit) => cubit.doIntent(FetchMealDetailsEvent('123')),
      expect: () => [
        isA<MealsState>().having(
          (s) => s.mealDetailsState.isLoading,
          'loading',
          true,
        ),
        isA<MealsState>().having(
          (s) => s.mealDetailsState.errorMessage,
          'error',
          'Not Found',
        ),
      ],
    );
  });
}
