import 'package:hive_flutter/hive_flutter.dart';

class AuthService {
  final Box _usersBox = Hive.box('users');
  final Box _sessionBox = Hive.box('session');

  Future<bool> register(String username, String password) async {
    if (username.isEmpty || password.isEmpty) {
      throw Exception("Username dan password tidak boleh kosong");
    }

    if (_usersBox.containsKey(username)) {
      throw Exception("Username sudah terpakai");
    }

    await _usersBox.put(username, password);
    return true;
  }

  Future<bool> login(String username, String password) async {
    if (!_usersBox.containsKey(username)) {
      throw Exception("Username tidak ditemukan");
    }

    final String storedPassword = _usersBox.get(username);

     if (password == storedPassword) {
      await _sessionBox.put("currentUser", username);
      return true;
    } else {
      throw Exception("Password salah");
    }
  }

  Future<void> logout() async {
    await _sessionBox.delete("currentUser");
  }

  String? getCurrentUser() {
    return _sessionBox.get("currentUser");
  }

  bool isLoggedIn() {
    return _sessionBox.containsKey("currentUser");
  }
}
