import 'package:flutter/material.dart';
import '../models/anime_model.dart';
import '../../../core/services/api_service.dart'; 

//buat nampilinnya mau yang top atau yang search
enum AnimeListMode { top, search }

class AnimeController with ChangeNotifier {
  final AnimeService _animeService = AnimeService();

  List<AnimeModel> _topAnimes = [];
  List<AnimeModel> _searchedAnimes = [];

  AnimeListMode _currentMode = AnimeListMode.top;
  AnimeListMode get currentMode => _currentMode;

  bool _isLoading = false;
  bool get isLoading => _isLoading;

  String _errorMessage = '';
  String get errorMessage => _errorMessage;

  List<AnimeModel> get animesToShow {
    return _currentMode == AnimeListMode.top ? _topAnimes : _searchedAnimes;
  }

  void _setLoading(bool loading) {
    _isLoading = loading;
    notifyListeners();
  }

  void _setError(String message) {
    _errorMessage = message;
    _setLoading(false);
  }

  Future<void> fetchTopAnime() async {
    _setLoading(true);
    _currentMode = AnimeListMode.top;
    try {
      _topAnimes = await _animeService.fetchTopAnime();
      _errorMessage = '';
    } catch (e) {
      _setError(e.toString());
      _topAnimes = [];
    }
    _setLoading(false);
  }

  Future<void> searchAnime(String keyword) async {
    if (keyword.isEmpty) {
      fetchTopAnime();
      return;
    }
    _setLoading(true);
    _currentMode = AnimeListMode.search;
    try {
      _searchedAnimes = await _animeService.searchAnime(keyword);
      _errorMessage = '';
    } catch (e) {
      _setError(e.toString());
      _searchedAnimes = [];
    }
    _setLoading(false);
  }
}