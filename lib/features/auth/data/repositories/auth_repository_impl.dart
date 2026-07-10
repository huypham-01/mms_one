import 'package:flutter/foundation.dart';
import 'package:jwt_decoder/jwt_decoder.dart';
import '../../../../core/auth/token_manager.dart';
import '../../../../core/mock/mock_constants.dart';
import '../../../../core/mock/mock_mode_provider.dart';
import '../../domain/entities/login_response_entity.dart';
import '../../domain/repositories/auth_repository.dart';
import '../datasources/auth_remote_datasource.dart';

class AuthRepositoryImpl implements AuthRepository {
  final AuthRemoteDataSource _remoteDataSource;
  final TokenManager _tokenManager;
  final MockModeProvider _mockModeProvider;

  AuthRepositoryImpl(
    this._remoteDataSource,
    this._tokenManager,
    this._mockModeProvider,
  );

  @override
  Future<LoginResponseEntity> login(String username, String password, String otp) async {
    // 1. Intercept for Mock Mode
    if (username == MockConstants.mockUsername &&
        password == MockConstants.mockPassword &&
        otp == MockConstants.mockOtp) {
      
      debugPrint('[Mock] Login success');
      await _mockModeProvider.enableMockMode();
      await _tokenManager.saveToken(MockConstants.mockToken);
      
      return LoginResponseEntity(
        status: true,
        message: 'Mock Login Successful',
        accessToken: MockConstants.mockToken,
      );
    }

    // 2. Normal Login
    final response = await _remoteDataSource.login(username, password, otp);
    
    // Nếu login thành công, lưu token vào storage
    if (response.status && response.accessToken != null) {
      await _tokenManager.saveToken(response.accessToken!);
    }
    
    return response;
  }

  @override
  Future<void> logout() async {
    await _mockModeProvider.disableMockMode();
    await _tokenManager.clearToken();
  }

  @override
  Future<bool> checkLoginStatus() async {
    final token = _tokenManager.getToken();
    if (token != null && token.isNotEmpty) {
      if (JwtDecoder.isExpired(token)) {
        await logout();
        return false;
      } else {
        return true;
      }
    }
    return false;
  }

  @override
  Future<LoginResponseEntity> setPassword(String currentPassword, String password, String confirmPassword, String otp) async {
    // 1. Intercept for Mock Mode
    if (_mockModeProvider.isMockMode) {
      debugPrint('[Mock] Set Password success');
      
      return LoginResponseEntity(
        status: true,
        message: 'Mock Change Password Successful',
        accessToken: null,
      );
    }

    // 2. Normal Request
    final response = await _remoteDataSource.setPassword(currentPassword, password, confirmPassword, otp);
    
    return response;
  }

  @override
  Future<bool> getVerify(String username) async {
    try {
      final data = await _remoteDataSource.getVerify(username);
      return data['verify'] == '1' || data['verify'] == 1;
    } catch (e) {
      debugPrint('Verify API error: $e');
      return true; // Default to true if error
    }
  }
}
