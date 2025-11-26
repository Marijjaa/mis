import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/category.dart';
import '../models/meal.dart';
import '../models/meal_detail.dart';

class ApiService {
  static const String baseUrl = 'https://www.themealdb.com/api/json/v1/1';

  Future<List<Category>> getCategories() async {
    final response = await http.get(Uri.parse('$baseUrl/categories.php'));

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      List<Category> categories = [];

      for (var item in data['categories']) {
        categories.add(Category.fromJson(item));
      }

      return categories;
    } else {
      throw Exception('Failed to load categories');
    }
  }

  Future<List<Meal>> getMealsByCategory(String category) async {
    final response = await http.get(
        Uri.parse('$baseUrl/filter.php?c=$category')
    );

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      List<Meal> meals = [];

      if (data['meals'] != null) {
        for (var item in data['meals']) {
          meals.add(Meal.fromJson(item));
        }
      }

      return meals;
    } else {
      throw Exception('Failed to load meals');
    }
  }

  Future<List<Meal>> searchMeals(String query) async {
    final response = await http.get(
        Uri.parse('$baseUrl/search.php?s=$query')
    );

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      List<Meal> meals = [];

      if (data['meals'] != null) {
        for (var item in data['meals']) {
          meals.add(Meal.fromJson(item));
        }
      }

      return meals;
    } else {
      throw Exception('Failed to search meals');
    }
  }

  Future<MealDetail> getMealDetail(String id) async {
    final response = await http.get(
        Uri.parse('$baseUrl/lookup.php?i=$id')
    );

    if (response.statusCode == 200) {
      final data = json.decode(response.body);

      if (data['meals'] != null && data['meals'].isNotEmpty) {
        return MealDetail.fromJson(data['meals'][0]);
      } else {
        throw Exception('Meal not found');
      }
    } else {
      throw Exception('Failed to load meal detail');
    }
  }

  Future<MealDetail> getRandomMeal() async {
    final response = await http.get(
        Uri.parse('$baseUrl/random.php')
    );

    if (response.statusCode == 200) {
      final data = json.decode(response.body);

      if (data['meals'] != null && data['meals'].isNotEmpty) {
        return MealDetail.fromJson(data['meals'][0]);
      } else {
        throw Exception('No random meal found');
      }
    } else {
      throw Exception('Failed to load random meal');
    }
  }
}