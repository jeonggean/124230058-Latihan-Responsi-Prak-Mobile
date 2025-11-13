import 'dart:convert';

class AnimeModel {
  final int malId;
  final String title;
  final String imageUrl;
  final double score;
  final String synopsis;

  AnimeModel({
    required this.malId,
    required this.title,
    required this.imageUrl,
    required this.score,
    required this.synopsis,
  });

  // buat nyimpen di SharedPreferences (Favorit)
  Map<String, dynamic> toJson() {
    return {
      'malId': malId,
      'title': title,
      'imageUrl': imageUrl,
      'score': score,
      'synopsis': synopsis,
    };
  }

  factory AnimeModel.fromJson(Map<String, dynamic> json) {
    return AnimeModel(
      malId: json['malId']?? "-",
      title: json['title']?? "-",
      imageUrl: json['imageUrl'],
      score: (json['score'] as num).toDouble(),
      synopsis: json['synopsis']?? "-",
    );
  }

  String toJsonString() => json.encode(toJson());
  factory AnimeModel.fromJsonString(String jsonString) {
    return AnimeModel.fromJson(json.decode(jsonString));
  }
}
