import '../../1_animes/models/anime_model.dart';
import 'package:flutter/foundation.dart';
import '../services/favorites_service.dart';

class FavoritesController extends ChangeNotifier {
  final FavoritesService _service = FavoritesService();

  List<AnimeModel> _favorites = [];
  bool _isLoading = false;

  List<AnimeModel> get favorites => _favorites;
  bool get isLoading => _isLoading;

  void _notifyListenersIfNotDisposed() {
    if (!hasListeners) return;
    try {
      notifyListeners();
    } catch (e) {
      // Controller is disposed, ignore
    }
  }

  Future<void> loadFavorites() async {
    _isLoading = true;
    _notifyListenersIfNotDisposed();

    try {
      print('DEBUG CONTROLLER: Loading favorites...');
      _favorites = await _service.getFavorites();
      print('DEBUG CONTROLLER: Loaded ${_favorites.length} favorites');
      for (var fav in _favorites) {
        print('DEBUG CONTROLLER: - ${fav.title}');
      }
    } catch (e) {
      print('DEBUG CONTROLLER: Error loading favorites: $e');
      _favorites = [];
    }

    _isLoading = false;
    _notifyListenersIfNotDisposed();
  }
}