import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:provider/provider.dart';

import '../models/meal_detail_model.dart';
import '../providers/favorites_provider.dart';
import 'package:recipe_app/widgets/youtube_player_flutter.dart';

class MealDetailScreen extends StatefulWidget {
  const MealDetailScreen({Key? key}) : super(key: key);

  @override
  State<MealDetailScreen> createState() => _MealDetailScreenState();
}

class _MealDetailScreenState extends State<MealDetailScreen> {
  @override
  Widget build(BuildContext context) {
    final meal = ModalRoute.of(context)!.settings.arguments as MealDetail;
    final favProvider = Provider.of<FavoritesProvider>(context);
    final isFav = favProvider.isFavorite(meal.id);

    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        title: Text(meal.name),
        backgroundColor: Colors.orange,
        foregroundColor: Colors.white,
        actions: [
          IconButton(
            icon: Icon(
              isFav ? Icons.favorite : Icons.favorite_border,
              color: Colors.white,
              size: 28,
            ),
            onPressed: () {
              favProvider.toggleFavorite(meal);
              setState(() {});
            },
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            CachedNetworkImage(
              imageUrl: meal.image,
              width: double.infinity,
              height: 220,
              fit: BoxFit.cover,
              placeholder: (c, u) => const Center(child: CircularProgressIndicator()),
              errorWidget: (c, u, e) => const Icon(Icons.error, color: Colors.white),
            ),
            const SizedBox(height: 12),
            Text(
              meal.name,
              style: const TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.bold,
                color: Colors.orange,
              ),
            ),
            const SizedBox(height: 16),
            const Text(
              'Ingredients',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.white),
            ),
            const SizedBox(height: 6),
            ...meal.ingredients.map(
                  (i) => Padding(
                padding: const EdgeInsets.symmetric(vertical: 2),
                child: Text(
                  "- $i",
                  style: const TextStyle(color: Colors.white70),
                ),
              ),
            ),
            const SizedBox(height: 20),
            const Text(
              'Instructions',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.white),
            ),
            const SizedBox(height: 6),
            Text(
              meal.instructions,
              style: const TextStyle(color: Colors.white70),
            ),
            const SizedBox(height: 20),
            if (meal.youtube != null && meal.youtube!.isNotEmpty)
              ElevatedButton.icon(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => YoutubeVideoScreen(videoUrl: meal.youtube!),
                    ),
                  );
                },
                icon: const Icon(Icons.play_circle_fill),
                label: const Text("Watch on YouTube"),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.orange,
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                ),
              ),
          ],
        ),
      ),
    );
  }
}
