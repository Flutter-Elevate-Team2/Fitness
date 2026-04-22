import 'package:fitness_app/Features/food/domain/entities/category_entity.dart';
import 'package:fitness_app/Features/food/domain/entities/meal_details_entity.dart';
import 'package:fitness_app/Features/food/domain/entities/meals_by_category_entity.dart';
import 'package:fitness_app/Features/food/domain/use_cases/categories_use_case.dart';
import 'package:fitness_app/Features/food/domain/use_cases/meal_details_use_case.dart';
import 'package:fitness_app/Features/food/domain/use_cases/meals_by_category_use_case.dart';
import 'package:fitness_app/Features/food/presentation/view_models/meals_event.dart';
import 'package:fitness_app/Features/food/presentation/view_models/meals_state.dart';
import 'package:fitness_app/core/base_response/base_response.dart';
import 'package:fitness_app/core/base_state/base_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';

@injectable
class MealsViewModel extends Cubit<MealsState> {
  final GetCategoriesUseCase _categoriesUseCase;
  final GetMealsByCategoryUseCase _mealsByCategoryUseCase;
  final GetMealDetailsUseCase _mealDetailsUseCase;

  MealsViewModel(
    this._categoriesUseCase,
    this._mealsByCategoryUseCase,
    this._mealDetailsUseCase,
  ) : super(const MealsState());

  void doIntent(MealsEvent event) {
    switch (event) {
      case FetchCategoriesEvent():
        _getCategories();
        break;
      case FetchMealsByCategoryEvent():
        _getMealsByCategory(event.categoryName);
        break;
      case FetchMealDetailsEvent():
        _getMealDetails(event.mealId);
        break;
    }
  }

  Future<void> _getCategories() async {
    emit(state.copyWith(categoriesState: const BaseState(isLoading: true)));

    final result = await _categoriesUseCase();

    if (result is SuccessResponse<List<CategoryEntity>>) {
      emit(
        state.copyWith(
          categoriesState: BaseState(isLoading: false, data: result.data),
        ),
      );
    } else if (result is ErrorResponse<List<CategoryEntity>>) {
      emit(
        state.copyWith(
          categoriesState: BaseState(
            isLoading: false,
            errorMessage: result.errorMessage,
          ),
        ),
      );
    }
  }

  Future<void> _getMealsByCategory(String categoryName) async {
    emit(
      state.copyWith(mealsByCategoryState: const BaseState(isLoading: true)),
    );

    final result = await _mealsByCategoryUseCase(categoryName);

    if (result is SuccessResponse<List<MealsByCategoryEntity>>) {
      emit(
        state.copyWith(
          mealsByCategoryState: BaseState(isLoading: false, data: result.data),
        ),
      );
    } else if (result is ErrorResponse<List<MealsByCategoryEntity>>) {
      emit(
        state.copyWith(
          mealsByCategoryState: BaseState(
            isLoading: false,
            errorMessage: result.errorMessage,
          ),
        ),
      );
    }
  }

  Future<void> _getMealDetails(String mealId) async {
    emit(state.copyWith(mealDetailsState: const BaseState(isLoading: true)));

    final result = await _mealDetailsUseCase(mealId);

    if (result is SuccessResponse<MealDetailEntity>) {
      emit(
        state.copyWith(
          mealDetailsState: BaseState(isLoading: false, data: result.data),
        ),
      );
    } else if (result is ErrorResponse<MealDetailEntity>) {
      emit(
        state.copyWith(
          mealDetailsState: BaseState(
            isLoading: false,
            errorMessage: result.errorMessage,
          ),
        ),
      );
    }
  }
}
