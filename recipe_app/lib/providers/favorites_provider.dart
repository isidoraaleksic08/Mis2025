import 'package:flutter/material.dart';
import '../models/meal_detail_model.dart';

class FavoritesProvider extends ChangeNotifier {
  final List<MealDetail> _favorites = [];

  List<MealDetail> get favorites => List.unmodifiable(_favorites);

  bool isFavorite(String id) {
    return _favorites.any((m) => m.id == id);
  }

  void toggleFavorite(MealDetail meal) {
    final exists = isFavorite(meal.id);

    if (exists) {
      _favorites.removeWhere((m) => m.id == meal.id);
    } else {
      _favorites.add(meal);
    }
    notifyListeners();
  }
}
