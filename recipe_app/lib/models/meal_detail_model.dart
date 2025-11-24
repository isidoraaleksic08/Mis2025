class MealDetail {
  final String id;
  final String name;
  final String instructions;
  final String image;
  final String? youtube;
  final List<String> ingredients; // each item: "ingredient — measure"

  MealDetail({
    required this.id,
    required this.name,
    required this.instructions,
    required this.image,
    required this.ingredients,
    this.youtube,
  });

  factory MealDetail.fromJson(Map<String, dynamic> json) {
    final List<String> ingredients = [];

    // TheMealDB provides up to 20 ingredient/measure pairs
    for (int i = 1; i <= 20; i++) {
      final ingKey = 'strIngredient$i';
      final measureKey = 'strMeasure$i';

      final ingVal = json[ingKey];
      final measureVal = json[measureKey];

      if (ingVal != null) {
        final ing = ingVal.toString().trim();
        if (ing.isNotEmpty) {
          final measure = (measureVal ?? '').toString().trim();
          // Format: "Ingredient — Measure" (if measure empty, just ingredient)
          final entry = measure.isNotEmpty ? '$ing — $measure' : ing;
          ingredients.add(entry);
        }
      }
    }

    return MealDetail(
      id: json['idMeal']?.toString() ?? '',
      name: json['strMeal']?.toString() ?? '',
      instructions: json['strInstructions']?.toString() ?? '',
      image: json['strMealThumb']?.toString() ?? '',
      youtube: (json['strYoutube'] != null && json['strYoutube'].toString().trim().isNotEmpty)
          ? json['strYoutube'].toString()
          : null,
      ingredients: ingredients,
    );
  }
}
