import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import '../models/meal_model.dart';
import 'package:provider/provider.dart';
import '../providers/favorites_provider.dart';
import '../services/api_service.dart';

class MealCard extends StatelessWidget {
  final Meal meal;
  final VoidCallback onTap;

  const MealCard({required this.meal, required this.onTap, Key? key})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    final favProvider = Provider.of<FavoritesProvider>(context);
    final isFav = favProvider.isFavorite(meal.id);

    return InkWell(
      onTap: onTap,
      child: Card(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        elevation: 2,
        clipBehavior: Clip.antiAlias,
        child: Stack(
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Expanded(
                  child: CachedNetworkImage(
                    imageUrl: meal.image,
                    fit: BoxFit.cover,
                    placeholder: (c, u) =>
                    const Center(child: CircularProgressIndicator()),
                    errorWidget: (c, u, e) => const Icon(Icons.error),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text(
                    meal.name,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              ],
            ),
            Positioned(
              top: 6,
              right: 6,
              child: InkWell(
                onTap: () async {
                  final api = Provider.of<ApiService>(context, listen: false);
                  final detail = await api.getMealDetail(meal.id);
                  if (detail != null) {
                    favProvider.toggleFavorite(detail);
                  }
                },
                child: Icon(
                  isFav ? Icons.favorite : Icons.favorite_border,
                  color: Colors.red,
                  size: 28,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
