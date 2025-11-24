import 'package:flutter/material.dart';
import '../services/api_service.dart';
import '../models/meal_model.dart';
import '../models/meal_detail_model.dart';
import '../widgets/meal_card.dart';
import '../widgets/search_bar.dart';

class MealsScreen extends StatefulWidget {
  const MealsScreen({Key? key}) : super(key: key);

  @override
  State<MealsScreen> createState() => _MealsScreenState();
}

class _MealsScreenState extends State<MealsScreen> {
  final ApiService api = ApiService();
  List<Meal> meals = [];
  List<Meal> filtered = [];
  bool loading = true;
  String category = '';

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final args = ModalRoute.of(context)!.settings.arguments;
    if (args is String) {
      category = args;
      _load();
    }
  }

  Future<void> _load() async {
    setState(() => loading = true);
    try {
      final m = await api.getMealsByCategory(category);
      setState(() {
        meals = m;
        filtered = m;
      });
    } catch (e) {
      if (mounted) ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Error loading meals')));
    } finally {
      setState(() => loading = false);
    }
  }

  Future<void> _onSearch(String q) async {
    if (q.trim().isEmpty) {
      setState(() => filtered = meals);
      return;
    }
    setState(() => loading = true);
    try {
      final results = await api.searchMeals(q);
      // searchMeals returns MealDetail, convert to Meal (summary)
      setState(() {
        filtered = results
            .where((d) => d.name.toLowerCase().contains(q.toLowerCase()))
            .map((d) => Meal(id: d.id, name: d.name, image: d.image))
            .toList();
      });
    } catch (e) {
      setState(() => filtered = []);
    } finally {
      setState(() => loading = false);
    }
  }

  void _openDetailById(String id) async {
    setState(() => loading = true);
    try {
      final detail = await api.getMealDetail(id);
      if (detail != null) {
        Navigator.pushNamed(context, '/meal_detail', arguments: detail);
      }
    } catch (e) {
      if (mounted) ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Error loading details')));
    } finally {
      setState(() => loading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(category),
      ),
      body: loading
          ? const Center(child: CircularProgressIndicator())
          : Column(
        children: [
          SearchInput(onChanged: _onSearch, hint: 'Пребарувај јадења'),
          Expanded(
            child: GridView.builder(
              padding: const EdgeInsets.all(8),
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                childAspectRatio: 0.78,
                crossAxisSpacing: 8,
                mainAxisSpacing: 8,
              ),
              itemCount: filtered.length,
              itemBuilder: (context, idx) {
                final meal = filtered[idx];
                return MealCard(
                  meal: meal,
                  onTap: () => _openDetailById(meal.id),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
