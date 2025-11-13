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
  late bool _isFavorite = false;

  @override
  void initState() {
    super.initState();
    _checkFavoriteStatus();
  }

  void _checkFavoriteStatus() async {
    _isFavorite = await _favoritesService.isFavorite(widget.anime);
    if (mounted) setState(() {});
  }

  void _toggleFavorite() async {
    if (_isFavorite) {
      await _favoritesService.removeFavorite(widget.anime);
    } else {
      await _favoritesService.addFavorite(widget.anime);
    }
    if (mounted) setState(() => _isFavorite = !_isFavorite);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Column(
        children: [
          _buildPurpleHeader(),
          Expanded(child: _buildContent()),
        ],
      ),
    );
  }

  Widget _buildPurpleHeader() {
    return Container(
      width: double.infinity,
      height: 240,
      decoration: BoxDecoration(
        color: Colors.purple.shade400,
        borderRadius: const BorderRadius.only(
          bottomLeft: Radius.circular(32),
          bottomRight: Radius.circular(32),
        ),
      ),
      child: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              CircleAvatar(
                backgroundColor: Colors.white,
                child: IconButton(
                  icon: const Icon(Icons.arrow_back, color: Colors.black),
                  onPressed: () => Navigator.pop(context),
                ),
              ),
              CircleAvatar(
                backgroundColor: Colors.white,
                child: IconButton(
                  icon: Icon(
                    _isFavorite ? Icons.bookmark : Icons.bookmark_border,
                    color: Colors.purple.shade500,
                  ),
                  onPressed: _toggleFavorite,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildContent() {
    return SingleChildScrollView(
      padding: const EdgeInsets.symmetric(horizontal: 24),
      child: Column(
        children: [
          Transform.translate(
            offset: const Offset(0, -80),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(12),
              child: Image.network(
                widget.anime.imageUrl,
                height: 250,
                width: 180,
                fit: BoxFit.cover,
              ),
            ),
          ),
          const SizedBox(height: -40),
          Text(
            widget.anime.title,
            textAlign: TextAlign.center,
            style: GoogleFonts.nunito(
              fontSize: 26,
              fontWeight: FontWeight.bold,
              color: AppColors.kTextColor,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            "⭐ ${widget.anime.score}",
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
          const SizedBox(height: 40),
        ],
      ),
    );
  }
}
