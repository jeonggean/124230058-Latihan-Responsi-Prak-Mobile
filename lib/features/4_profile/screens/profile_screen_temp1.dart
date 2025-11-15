import '../../../core/utils/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../2_auth/services/auth_service.dart';
import '../../2_auth/screens/login_screen.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  final AuthService _authService = AuthService();
  String? _username;

  @override
  void initState() {
    super.initState();
    _loadUserData();
  }

  Future<void> _loadUserData() async {
    final username = await _authService.getCurrentUser();
    if (mounted) {
      setState(() {
        _username = username;
      });
    }
  }

  Future<void> _logout() async {
    await _authService.logout();
    if (mounted) {
      Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(builder: (context) => LoginScreen()),
        (Route<dynamic> route) => false,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Profil Saya',
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 24.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const Spacer(flex: 1),
            CircleAvatar(
              radius: 50,
              backgroundColor: Theme.of(context).cardColor,
              backgroundImage: NetworkImage(
                  'https://placehold.co/150x150/EFEFEF/333333?text=Foto'),
            ),
            const SizedBox(height: 16),
            Text(
              'Najwa Egi Fitriyani',
              textAlign: TextAlign.center,
              style: GoogleFonts.nunito(
                fontSize: 26,
                fontWeight: FontWeight.bold,
                color: AppColors.kTextColor,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              '123220000',
              textAlign: TextAlign.center,
              style: GoogleFonts.nunito(
                fontSize: 18,
                color: AppColors.kSecondaryTextColor,
              ),
            ),
            const SizedBox(height: 12),
            Text(
              'Logged in as: ${_username ?? 'Loading...'}',
              textAlign: TextAlign.center,
              style: GoogleFonts.nunito(
                fontSize: 16,
                color: AppColors.kSecondaryTextColor,
                fontStyle: FontStyle.italic,
              ),
            ),
            const Spacer(flex: 2),
            ElevatedButton.icon(
              icon: const Icon(Icons.logout),
              label: const Text('Logout'),
              onPressed: _logout,
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.redAccent,
                foregroundColor: Colors.white,
              ),
            ),
            const Spacer(flex: 1),
          ],
        ),
      ),
    );
  }
}