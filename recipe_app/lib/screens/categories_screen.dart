import 'package:flutter/material.dart';
import '../services/api_service.dart';
import '../models/category_model.dart';
import '../widgets/category_card.dart';
import '../widgets/search_bar.dart';

class CategoriesScreen extends StatefulWidget {
  const CategoriesScreen({Key? key}) : super(key: key);

  @override
  State<CategoriesScreen> createState() => _CategoriesScreenState();
}

class _CategoriesScreenState extends State<CategoriesScreen> {
  final ApiService api = ApiService();
  List<Category> categories = [];
  List<Category> filtered = [];
  bool loading = true;

  @override
  void initState() {
    super.initState();
    _load();
  }

  Future<void> _load() async {
    setState(() => loading = true);
    try {
      final cats = await api.getCategories();
      setState(() {
        categories = cats;
        filtered = cats;
      });
    } finally {
      setState(() => loading = false);
    }
  }

  void _onSearch(String q) {
    setState(() {
      filtered = categories
          .where((c) => c.name.toLowerCase().contains(q.toLowerCase()))
          .toList();
    });
  }

  void _openRandom() async {
    final meal = await api.getRandomMeal();
    if (meal != null) {
      Navigator.pushNamed(context, '/meal_detail', arguments: meal);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Категории'),
        actions: [
          IconButton(
            icon: const Icon(Icons.favorite),
            tooltip: 'Омилени рецепти',
            onPressed: () {
              Navigator.pushNamed(context, '/favorites');
            },
          ),
          IconButton(
            icon: const Icon(Icons.shuffle),
            tooltip: 'Random meal',
            onPressed: _openRandom,
          ),
        ],
      ),
      body: loading
          ? const Center(child: CircularProgressIndicator())
          : Column(
        children: [
          SearchInput(
              onChanged: _onSearch, hint: 'Пребарувај категории'),
          Expanded(
            child: GridView.builder(
              padding: const EdgeInsets.all(8),
              gridDelegate:
              const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                childAspectRatio: 0.78,
                crossAxisSpacing: 8,
                mainAxisSpacing: 8,
              ),
              itemCount: filtered.length,
              itemBuilder: (context, idx) {
                final c = filtered[idx];
                return CategoryCard(
                  category: c,
                  onTap: () {
                    Navigator.pushNamed(context, '/meals',
                        arguments: c.name);
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
