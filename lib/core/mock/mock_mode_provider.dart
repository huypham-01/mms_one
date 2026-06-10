import 'package:flutter/material.dart';
import 'mock_storage.dart';

class MockModeProvider extends ChangeNotifier {
  final MockStorage _mockStorage;
  bool _isMockMode = false;

  bool get isMockMode => _isMockMode;

  MockModeProvider(this._mockStorage) {
    loadMockMode();
  }

  Future<void> loadMockMode() async {
    _isMockMode = _mockStorage.getMockMode();
    if (_isMockMode) {
      debugPrint('[Mock] Mode is currently enabled from storage');
    }
    notifyListeners();
  }

  Future<void> enableMockMode() async {
    if (!_isMockMode) {
      _isMockMode = true;
      await _mockStorage.saveMockMode(true);
      debugPrint('[Mock] Mode enabled');
      notifyListeners();
    }
  }

  Future<void> disableMockMode() async {
    if (_isMockMode) {
      _isMockMode = false;
      await _mockStorage.saveMockMode(false);
      debugPrint('[Mock] Mode disabled');
      notifyListeners();
    }
  }
}
