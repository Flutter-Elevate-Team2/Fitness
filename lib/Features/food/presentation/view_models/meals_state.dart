import 'package:equatable/equatable.dart';
import 'package:fitness_app/Features/food/domain/entities/category_entity.dart';
import 'package:fitness_app/Features/food/domain/entities/meal_details_entity.dart';
import 'package:fitness_app/Features/food/domain/entities/meals_by_category_entity.dart';
import 'package:fitness_app/core/base_state/base_state.dart';

class MealsState extends Equatable {
  final BaseState<List<CategoryEntity>> categoriesState;
  final BaseState<List<MealsByCategoryEntity>> mealsByCategoryState;
  final BaseState<MealDetailEntity> mealDetailsState;

  const MealsState({
    this.categoriesState = const BaseState(),
    this.mealsByCategoryState = const BaseState(),
    this.mealDetailsState = const BaseState(),
  });

  MealsState copyWith({
    BaseState<List<CategoryEntity>>? categoriesState,
    BaseState<List<MealsByCategoryEntity>>? mealsByCategoryState,
    BaseState<MealDetailEntity>? mealDetailsState,
  }) {
    return MealsState(
      categoriesState: categoriesState ?? this.categoriesState,
      mealsByCategoryState: mealsByCategoryState ?? this.mealsByCategoryState,
      mealDetailsState: mealDetailsState ?? this.mealDetailsState,
    );
  }

  @override
  List<Object?> get props => [
    categoriesState,
    mealsByCategoryState,
    mealDetailsState,
  ];
}
