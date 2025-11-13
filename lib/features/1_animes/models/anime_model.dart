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

  factory AnimeModel.fromJson(Map<String, dynamic> json) {
    return AnimeModel(
      malId: json['mal_id'] ?? 0,
      title: json['title'] ?? "-",
      imageUrl: json['images']['jpg']['image_url'] ?? "",
      score: (json['score'] ?? 0).toDouble(),
      synopsis: json['synopsis'] ?? "-",
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'mal_id': malId,
      'title': title,
      'image_url': imageUrl,
      'score': score,
      'synopsis': synopsis,
    };
  }
}
