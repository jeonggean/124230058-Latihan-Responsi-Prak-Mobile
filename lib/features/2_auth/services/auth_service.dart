import 'package:hive_flutter/hive_flutter.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/auth_model.dart';

class AuthService {
  final Box<User> _usersBox = Hive.box<User>('userBox');

  Future<bool> register(String username, String password) async {
    if (username.isEmpty || password.isEmpty) {
      throw Exception("Username dan password tidak boleh kosong");
    }

    if (_usersBox.containsKey(username)) {
      throw Exception("Username sudah digunakan");
    }

    final user = User(username: username, password: password);
    await _usersBox.put(username, user);

    return true;
  }

  Future<bool> login(String username, String password) async {
    final user = _usersBox.get(username);

    if (user == null) {
      throw Exception("Username tidak ditemukan");
    }

    if (password != user.password) {
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