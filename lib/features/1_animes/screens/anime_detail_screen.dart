import '/core/utils/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../3_favorites/services/favorites_service.dart';
import '../models/anime_model.dart';

class AnimeDetailScreen extends StatefulWidget {
  final AnimeModel anime;

  const AnimeDetailScreen({super.key, required this.anime});

  @override
  State<AnimeDetailScreen> createState() => _AnimeDetailScreenState();
}

class _AnimeDetailScreenState extends State<AnimeDetailScreen> {
  final FavoritesService _favoritesService = FavoritesService();
  late Future<bool> _favoriteFuture;

  @override
  void initState() {
    super.initState();
    _favoriteFuture = _favoritesService.isFavorite(widget.anime);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Column(
          children: [
            _buildHeader(),
            Expanded(child: _buildContent()),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Container(
      height: 160,
      decoration: const BoxDecoration(
        color: Colors.green,
        borderRadius: BorderRadius.only(
          bottomLeft: Radius.circular(40),
          bottomRight: Radius.circular(40),
        ),
      ),
      child: SafeArea(
        bottom: false,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
          child: Row(
            children: [
              IconButton(
                icon: const Icon(Icons.arrow_back, size: 26),
                color: Colors.white,
                onPressed: () => Navigator.pop(context),
              ),
              Expanded(
                child: Text(
                  widget.anime.title,
                  textAlign: TextAlign.center,
                  overflow: TextOverflow.ellipsis,
                  style: GoogleFonts.nunito(
                    fontSize: 20,
                    fontWeight: FontWeight.w600,
                    color: Colors.white,
                  ),
                ),
              ),
              FutureBuilder<bool>(
                future: _favoriteFuture,
                builder: (context, snapshot) {
                  final isFavorite = snapshot.data ?? false;
                  return IconButton(
                    icon: Icon(
                      isFavorite ? Icons.favorite : Icons.favorite_border,
                      size: 26,
                    ),
                    color: Colors.white,
                    onPressed: () async {
                      if (isFavorite) {
                        await _favoritesService.removeFavorite(widget.anime);
                      } else {
                        await _favoritesService.addFavorite(widget.anime);
                      }
                      setState(() {
                        _favoriteFuture = _favoritesService.isFavorite(
                          widget.anime,
                        );
                      });
                    },
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildContent() {
    return SingleChildScrollView(
      physics: const BouncingScrollPhysics(),
      padding: const EdgeInsets.symmetric(horizontal: 24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          const SizedBox(height: 20),
          ClipRRect(
            borderRadius: BorderRadius.circular(12),
            child: Image.network(
              widget.anime.imageUrl,
              height: 260,
              width: 180,
              fit: BoxFit.cover,
            ),
          ),
          const SizedBox(height: 20),
          Text(
            widget.anime.title,
            textAlign: TextAlign.center,
            style: GoogleFonts.nunito(
              fontSize: 27,
              fontWeight: FontWeight.bold,
              color: AppColors.kTextColor,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            "Score • ${widget.anime.score}",
            style: GoogleFonts.nunito(
              fontSize: 17,
              color: Colors.grey.shade700,
            ),
          ),
          const SizedBox(height: 16),
          Divider(color: Colors.grey.shade300),
          const SizedBox(height: 16),
          Align(
            alignment: Alignment.centerLeft,
            child: Text(
              "Synopsis",
              style: GoogleFonts.nunito(
                fontSize: 22,
                fontWeight: FontWeight.bold,
                color: AppColors.kTextColor,
              ),
            ),
          ),
          const SizedBox(height: 12),
          Text(
            widget.anime.synopsis.isEmpty
                ? "No synopsis available."
                : widget.anime.synopsis,
            textAlign: TextAlign.justify,
            style: GoogleFonts.nunito(
              fontSize: 16,
              height: 1.6,
              color: Colors.grey.shade800,
            ),
          ),
          const SizedBox(height: 50),
        ],
      ),
    );
  }
}
