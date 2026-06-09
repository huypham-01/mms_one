import 'package:shared_preferences/shared_preferences.dart';

class StorageService {
  static const String _accessTokenKey = 'access_token';
  static const String _refreshTokenKey = 'refresh_token';
  static const String _permissionsKey = 'app_permissions';

  final SharedPreferences _prefs;

  StorageService(this._prefs);

  /// Lưu trữ bộ đôi token
  Future<void> saveTokens({
    required String accessToken,
    required String refreshToken,
  }) async {
    await _prefs.setString(_accessTokenKey, accessToken);
    await _prefs.setString(_refreshTokenKey, refreshToken);
  }

  /// Đọc Access Token
  String? getAccessToken() {
    return _prefs.getString(_accessTokenKey);
  }

  /// Đọc Refresh Token
  String? getRefreshToken() {
    return _prefs.getString(_refreshTokenKey);
  }

  /// Xóa token khi đăng xuất hoặc lỗi bảo mật
  Future<void> clearTokens() async {
    await _prefs.remove(_accessTokenKey);
    await _prefs.remove(_refreshTokenKey);
  }

  /// Lưu trữ permissions cache
  Future<void> savePermissions(List<String> permissions) async {
    await _prefs.setStringList(_permissionsKey, permissions);
  }

  /// Đọc permissions cache
  List<String>? getPermissions() {
    return _prefs.getStringList(_permissionsKey);
  }

  /// Xóa permissions cache
  Future<void> clearPermissions() async {
    await _prefs.remove(_permissionsKey);
  }
}
