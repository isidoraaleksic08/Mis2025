import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/category_model.dart';
import '../models/meal_model.dart';
import '../models/meal_detail_model.dart';

class ApiService {
  static const String base = 'https://www.themealdb.com/api/json/v1/1';

  Future<List<Category>> getCategories() async {
    final res = await http.get(Uri.parse('$base/categories.php'));
    if (res.statusCode == 200) {
      final j = json.decode(res.body);
      final List data = j['categories'] ?? [];
      return data.map((e) => Category.fromJson(e)).toList();
    }
    throw Exception('Failed to load categories');
  }

  Future<List<Meal>> getMealsByCategory(String category) async {
    final res = await http.get(Uri.parse('$base/filter.php?c=${Uri.encodeComponent(category)}'));
    if (res.statusCode == 200) {
      final j = json.decode(res.body);
      final List data = j['meals'] ?? [];
      return data.map((e) => Meal.fromJson(e)).toList();
    }
    throw Exception('Failed to load meals for category');
  }


  Future<List<MealDetail>> searchMeals(String query) async {
    final res = await http.get(Uri.parse('$base/search.php?s=${Uri.encodeComponent(query)}'));
    if (res.statusCode == 200) {
      final j = json.decode(res.body);
      final List? data = j['meals'];
      if (data == null) return [];
      return data.map((e) => MealDetail.fromJson(e)).toList();
    }
    throw Exception('Failed to search meals');
  }

  Future<MealDetail?> getMealDetail(String id) async {
    final res = await http.get(Uri.parse('$base/lookup.php?i=${Uri.encodeComponent(id)}'));
    if (res.statusCode == 200) {
      final j = json.decode(res.body);
      final List data = j['meals'] ?? [];
      if (data.isEmpty) return null;
      return MealDetail.fromJson(data.first);
    }
    throw Exception('Failed to load meal detail');
  }

  Future<MealDetail?> getRandomMeal() async {
    final res = await http.get(Uri.parse('$base/random.php'));
    if (res.statusCode == 200) {
      final j = json.decode(res.body);
      final List data = j['meals'] ?? [];
      if (data.isEmpty) return null;
      return MealDetail.fromJson(data.first);
    }
    throw Exception('Failed to load random meal');
  }
}
