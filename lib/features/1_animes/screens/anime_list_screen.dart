import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../controllers/anime_controller.dart';
import '../models/anime_model.dart';
import '../../../core/utils/app_colors.dart';
import 'anime_detail_screen.dart';

class AnimeListScreen extends StatefulWidget {
  const AnimeListScreen({super.key});

  @override
  State<AnimeListScreen> createState() => _AnimeListScreenState();
}

class _AnimeListScreenState extends State<AnimeListScreen> {
  late final AnimeController _controller;
  final TextEditingController _searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _controller = AnimeController();
    _controller.addListener(() {
      if (mounted) setState(() {});
    });
    _controller.fetchTopAnime();
  }

  @override
  void dispose() {
    _controller.dispose();
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            _buildHeader(),
            _buildSearchBar(),
            Expanded(child: _buildAnimeList(_controller.animesToShow)),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(24, 16, 24, 8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          
          Column(
            
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Halo, User!',
                style: GoogleFonts.nunito(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: AppColors.kTextColor,
                ),
              ),
              Text(
                'Temukan anime favoritmu',
                style: GoogleFonts.nunito(
                  fontSize: 16,
                  color: AppColors.kSecondaryTextColor,
                ),
              ),
            ],
          ),
          CircleAvatar(
            backgroundColor: Theme.of(context).cardColor,
            child: Icon(Icons.notifications_outlined,
                color: AppColors.kSecondaryTextColor),
          ),
        ],
      ),
    );
  }

  Widget _buildSearchBar() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
      child: TextField(
        controller: _searchController,
        style: TextStyle(color: AppColors.kTextColor),
        decoration: InputDecoration(
          hintText: 'Cari anime...',
          hintStyle: TextStyle(color: AppColors.kSecondaryTextColor),
          prefixIcon: Icon(Icons.search, color: AppColors.kSecondaryTextColor),
          suffixIcon: _searchController.text.isNotEmpty
              ? IconButton(
                  icon: Icon(Icons.clear, color: AppColors.kSecondaryTextColor),
                  onPressed: () {
                    _searchController.clear();
                    _controller.fetchTopAnime();
                  },
                )
              : null,
          filled: true,
          fillColor: Theme.of(context).cardColor,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(15),
            borderSide: BorderSide.none,
          ),
          contentPadding: const EdgeInsets.symmetric(vertical: 16),
        ),
        onSubmitted: (text) {
          if (text.isEmpty) {
            _controller.fetchTopAnime();
          } else {
            _controller.searchAnime(text);
          }
        },
      ),
    );
  }

  Widget _buildAnimeList(List<AnimeModel> list) {
    if (_controller.isLoading) {
      return Center(
        child: CircularProgressIndicator(
          color: Theme.of(context).colorScheme.primary,
        ),
      );
    }

    if (_controller.errorMessage.isNotEmpty && list.isEmpty) {
      return Center(
        child: Text(
          "Gagal memuat data.",
          style: TextStyle(color: Colors.red.shade700, fontSize: 16),
        ),
      );
    }

    if (list.isEmpty) {
      return Center(
        child: Text(
          "Tidak ada anime ditemukan.",
          style: TextStyle(color: AppColors.kSecondaryTextColor, fontSize: 16),
        ),
      );
    }

    return ListView.separated(
      padding: const EdgeInsets.all(24),
      itemCount: list.length,
      separatorBuilder: (_, __) => const SizedBox(height: 16),
      itemBuilder: (context, index) {
        final anime = list[index];
        return _buildAnimeCard(anime);
      },
    );
  }

  Widget _buildAnimeCard(AnimeModel anime) {
    return InkWell(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (_) => AnimeDetailScreen(anime: anime),
          ),
        );
      },
      child: Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: Theme.of(context).cardColor,
          borderRadius: BorderRadius.circular(16),
        ),
        child: Row(
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(12),
              child: Image.network(
                anime.imageUrl,
                height: 80,
                width: 80,
                fit: BoxFit.cover,
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
                        "Score: ${anime.score}",
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
