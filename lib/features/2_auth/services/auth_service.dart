import 'package:hive_flutter/hive_flutter.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AuthService {
  final Box _usersBox = Hive.box('users');

  Future<bool> register(String username, String password) async {
    if (username.isEmpty || password.isEmpty) {
      throw Exception("Username dan password tidak boleh kosong");
    }

    if (_usersBox.containsKey(username)) {
      throw Exception("Username sudah digunakan");
    }

    await _usersBox.put(username, password);
    return true;
  }

  Future<bool> login(String username, String password) async {
    if (!_usersBox.containsKey(username)) {
      throw Exception("Username tidak ditemukan");
    }

    final storedPassword = _usersBox.get(username);

    if (password != storedPassword) {
      throw Exception("Password salah");
    }

    final prefs = await SharedPreferences.getInstance();
    await prefs.setString("currentUser", username);

    return true;
  }

  Future<void> logout() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove("currentUser");
  }

  Future<String?> getCurrentUser() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString("currentUser");
  }

  Future<bool> isLoggedIn() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.containsKey("currentUser");
  }
}
