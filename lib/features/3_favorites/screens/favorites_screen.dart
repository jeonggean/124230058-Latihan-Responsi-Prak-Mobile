import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:eventfinder/core/utils/app_colors.dart'; // Sesuaikan path

import '../../1_animes/models/anime_model.dart';
import '../../1_animes/screens/anime_detail_screen.dart';
import '../controllers/favorites_controller.dart';

class FavoritesScreen extends StatefulWidget {
  const FavoritesScreen({super.key});

  @override
  State<FavoritesScreen> createState() => _FavoritesScreenState();
}

class _FavoritesScreenState extends State<FavoritesScreen> {
  late final FavoritesController _controller;

  @override
  void initState() {
    super.initState();
    _controller = FavoritesController();
    _controller.addListener(_onStateChanged);
    _loadData();
  }

  void _onStateChanged() {
    if (mounted) {
      setState(() {});
    }
  }

  @override
  void dispose() {
    _controller.removeListener(_onStateChanged);
    _controller.dispose();
    super.dispose();
  }

  Future<void> _loadData() async {
    await _controller.loadFavorites();
  }

  void _navigateToDetail(AnimeModel anime) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => AnimeDetailScreen(anime: anime),
      ),
    ).then((_) {
      // PENTING: Muat ulang data saat kembali dari detail
      _loadData();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Favorit Saya',
          style: GoogleFonts.nunito(fontWeight: FontWeight.bold),
        ),
      ),
      body: RefreshIndicator(
        onRefresh: _loadData,
        child: _buildBody(),
      ),
    );
  }

  Widget _buildBody() {
    if (_controller.isLoading) {
      return Center(
          child: CircularProgressIndicator(
              color: Theme.of(context).colorScheme.primary));
    }

    if (_controller.favorites.isEmpty) {
      return Center(
        child: Text(
          'Belum ada anime favorit.',
          style: GoogleFonts.nunito(
            fontSize: 16,
            color: AppColors.kSecondaryTextColor,
          ),
        ),
      );
    }

    return ListView.separated(
      padding: const EdgeInsets.all(16.0),
      itemCount: _controller.favorites.length,
      separatorBuilder: (context, index) => const SizedBox(height: 16),
      itemBuilder: (context, index) {
        final anime = _controller.favorites[index];
        return _buildAnimeCard(anime);
      },
    );
  }

  Widget _buildAnimeCard(AnimeModel anime) {
    // Card ini saya samakan dengan di anime_list_screen
    return InkWell(
      onTap: () => _navigateToDetail(anime),
      child: Container(
        padding: const EdgeInsets.all(12.0),
        decoration: BoxDecoration(
          color: Theme.of(context).cardColor,
          borderRadius: BorderRadius.circular(16.0),
        ),
        child: Row(
          children: [
            Hero(
              tag: 'anime-poster-${anime.malId}',
              child: ClipRRect(
                borderRadius: BorderRadius.circular(12.0),
                child: Image.network(
                  anime.imageUrl,
                  height: 80,
                  width: 80,
                  fit: BoxFit.cover,
                  errorBuilder: (context, error, stackTrace) => Container(
                    height: 80,
                    width: 80,
                    color: AppColors.kBackgroundColor,
                    child: const Icon(
                      Icons.broken_image,
                      size: 40,
                      color: AppColors.kSecondaryTextColor,
                    ),
                  ),
                ),
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    anime.title,
                    style: GoogleFonts.nunito(
                      fontWeight: FontWeight.bold,
                      fontSize: 17,
                      color: AppColors.kTextColor,
                    ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 8),
                  Row(
                    children: [
                      Icon(Icons.star, size: 14, color: Colors.amber),
                      const SizedBox(width: 6),
                      Text(
                        "Score: ${anime.score.toString()}",
                        style: TextStyle(
                          fontSize: 14,
                          color: AppColors.kSecondaryTextColor,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}