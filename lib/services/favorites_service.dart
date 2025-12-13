import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';

class FavoritesService {
  static const String _favoritesKey = 'favorite_meals';

  Future<void> addFavorite(String mealId, String mealName, String mealThumb) async {
    final prefs = await SharedPreferences.getInstance();
    final favorites = await getFavorites();

    favorites[mealId] = {
      'mealId': mealId,
      'mealName': mealName,
      'mealThumb': mealThumb,
      'addedAt': DateTime.now().toIso8601String(),
    };

    await prefs.setString(_favoritesKey, json.encode(favorites));
  }

  Future<void> removeFavorite(String mealId) async {
    final prefs = await SharedPreferences.getInstance();
    final favorites = await getFavorites();

    favorites.remove(mealId);

    await prefs.setString(_favoritesKey, json.encode(favorites));
  }

  Future<bool> isFavorite(String mealId) async {
    final favorites = await getFavorites();
    return favorites.containsKey(mealId);
  }

  Future<Map<String, dynamic>> getFavorites() async {
    final prefs = await SharedPreferences.getInstance();
    final favoritesString = prefs.getString(_favoritesKey);

    if (favoritesString == null) {
      return {};
    }

    return Map<String, dynamic>.from(json.decode(favoritesString));
  }

  Future<List<Map<String, dynamic>>> getFavoritesList() async {
    final favorites = await getFavorites();
    final list = favorites.values.toList();

    list.sort((a, b) {
      final dateA = DateTime.parse(a['addedAt']);
      final dateB = DateTime.parse(b['addedAt']);
      return dateB.compareTo(dateA);
    });

    return List<Map<String, dynamic>>.from(list);
  }

  Future<void> clearAllFavorites() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_favoritesKey);
  }
}