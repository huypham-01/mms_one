import 'package:flutter/material.dart';
import '../../domain/usecases/change_password_usecase.dart';

class ChangePasswordProvider extends ChangeNotifier {
  final ChangePasswordUseCase _changePasswordUseCase;

  ChangePasswordProvider({
    required ChangePasswordUseCase changePasswordUseCase,
  }) : _changePasswordUseCase = changePasswordUseCase;

  bool _isLoading = false;
  bool get isLoading => _isLoading;

  String? _errorMessage;
  String? get errorMessage => _errorMessage;

  String? _successMessage;
  String? get successMessage => _successMessage;

  Future<bool> setPassword(
    String currentPassword,
    String newPassword,
    String confirmPassword,
    String otp,
  ) async {
    _isLoading = true;
    _errorMessage = null;
    _successMessage = null;
    notifyListeners();

    try {
      final response = await _changePasswordUseCase.execute(
        currentPassword,
        newPassword,
        confirmPassword,
        otp,
      );

      if (response.status) {
        _successMessage = response.message;
        _isLoading = false;
        notifyListeners();
        return true;
      } else {
        _errorMessage = response.message ?? 'Đổi mật khẩu thất bại.';
        _isLoading = false;
        notifyListeners();
        return false;
      }
    } catch (e) {
      _errorMessage = e.toString().replaceAll('Exception: ', '');
      _isLoading = false;
      notifyListeners();
      return false;
    }
  }
}
