import 'package:http/http.dart' as http;
import 'dart:convert';
import '../../features/1_animes/models/anime_model.dart'; 

class AnimeService {
  final String _baseUrl = "https://api.jikan.moe/v4";

  Future<List<AnimeModel>> fetchTopAnime() async {
    String url = "$_baseUrl/top/anime";
    print("Memanggil API");

    try {
      final response = await http.get(Uri.parse(url));

      if (response.statusCode == 200) {
        final Map<String, dynamic> data = jsonDecode(response.body);
        if (data['data'] == null) return [];

        final List animeJsonList = data['data'];
        List<AnimeModel> animes = [];
        for (var animeJson in animeJsonList) {
          animes.add(AnimeModel.fromJson(animeJson));
        }
        return animes;
      } else {
        throw Exception("Gagal memuat data anime: ${response.statusCode}");
      }
    } catch (e) {
      throw Exception("Terjadi error saat memanggil API: $e");
    }
  }

  Future<List<AnimeModel>> searchAnime(String keyword) async {
    String url = "$_baseUrl/anime?q=${Uri.encodeComponent(keyword)}";
    print("Memanggil API");

    try {
      final response = await http.get(Uri.parse(url));

      if (response.statusCode == 200) {
        final Map<String, dynamic> data = jsonDecode(response.body);
        if (data['data'] == null) return [];

        final List animeJsonList = data['data'];
        List<AnimeModel> animes = [];
        for (var animeJson in animeJsonList) {
          animes.add(AnimeModel.fromJson(animeJson));
        }
        return animes;
      } else {
        throw Exception("Gagal mencari data anime: ${response.statusCode}");
      }
    } catch (e) {
      throw Exception("Terjadi error saat memanggil API: $e");
    }
  }
}