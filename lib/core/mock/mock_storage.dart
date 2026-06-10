import 'package:shared_preferences/shared_preferences.dart';

class MockStorage {
  static const String _mockModeKey = 'is_mock_mode';
  final SharedPreferences _prefs;

  MockStorage(this._prefs);

  Future<void> saveMockMode(bool isMockMode) async {
    await _prefs.setBool(_mockModeKey, isMockMode);
  }

  bool getMockMode() {
    return _prefs.getBool(_mockModeKey) ?? false;
  }

  Future<void> clear() async {
    await _prefs.remove(_mockModeKey);
  }
}
