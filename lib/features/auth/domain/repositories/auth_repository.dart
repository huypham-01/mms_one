import '../entities/login_response_entity.dart';

abstract class AuthRepository {
  Future<LoginResponseEntity> login(String username, String password, String otp);
  Future<LoginResponseEntity> setPassword(String currentPassword, String password, String confirmPassword, String otp);
  Future<void> logout();
  Future<bool> checkLoginStatus();
}
