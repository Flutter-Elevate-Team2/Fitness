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

class MealsNavArgs {
  final String selectedCategory;
  final List<String> categories;

  const MealsNavArgs({
    required this.selectedCategory,
    required this.categories,
  });
}
