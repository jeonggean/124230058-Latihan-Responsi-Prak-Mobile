import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';
import '../../1_animes/models/anime_model.dart';
import '../../2_auth/services/auth_service.dart';

class FavoritesService {
  final AuthService _authService = AuthService();

  Future<String> _getCurrentUser() async {
    final user = await _authService.getCurrentUser();
    if (user == null) {
      throw Exception("User tidak login");
    }
    return user;
  }

  String _getFavoritesKey(String username) {
    return 'favorites_$username';
  }

  Future<List<String>> _getUserFavoritesList() async {
    final username = await _getCurrentUser();
    final prefs = await SharedPreferences.getInstance();

    return prefs.getStringList(_getFavoritesKey(username)) ?? [];
  }

  Future<List<AnimeModel>> getFavorites() async {
    final List<String> jsonStringList = await _getUserFavoritesList();
    return jsonStringList.map((jsonString) {
      final Map<String, dynamic> jsonMap = jsonDecode(jsonString);
      return AnimeModel.fromJson(jsonMap);
    }).toList();
  }

  Future<void> addFavorite(AnimeModel anime) async {
    final username = await _getCurrentUser();
    final prefs = await SharedPreferences.getInstance();
    final String key = _getFavoritesKey(username);

    final List<String> favoritesList = prefs.getStringList(key) ?? [];

    final String animeString = jsonEncode(anime.toJson());

    if (!favoritesList.any(
      (item) => jsonDecode(item)['malId'] == anime.malId,
    )) {
      favoritesList.add(animeString);
      await prefs.setStringList(key, favoritesList);
    }
  }

  Future<void> removeFavorite(AnimeModel anime) async {
    final username = await _getCurrentUser();
    final prefs = await SharedPreferences.getInstance();
    final String key = _getFavoritesKey(username);

    List<String> favoritesList = prefs.getStringList(key) ?? [];

    favoritesList.removeWhere((jsonString) {
      final Map<String, dynamic> animeMap = jsonDecode(jsonString);
      return animeMap['malId'] == anime.malId;
    });
    await prefs.setStringList(key, favoritesList);
  }

  Future<bool> isFavorite(AnimeModel anime) async {
    final List<String> favoritesList = await _getUserFavoritesList();

    return favoritesList.any((jsonString) {
      final Map<String, dynamic> animeMap = jsonDecode(jsonString);
      return animeMap['malId'] == anime.malId;
    });
  }
}
