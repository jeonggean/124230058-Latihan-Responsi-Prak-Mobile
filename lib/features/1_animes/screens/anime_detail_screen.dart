import 'package:eventfinder/core/utils/app_colors.dart';
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

  late bool _isFavorite;
  @override
  void initState() {
    super.initState();
    _isFavorite = _favoritesService.isFavorite(widget.anime);
  }

  void _toggleFavorite() async {
    try {
      if (_isFavorite) {
        await _favoritesService.removeFavorite(widget.anime);
        setState(() {
          _isFavorite = false;
        });
      } else {
        await _favoritesService.addFavorite(widget.anime);
        setState(() {
          _isFavorite = true;
        });
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text('Error: $e')));
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          _buildBackgroundImage(),
          _buildNavigationButtons(),
           _buildContentSheet(),
        ],
      ),
    );
  }

  Widget _buildBackgroundImage() {
    return Container(
      height: MediaQuery.of(context).size.height * 0.45,
      width: double.infinity,
      child: Image.network(
        widget.anime.imageUrl,
        fit: BoxFit.cover,
        errorBuilder: (context, error, stackTrace) => Container(
          color: Theme.of(context).cardColor,
          child: const Icon(
            Icons.broken_image,
            size: 60,
            color: AppColors.kSecondaryTextColor,
          ),
        ),
      ),
    );
  }

  Widget _buildNavigationButtons() {
    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            CircleAvatar(
              backgroundColor: Colors.black.withOpacity(0.4),
              child: IconButton(
                icon: Icon(Icons.arrow_back, color: Colors.white),
                onPressed: () => Navigator.of(context).pop(),
              ),
            ),
            CircleAvatar(
              backgroundColor: Colors.black.withOpacity(0.4),
              child: IconButton(
                icon: Icon(
                  _isFavorite ? Icons.bookmark : Icons.bookmark_border_outlined,
                  color: _isFavorite
                      ? AppColors.kPrimaryColor
                      : Colors.white,
                ),
                onPressed: _toggleFavorite,
              ),
            ),
          ],
        ),
      ),
    );
  }

 Widget _buildContentSheet() {
  return Container(
    margin: EdgeInsets.only(top: MediaQuery.of(context).size.height * 0.4),
    width: double.infinity,
    decoration: BoxDecoration(
      color: Theme.of(context).scaffoldBackgroundColor,
      borderRadius: BorderRadius.vertical(top: Radius.circular(30.0)),
    ),
    child: SingleChildScrollView(
      padding: const EdgeInsets.all(24.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            widget.anime.title,
            style: GoogleFonts.nunito(
              fontWeight: FontWeight.bold,
              fontSize: 26,
              color: AppColors.kTextColor,
            ),
          ),

          const SizedBox(height: 20),
          _buildDetailItem(
            icon: Icons.star,
            title: "Score",
            subtitle: widget.anime.score.toString(),
          ),
          const SizedBox(height: 20),
          _buildDetailItem(
            icon: Icons.description,
            title: "Sinopsis",
            subtitle: widget.anime.synopsis,
          ),
        ],
      ),
    ),
  );
}


  Widget _buildDetailItem(
      {required IconData icon,
      required String title,
      required String subtitle}) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        CircleAvatar(
          radius: 24,
          backgroundColor: Theme.of(context).cardColor,
          child: Icon(icon, color: AppColors.kPrimaryColor, size: 20),
        ),
        const SizedBox(width: 16),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: GoogleFonts.nunito(
                  fontSize: 16,
                  color: AppColors.kSecondaryTextColor,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                subtitle,
                style: GoogleFonts.nunito(
                  fontSize: 17,
                  fontWeight: FontWeight.w600,
                  color: AppColors.kTextColor,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}