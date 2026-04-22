sealed class MealsEvent {}

class FetchCategoriesEvent extends MealsEvent {}

class FetchMealsByCategoryEvent extends MealsEvent {
  final String categoryName;
  FetchMealsByCategoryEvent(this.categoryName);
}

class FetchMealDetailsEvent extends MealsEvent {
  final String mealId;
  FetchMealDetailsEvent(this.mealId);
}
