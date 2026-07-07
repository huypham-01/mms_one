import 'package:shared_preferences/shared_preferences.dart';

class TokenManager {
  static const String _tokenKey = 'access_token';
  final SharedPreferences _prefs;

  TokenManager(this._prefs);

  Future<void> saveToken(String token) async {
    await _prefs.setString(_tokenKey, token);
  }

  String? getToken() {
    return _prefs.getString(_tokenKey);
  }

  Future<void> clearToken() async {
    await _prefs.remove(_tokenKey);
  }

  bool hasToken() {
    final token = getToken();
    return token != null && token.isNotEmpty;
  }

  bool get hasChangedPassword {
    return _prefs.getBool('has_changed_password') ?? false;
  }

  Future<void> setHasChangedPassword(bool value) async {
    await _prefs.setBool('has_changed_password', value);
  }
}
