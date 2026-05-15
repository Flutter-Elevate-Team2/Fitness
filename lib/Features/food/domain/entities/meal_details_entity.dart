class MealDetailEntity {
  final String id;
  final String name;
  final String category;
  final String area;
  final String instructions;
  final String image;
  final String? youtubeUrl;
  final List<IngredientEntity> ingredients;

  const MealDetailEntity({
    required this.id,
    required this.name,
    required this.category,
    required this.area,
    required this.instructions,
    required this.image,
    this.youtubeUrl,
    required this.ingredients,
  });
}

class IngredientEntity {
  final String name;
  final String measure;

  const IngredientEntity({
    required this.name,
    required this.measure,
  });
}