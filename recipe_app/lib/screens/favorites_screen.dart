import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/meal_model.dart';
import '../providers/favorites_provider.dart';
import '../widgets/meal_card.dart';
import '../models/meal_detail_model.dart';
import 'meal_detail_screen.dart';

class FavoritesScreen extends StatelessWidget {
  const FavoritesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final favorites = context.watch<FavoritesProvider>().favorites;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Омилени рецепти'),
      ),
      body: favorites.isEmpty
          ? const Center(child: Text("Немате омилени рецепти"))
          : GridView.builder(
        padding: const EdgeInsets.all(8),
        itemCount: favorites.length,
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          childAspectRatio: 0.75,
          crossAxisSpacing: 8,
          mainAxisSpacing: 8,
        ),
        itemBuilder: (context, idx) {
          final meal = favorites[idx];
          return MealCard(
            meal: meal.toMealCardModel(),
            onTap: () {
              Navigator.pushNamed(
                context,
                '/meal_detail',
                arguments: meal,
              );
            },
          );
        },
      ),
    );
  }
}


extension DetailToCard on MealDetail {
  Meal toMealCardModel() {
    return Meal(
      id: id,
      name: name,
      image: image,
    );
  }
}
