import 'package:eventfinder/core/utils/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../controllers/anime_controller.dart';
import '../models/anime_model.dart';
import 'anime_detail_screen.dart'; 

class AnimeListScreen extends StatefulWidget {
  AnimeListScreen({super.key});

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
            _buildCustomAppBar(),
            _buildSearchBar(),
            Expanded(
              child: _buildAnimeList(_controller.animesToShow),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCustomAppBar() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(24.0, 16.0, 24.0, 8.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Halo, User!', //belum diganti
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
            child: Icon(
              Icons.person_outline,
              color: AppColors.kSecondaryTextColor,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSearchBar() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 12.0),
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
            borderRadius: BorderRadius.circular(15.0),
            borderSide: BorderSide.none,
          ),
          contentPadding: const EdgeInsets.symmetric(vertical: 16.0),
        ),
        onChanged: (value) => setState(() {}),
        onSubmitted: (String keyword) {
          _controller.searchAnime(keyword);
        },
      ),
    );
  }

  Widget _buildAnimeList(List<AnimeModel> animes) {
    if (_controller.isLoading) {
      return Center(
          child: CircularProgressIndicator(
              color: Theme.of(context).colorScheme.primary));
    }

    if (_controller.errorMessage.isNotEmpty && animes.isEmpty) {
      String displayError = _controller.errorMessage.contains('Gagal memuat data')
          ? 'Gagal mengambil data dari server. Cek koneksi internetmu.'
          : 'Terjadi kesalahan.';
      return Center(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Text(
            displayError,
            textAlign: TextAlign.center,
            style: TextStyle(color: Colors.red.shade700, fontSize: 16),
          ),
        ),
      );
    }

    if (animes.isEmpty) {
      String message = _searchController.text.isNotEmpty
          ? 'Tidak ada anime ditemukan untuk "${_searchController.text}".'
          : 'Tidak ada anime ditemukan.';
      return Center(
          child: Text(message,
              style:
                  TextStyle(color: AppColors.kSecondaryTextColor, fontSize: 16),
              textAlign: TextAlign.center));
    }

    return ListView.separated(
      key: PageStorageKey('anime_list'),
      padding: const EdgeInsets.all(24.0),
      itemCount: animes.length,
      separatorBuilder: (context, index) => const SizedBox(height: 16),
      itemBuilder: (context, index) {
        final AnimeModel anime = animes[index];
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
            builder: (context) => AnimeDetailScreen(anime: anime),
          ),
        );
      },
      child: Container(
        padding: const EdgeInsets.all(12.0),
        decoration: BoxDecoration(
          color: Theme.of(context).cardColor,
          borderRadius: BorderRadius.circular(16.0),
        ),
        child: Row(
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(12.0),
              child: Image.network(
                anime.imageUrl, // Data dari model anime
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
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    anime.title, // Data dari model anime [cite: 853]
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