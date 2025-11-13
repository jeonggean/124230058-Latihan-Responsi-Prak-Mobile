import 'package:hive_flutter/hive_flutter.dart';
import '../../1_animes/models/anime_model.dart';
import '../../2_auth/services/auth_service.dart';

class FavoritesService {
  final Box _favoritesBox = Hive.box('favorites');
  final AuthService _authService = AuthService();

  String _getCurrentUser() {
    final user = _authService.getCurrentUser();
    if (user == null) {
      throw Exception("User tidak login");
    }
    return user;
  }

  List<Map> _getUserFavorites(String username) {
    final dynamicList = _favoritesBox.get(username) ?? [];
    print(
      'DEBUG FAVORITES SERVICE: Getting raw favorites for $username from Hive',
    );
    print('DEBUG FAVORITES SERVICE: Raw data type: ${dynamicList.runtimeType}');
    print('DEBUG FAVORITES SERVICE: Raw data: $dynamicList');
    final result = List<Map>.from(dynamicList);
    print(
      'DEBUG FAVORITES SERVICE: Converted to List<Map>, count: ${result.length}',
    );
    return result;
  }

  List<AnimeModel> getFavorites() {
    final user = _getCurrentUser();
    final favListMap = _getUserFavorites(user);

    print('DEBUG FAVORITES: Getting favorites for user $user');
    print('DEBUG FAVORITES: Found ${favListMap.length} favorites');

    return favListMap
        .map((json) => AnimeModel.fromJson(json as Map<String, dynamic>))
        .toList();
  }

  Future<void> addFavorite(AnimeModel event) async {
    final user = _getCurrentUser();
    print('DEBUG FAVORITES: Current user: $user');

    final favList = _getUserFavorites(user);
    print(
      'DEBUG FAVORITES: Current favorites count before add: ${favList.length}',
    );

    favList.add(event.toJson());
    print('DEBUG FAVORITES: Favorites count after add: ${favList.length}');

    await _favoritesBox.put(user, favList);
    print('DEBUG FAVORITES: Saved to Hive for user: $user');

    // Verify saved data
    final verify = _favoritesBox.get(user);
    print(
      'DEBUG FAVORITES: Verification - data in Hive: ${verify?.length ?? 0} items',
    );

    print('DEBUG FAVORITES: Added ${event.title} for user $user');
    print('DEBUG FAVORITES: Total favorites now: ${favList.length}');
  }

  Future<void> removeFavorite(AnimeModel event) async {
    final user = _getCurrentUser();
    final favList = _getUserFavorites(user);

    favList.removeWhere((item) => item['id'] == event.malId);
    await _favoritesBox.put(user, favList);
  }

  bool isFavorite(AnimeModel event) {
    try {
      final user = _getCurrentUser();
      final favList = _getUserFavorites(user);
      return favList.any((item) => item['id'] == event.malId);
    } catch (e) {
      return false;
    }
  }
}
