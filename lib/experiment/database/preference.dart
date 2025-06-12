import 'package:shared_preferences/shared_preferences.dart';

class PreferenceHandler {
  /// Key untuk menyimpan status login di SharedPreferences
  static const String _loginKey = "login";

  /// Menyimpan status login ke SharedPreferences
  static Future<void> saveLogin(String id) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString(_loginKey, id);
    } catch (e) {
      print("Error saving login: $e");
      throw Exception("Gagal menyimpan status login");
    }
  }

  /// Mengambil status login dari SharedPreferences
  static Future<String> getLogin() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      String? login = prefs.getString(_loginKey);
      return login?? '';
    } catch (e) {
      print("Error getting login: $e");
      return ''; // Fallback ke false kalau error
    }
  }

}
